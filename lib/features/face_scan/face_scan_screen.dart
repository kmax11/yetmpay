import 'dart:async';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/icons/app_icons.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_outlined_button.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/app_progress_bar.dart';
import '../../core/widgets/app_scan_viewport.dart';
import '../../core/widgets/app_text_link_button.dart';
import '../charging/payment_notifier.dart';

/// Face Scan Verification Screen (Figma node 1-537).
///
/// Top-level route that covers the shell bottom navigation bar.
/// Uses the device camera if available with corner brackets, oval face ring,
/// animated laser line, and simulated biometric verification lifecycle.
///
/// If no face is recognized, displays an error image/state and provides
/// seamless fallback to the fingerprint authorization screen.
class FaceScanScreen extends StatefulWidget {
  const FaceScanScreen({super.key});

  @override
  State<FaceScanScreen> createState() => _FaceScanScreenState();
}

class _FaceScanScreenState extends State<FaceScanScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;

  bool _hasNoFace = false;
  Timer? _autoFingerprintTimer;
  Timer? _phaseTimer;
  Timer? _failureTimer;
  String _scanPhase = 'Initializing camera…';

  // Realistic scanning phases
  static const _phases = [
    'Initializing camera…',
    'Detecting face position…',
    'Analyzing facial geometry…',
    'Matching biometric template…',
    'Verifying identity…',
    'Confirming with Fayda ID…',
  ];

  @override
  void initState() {
    super.initState();
    _initCamera();

    // Controller created here; _startScan sets its duration each time
    _progressController = AnimationController(vsync: this, duration: const Duration(seconds: 8));
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    )..addListener(() => setState(() {}))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted && !_hasNoFace) {
          _phaseTimer?.cancel();
          _failureTimer?.cancel();
          _handleVerificationComplete();
        }
      });

    _startScan();
  }

  void _startScan() {
    final rng = math.Random();

    // Scan duration: 7–10 seconds for realism
    final scanMs = 7000 + rng.nextInt(3001);
    _progressController.duration = Duration(milliseconds: scanMs);

    _startPhaseLabels(scanMs);

    // 40% chance: fail mid-scan at 60–80% of total duration
    final willFail = rng.nextDouble() < 0.40;
    if (willFail) {
      final failAt = (scanMs * (0.60 + rng.nextDouble() * 0.20)).toInt();
      _failureTimer = Timer(Duration(milliseconds: failAt), () {
        if (mounted && !_hasNoFace) {
          _triggerNoFaceError();
        }
      });
    }

    // Realistic stutter: pause at ~65% to simulate deep processing
    final stutterAt = (scanMs * 0.65).toInt();
    final stutterDuration = 800 + rng.nextInt(700);
    Future.delayed(Duration(milliseconds: stutterAt), () {
      if (mounted && !_hasNoFace && _progressController.isAnimating) {
        _progressController.stop();
        setState(() => _scanPhase = 'Processing biometric data…');
        Future.delayed(Duration(milliseconds: stutterDuration), () {
          if (mounted && !_hasNoFace) {
            _progressController.forward();
          }
        });
      }
    });

    _progressController.forward();
  }

  void _startPhaseLabels(int totalMs) {
    final stepMs = totalMs ~/ _phases.length;
    for (int i = 0; i < _phases.length; i++) {
      Future.delayed(Duration(milliseconds: stepMs * i), () {
        if (mounted && !_hasNoFace) {
          setState(() => _scanPhase = _phases[i]);
        }
      });
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // Prefer front camera for face scanning
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();
      if (mounted) {
        setState(() => _cameraController = controller);
      }
    } catch (_) {
      // Camera unavailable (e.g. desktop/emulator) -> graceful fallback to dark placeholder
    }
  }

  void _handleVerificationComplete() {
    final payment = context.read<PaymentNotifier>();

    // Generate a transaction ID for this attempt.
    final txId =
        'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(4)}-ET';

    // The mock biometric service returns only a masked name — never a photo
    // or full account number.
    const maskedBuyerName = 'Selam D.';

    payment.enterAwaitingApproval(
      maskedBuyerName: maskedBuyerName,
      shopName: 'Bole Fresh Mart',
      transactionId: txId,
    );

    context.pushReplacement('/approval');
  }

  void _triggerNoFaceError() {
    _phaseTimer?.cancel();
    _failureTimer?.cancel();
    _progressController.stop();
    setState(() {
      _hasNoFace = true;
      _scanPhase = 'No face detected';
    });

    // Auto-redirect to fingerprint: 5–7 seconds so merchant can see the state
    final redirectMs = 5000 + math.Random().nextInt(2001);
    _autoFingerprintTimer?.cancel();
    _autoFingerprintTimer = Timer(Duration(milliseconds: redirectMs), () {
      if (mounted && _hasNoFace) {
        context.pushReplacement('/payment-processing');
      }
    });
  }

  void _retryScan() {
    _autoFingerprintTimer?.cancel();
    _failureTimer?.cancel();
    _progressController.reset();
    setState(() {
      _hasNoFace = false;
      _scanPhase = 'Initializing camera…';
    });
    _startScan();
  }

  @override
  void dispose() {
    _autoFingerprintTimer?.cancel();
    _phaseTimer?.cancel();
    _failureTimer?.cancel();
    _cameraController?.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final payment = context.watch<PaymentNotifier>();
    final percent = (_progressAnimation.value * 100).toInt();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadH2,
            vertical: AppSpacing.md,
          ),
          child: Column(
            children: [
              // ── Header Nav Bar ───────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      AppIcons.close,
                      size: 24,
                      color: AppColors.subtleMuted,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    '${AppStrings.charging} ${payment.displayAmount} ETB',
                    style: AppTextStyles.semiBoldLarge.copyWith(
                      color: AppColors.darkText,
                    ),
                  ),
                  // Test Trigger / Simulation button
                  GestureDetector(
                    onTap: _hasNoFace ? _retryScan : _triggerNoFaceError,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _hasNoFace
                            ? AppColors.railSuccessBg
                            : AppColors.errorRedBg,
                        borderRadius: AppRadius.pillAll,
                        border: Border.all(
                          color: _hasNoFace
                              ? AppColors.railGreen
                              : AppColors.errorRedBorder,
                        ),
                      ),
                      child: Text(
                        _hasNoFace ? 'Retry' : 'No Face?',
                        style: AppTextStyles.semiBoldBadge.copyWith(
                          color: _hasNoFace
                              ? AppColors.railSuccessText
                              : AppColors.errorRed,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Dark Viewport with Camera & Laser / Error Visual ──────────
              Center(
                child: AppScanViewport(
                  cameraController: _cameraController,
                  hasError: _hasNoFace,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Dynamic Guidance Message or Error Title ──────────────────
              if (_hasNoFace) ...[
                Text(
                  AppStrings.noFaceRecognized,
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.errorRed,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppStrings.noFaceSub,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.mutedText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                Text(
                  AppStrings.positionFace,
                  style: AppTextStyles.semiBoldLarge.copyWith(
                    color: AppColors.darkText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),

              // ── Progress Bar (Scanning Mode) or Action Buttons (Error Mode) ─
              if (!_hasNoFace)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.scanLive,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                _scanPhase,
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.subtleMuted,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$percent%',
                            style: AppTextStyles.monoSmall.copyWith(
                              color: AppColors.darkText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppProgressBar(value: _progressAnimation.value),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    children: [
                      AppPrimaryButton(
                        label: AppStrings.continueWithFingerprint,
                        leadingIcon: AppIcons.fingerprint,
                        onPressed: () {
                          _autoFingerprintTimer?.cancel();
                          context.pushReplacement('/payment-processing');
                        },
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppOutlinedButton(
                        label: AppStrings.retryScan,
                        leadingIcon: AppIcons.refresh,
                        onPressed: _retryScan,
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              // ── Bottom Action / Privacy ──────────────────────────────────
              if (!_hasNoFace)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: AppRadius.pillAll,
                    border: Border.all(color: AppColors.borderDefault),
                    boxShadow: AppShadows.cardShadow,
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      context.pushReplacement('/payment-processing');
                    },
                    icon: const Icon(
                      AppIcons.fingerprint,
                      size: 20,
                      color: AppColors.subtleMuted,
                    ),
                    label: Text(
                      AppStrings.switchToFingerprint,
                      style: AppTextStyles.semiBoldSmall.copyWith(
                        color: AppColors.darkText,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.md,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: AppSpacing.md),

              // ── Privacy Notice ────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    AppIcons.lock,
                    size: 13,
                    color: AppColors.mutedText,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    AppStrings.biometricPrivacy,
                    style: AppTextStyles.bodyXXS.copyWith(
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),

              // ── Cancel Sale Button ────────────────────────────────────────
              AppTextLinkButton(
                text: AppStrings.cancelSale,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.mutedText,
                ),
                onPressed: () {
                  _autoFingerprintTimer?.cancel();
                  payment.reset();
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
