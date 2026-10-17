import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/icons/app_icons.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_frosted_header.dart';
import '../../core/widgets/app_outlined_button.dart';
import '../../core/widgets/app_primary_button.dart';
import 'terminal_notifier.dart';

/// Terminal Screen (Figma node 1-200).
///
/// Displays verified merchant profile, dynamic counter standee QR code,
/// and primary navigation to the charging / payment terminal.
class TerminalScreen extends StatelessWidget {
  const TerminalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final terminal = context.watch<TerminalNotifier>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppFrostedHeader(
        child: Row(
          children: [
            // Store Icon Circle
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen10,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                AppIcons.store,
                size: 18,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Store Name & Status
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        terminal.merchantName,
                        style: AppTextStyles.headingSmall.copyWith(
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.railSuccessBg,
                          borderRadius: AppRadius.pillAll,
                        ),
                        child: Text(
                          AppStrings.online,
                          style: AppTextStyles.semiBoldBadge.copyWith(
                            color: AppColors.railSuccessText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    terminal.terminalNumber,
                    style: AppTextStyles.labelXXS.copyWith(
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),

            // Notifications Bell
            IconButton(
              icon: const Icon(
                AppIcons.notifications,
                size: 20,
                color: AppColors.subtleMuted,
              ),
              onPressed: () {},
            ),
            const SizedBox(width: AppSpacing.xs),

            // Merchant Initials Avatar
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  terminal.merchantInitials,
                  style: AppTextStyles.semiBoldSmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadH,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Headline ───────────────────────────────────────────────────
            Text(
              AppStrings.terminalReady,
              style: AppTextStyles.heading1.copyWith(
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppStrings.terminalReadySub,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.mutedText,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Merchant Profile Card ──────────────────────────────────────
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.merchantProfile,
                        style: AppTextStyles.capsLabel.copyWith(
                          color: AppColors.mutedText,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppRadius.badgeSmallAll,
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${AppStrings.terminalId}: ',
                              style: AppTextStyles.semiBoldXS.copyWith(
                                color: AppColors.mutedText,
                              ),
                            ),
                            Text(
                              terminal.terminalId,
                              style: AppTextStyles.monoSmall.copyWith(
                                color: AppColors.darkText,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: terminal.copyTerminalId,
                              child: Icon(
                                terminal.idCopied
                                    ? AppIcons.check
                                    : AppIcons.copy,
                                size: 14,
                                color: terminal.idCopied
                                    ? AppColors.railGreen
                                    : AppColors.primaryGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Text(
                        terminal.merchantName,
                        style: AppTextStyles.heading2.copyWith(
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const Icon(
                        AppIcons.shieldCheck,
                        size: 18,
                        color: AppColors.railGreen,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  Row(
                    children: [
                      const Icon(
                        AppIcons.locationPin,
                        size: 14,
                        color: AppColors.mutedText,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        terminal.merchantLocation,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppSpacing.md),

                  // Payout Rail Row
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen10,
                          borderRadius: AppRadius.badgeSmallAll,
                        ),
                        child: const Icon(
                          AppIcons.lightning,
                          size: 18,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                terminal.payoutRail,
                                style: AppTextStyles.semiBoldMedium.copyWith(
                                  color: AppColors.darkText,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.railSuccessBg,
                                  borderRadius: AppRadius.badgeSmallAll,
                                ),
                                child: Text(
                                  AppStrings.payoutConnected,
                                  style: AppTextStyles.semiBoldBadge.copyWith(
                                    color: AppColors.railSuccessText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            terminal.payoutPhone,
                            style: AppTextStyles.monoMedium.copyWith(
                              color: AppColors.mutedText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Counter Standee QR Card ────────────────────────────────────
            AppCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.counterStandeeQR,
                        style: AppTextStyles.capsLabel.copyWith(
                          color: AppColors.mutedText,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.railSuccessBg,
                          borderRadius: AppRadius.pillAll,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.railGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              AppStrings.readyToScan,
                              style: AppTextStyles.semiBoldBadge.copyWith(
                                color: AppColors.railSuccessText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Real QR Code via qr_flutter
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: AppRadius.cardLargeAll,
                      border: Border.all(color: AppColors.borderLight),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: QrImageView(
                      data: terminal.terminalId,
                      version: QrVersions.auto,
                      size: 176,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: AppColors.darkText,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: AppColors.darkText,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  Text(
                    AppStrings.qrSupports,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.mutedText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Instructions Card ──────────────────────────────────────────
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
                    child: Text(
                      AppStrings.instructionText,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.subtleMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // ── Primary Actions ────────────────────────────────────────────
            AppPrimaryButton(
              label: AppStrings.openPaymentTerminal,
              leadingIcon: AppIcons.lightning,
              onPressed: () => context.go('/charging'),
            ),
            const SizedBox(height: AppSpacing.md),

            AppOutlinedButton(
              label: AppStrings.downloadStandeePDF,
              leadingIcon: AppIcons.download,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Downloading Counter Standee PDF...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}
