import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/icons/app_icons.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_progress_bar.dart';
import '../../core/widgets/app_scan_viewport.dart';
import '../../core/widgets/app_text_link_button.dart';
import '../charging/payment_notifier.dart';

/// Face Scan Verification Screen (Figma node 1-537).
///
/// Top-level route that covers the shell bottom navigation bar.
/// Uses the device camera if available with corner brackets, oval face ring,
/// animated laser line, and simulated biometric verification lifecycle.
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

  @override
  void initState() {
    super.initState();
    _initCamera();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          _handleVerificationComplete();
        }
      });

    // Start verification
    _progressController.forward();
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
    context.read<PaymentNotifier>().processPayment();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.cardLargeAll,
          ),
          contentPadding: const EdgeInsets.all(AppSpacing.xxl),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.railSuccessBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  AppIcons.checkCircle,
                  color: AppColors.railGreen,
                  size: 40,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Payment Confirmed',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Instant settlement deposit received.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.mutedText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () {
                  context.read<PaymentNotifier>().reset();
                  Navigator.of(ctx).pop();
                  context.go('/terminal');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.buttonPrimaryAll,
                  ),
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Back to Terminal'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
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
                  const SizedBox(width: 48), // Balancing spacer
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Dark Viewport with Camera & Laser ─────────────────────────
              Center(
                child: AppScanViewport(
                  cameraController: _cameraController,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Guidance Message ──────────────────────────────────────────
              Text(
                AppStrings.positionFace,
                style: AppTextStyles.semiBoldLarge.copyWith(
                  color: AppColors.darkText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Auto-verifying Progress Bar ───────────────────────────────
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
                              AppStrings.autoVerifying,
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
              ),

              const Spacer(),

              // ── Switch to Fingerprint Button ──────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: AppRadius.pillAll,
                  border: Border.all(color: AppColors.borderDefault),
                  boxShadow: AppShadows.cardShadow,
                ),
                child: TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Switched to fingerprint sensor mode.'),
                        duration: Duration(seconds: 1),
                      ),
                    );
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
              const SizedBox(height: AppSpacing.lg),

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
              const SizedBox(height: AppSpacing.sm),

              // ── Cancel Sale Button ────────────────────────────────────────
              AppTextLinkButton(
                text: AppStrings.cancelSale,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.mutedText,
                ),
                onPressed: () {
                  payment.reset();
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
