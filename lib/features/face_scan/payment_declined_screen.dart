import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/icons/app_icons.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_outlined_button.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/app_text_link_button.dart';
import '../charging/payment_notifier.dart';

/// Payment Declined Screen (Figma node 4-169).
///
/// Displays biometric mismatch diagnostics (ERR_BIO_MISMATCH, camera confidence,
/// Fayda ID masking), recommended troubleshooting steps, and retry / fallback CTAs.
class PaymentDeclinedScreen extends StatelessWidget {
  const PaymentDeclinedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final payment = context.watch<PaymentNotifier>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadH2,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Top Header Navigation ────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      AppIcons.close,
                      size: 24,
                      color: AppColors.subtleMuted,
                    ),
                    onPressed: () {
                      payment.reset();
                      context.go('/terminal');
                    },
                  ),
                  Column(
                    children: [
                      Text(
                        '${AppStrings.charging} ${payment.displayAmount} ETB',
                        style: AppTextStyles.semiBoldMedium.copyWith(
                          color: AppColors.darkText,
                        ),
                      ),
                      Text(
                        'Terminal #CBE-8842',
                        style: AppTextStyles.bodyXXS.copyWith(
                          color: AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 48), // Balance spacing
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Red Warning Icon ─────────────────────────────────────────
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors.errorRedBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.errorRedBorder,
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    AppIcons.warning,
                    color: AppColors.errorRed,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Declined Title & Amount ──────────────────────────────────
              Text(
                AppStrings.paymentDeclined,
                style: AppTextStyles.capsLabelSemiBold.copyWith(
                  color: AppColors.errorRed,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${payment.displayAmount} ETB',
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.darkText,
                  fontSize: 34,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Diagnostic Error Card ────────────────────────────────────
              AppCard(
                borderColor: AppColors.errorRedBorder,
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                color: AppColors.errorRed,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              AppStrings.identityNotVerified,
                              style: AppTextStyles.semiBoldMedium.copyWith(
                                color: AppColors.darkText,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.errorRedBg,
                            borderRadius: AppRadius.pillAll,
                            border: Border.all(color: AppColors.errorRedBorder),
                          ),
                          child: Text(
                            AppStrings.errBioMismatch,
                            style: AppTextStyles.semiBoldBadge.copyWith(
                              color: AppColors.errorRed,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      AppStrings.faceContourFailed,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Diagnostic Two-Column Row ────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: AppRadius.cardLargeAll,
                        border: Border.all(color: AppColors.borderDefault),
                        boxShadow: AppShadows.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.nationalFaydaId,
                            style: AppTextStyles.bodyXXS.copyWith(
                              color: AppColors.mutedText,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '•••• 8812',
                            style: AppTextStyles.monoMedium.copyWith(
                              color: AppColors.darkText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: AppRadius.cardLargeAll,
                        border: Border.all(color: AppColors.borderDefault),
                        boxShadow: AppShadows.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.cameraConfidence,
                            style: AppTextStyles.bodyXXS.copyWith(
                              color: AppColors.mutedText,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Text(
                                '42%',
                                style: AppTextStyles.monoMedium.copyWith(
                                  color: AppColors.errorRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                AppStrings.minConfidence,
                                style: AppTextStyles.bodyXXS.copyWith(
                                  color: AppColors.mutedText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Recommended Next Step Card ───────────────────────────────
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: AppRadius.cardLargeAll,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: const Icon(
                        AppIcons.bulb,
                        size: 18,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.recommendedNextStep,
                            style: AppTextStyles.semiBoldMedium.copyWith(
                              color: AppColors.darkText,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            AppStrings.repositionCustomer,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.subtleMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Action Buttons ───────────────────────────────────────────
              AppPrimaryButton(
                label: AppStrings.tryFaceScanAgain,
                leadingIcon: AppIcons.faceId,
                onPressed: () {
                  context.pushReplacement('/face-scan');
                },
              ),
              const SizedBox(height: AppSpacing.md),

              AppOutlinedButton(
                label: AppStrings.useOtpFallback,
                leadingIcon: AppIcons.sms,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'OTP fallback sent to customer phone (+251 91 ••• 8821)',
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),

              AppTextLinkButton(
                text: AppStrings.cancelSale,
                onPressed: () {
                  payment.reset();
                  context.go('/terminal');
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

