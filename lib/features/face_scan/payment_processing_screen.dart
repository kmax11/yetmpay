import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/icons/app_icons.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_card.dart';
import '../charging/payment_notifier.dart';
import '../terminal/terminal_notifier.dart';
import '../transactions/transaction_notifier.dart';

/// Payment Processing Screen (Figma node 3-2).
///
/// Displays real-time biometric and ledger clearing animation with 3 checklist
/// steps before transitioning to Payment Success or Declined.
class PaymentProcessingScreen extends StatefulWidget {
  const PaymentProcessingScreen({super.key, this.isDemoDecline = false});

  final bool isDemoDecline;

  @override
  State<PaymentProcessingScreen> createState() => _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;
  int _currentStep = 1; // 0: verifying, 1: balance check, 2: completing
  Timer? _stepTimer;
  Timer? _completeTimer;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _stepTimer = Timer(const Duration(milliseconds: 1100), () {
      if (mounted) {
        setState(() => _currentStep = 2);
      }
    });

    _completeTimer = Timer(const Duration(milliseconds: 2300), () {
      if (!mounted) return;
      if (widget.isDemoDecline) {
        context.read<PaymentNotifier>().decline(AppStrings.faceContourFailed);
        context.go('/payment-declined');
      } else {
        final payment = context.read<PaymentNotifier>();
        final amount =
            payment.numericAmount > 0 ? payment.numericAmount : 350.00;
        final rail = payment.selectedRailName;
        final phone = payment.recipientPhone;

        payment.markSuccess();

        context.read<TransactionNotifier>().recordTransaction(
              amount: amount,
              rail: rail,
              customerName: 'Abebe Kebede',
              maskedAccount:
                  phone.isNotEmpty ? '+251 $phone' : '+251 91 ••• 8821',
              channel: '$rail Biometric Fingerprint',
            );

        context.read<TerminalNotifier>().recordSettledSale(amount);

        context.go('/payment-success');
      }
    });
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    _completeTimer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final payment = context.watch<PaymentNotifier>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadH2,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xl),

              // ── Payment in Progress Pill ─────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.railSuccessBg,
                  borderRadius: AppRadius.pillAll,
                  border: Border.all(
                    color: AppColors.railGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.railGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      AppStrings.paymentInProgress,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.railSuccessText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Amount Heading ───────────────────────────────────────────
              Text(
                '${payment.displayAmount} ETB',
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.darkText,
                  fontSize: 38,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.biometricInstantAuth,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mutedText,
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // ── Animated Biometric Ring & Icon ───────────────────────────
              Center(
                child: SizedBox(
                  width: 130,
                  height: 130,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Rotating Progress Ring
                      RotationTransition(
                        turns: _rotationController,
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            value: 0.75,
                            backgroundColor:
                                AppColors.railGreen.withValues(alpha: 0.15),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.railGreen,
                            ),
                          ),
                        ),
                      ),
                      // Inner Green Fingerprint Box
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGreen.withValues(alpha: 0.25),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          AppIcons.fingerprint,
                          size: 40,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // ── Steps Card ───────────────────────────────────────────────
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    _buildStepRow(
                      icon: AppIcons.checkCircle,
                      iconColor: AppColors.railGreen,
                      title: AppStrings.verifyingIdentity,
                      subtitle: AppStrings.twoFactorConfirmed,
                      statusText: '0.4s',
                      statusColor: AppColors.mutedText,
                      isCompleted: true,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Divider(color: AppColors.divider, height: 1),
                    ),
                    _buildStepRow(
                      icon: _currentStep >= 1
                          ? AppIcons.checkCircle
                          : AppIcons.refresh,
                      iconColor: _currentStep >= 2
                          ? AppColors.railGreen
                          : AppColors.primaryGreen,
                      title: AppStrings.checkingBalance,
                      subtitle: AppStrings.queryingLiquidity,
                      statusText: _currentStep >= 2
                          ? '0.8s'
                          : AppStrings.inProgressLabel,
                      statusColor: _currentStep >= 2
                          ? AppColors.mutedText
                          : AppColors.primaryGreen,
                      isCompleted: _currentStep >= 2,
                      isInProgress: _currentStep == 1,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Divider(color: AppColors.divider, height: 1),
                    ),
                    _buildStepRow(
                      icon: _currentStep >= 2
                          ? AppIcons.refresh
                          : AppIcons.checkCircle,
                      iconColor: _currentStep >= 2
                          ? AppColors.primaryGreen
                          : AppColors.borderLight,
                      title: AppStrings.completingPayment,
                      subtitle: AppStrings.awaitingClearance,
                      statusText: _currentStep >= 2
                          ? AppStrings.inProgressLabel
                          : AppStrings.pendingLabel,
                      statusColor: _currentStep >= 2
                          ? AppColors.primaryGreen
                          : AppColors.mutedText,
                      isCompleted: false,
                      isInProgress: _currentStep >= 2,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ── Security Footer ──────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    AppIcons.lock,
                    size: 14,
                    color: AppColors.mutedText,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    AppStrings.tlsSecured,
                    style: AppTextStyles.monoSmall.copyWith(
                      color: AppColors.mutedText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              Text(
                AppStrings.settlementDisclaimer,
                style: AppTextStyles.bodyXXS.copyWith(
                  color: AppColors.slatePlaceholder,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String statusText,
    required Color statusColor,
    required bool isCompleted,
    bool isInProgress = false,
  }) {
    return Row(
      children: [
        if (isInProgress)
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(iconColor),
            ),
          )
        else
          Icon(icon, size: 22, color: iconColor),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.semiBoldMedium.copyWith(
                  color: isCompleted || isInProgress
                      ? AppColors.darkText
                      : AppColors.mutedText,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.bodyXS.copyWith(
                  color: AppColors.mutedText,
                ),
              ),
            ],
          ),
        ),
        Text(
          statusText,
          style: AppTextStyles.labelXS.copyWith(
            color: statusColor,
            fontWeight: isInProgress ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
