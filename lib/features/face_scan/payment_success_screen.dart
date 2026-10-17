import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../transactions/transaction_notifier.dart';

/// Payment Success Screen (Figma node 3-79).
///
/// Confirms verified instant biometric settlement with transaction receipt details,
/// zero dispute guarantee, and CTAs for a new sale or sending receipt.
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final payment = context.watch<PaymentNotifier>();
    final txNotifier = context.watch<TransactionNotifier>();
    final tx = txNotifier.selectedTransaction;

    final transactionRef = tx?.id ?? 'TX-984321-ET';
    final customerName = tx?.customerName ?? 'Abebe K.';
    final railName = tx?.rail ??
        (payment.selectedRailName.isNotEmpty
            ? payment.selectedRailName
            : 'Telebirr SuperApp');
    final displayAmount = payment.numericAmount > 0
        ? payment.displayAmount
        : (tx != null ? TransactionNotifier.formatAmount(tx.amount) : '350.00');
    final formattedTime =
        tx?.time != null ? 'Today, ${tx!.time}' : 'Today, 2:45 PM';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadH2,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Top Header Row ───────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
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
                          AppStrings.settledVerified,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.railSuccessText,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      AppIcons.print,
                      size: 20,
                      color: AppColors.subtleMuted,
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Printing receipt...'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Hero Success Check Icon ──────────────────────────────────
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.railSuccessBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.railGreen.withValues(alpha: 0.35),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    AppIcons.checkCircle,
                    color: AppColors.primaryGreen,
                    size: 44,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Amount & Status ──────────────────────────────────────────
              Text(
                '$displayAmount ETB',
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.darkText,
                  fontSize: 38,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.paymentSuccessful,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mutedText,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Payment Details Card ─────────────────────────────────────
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.paymentDetails,
                          style: AppTextStyles.headingSmall.copyWith(
                            color: AppColors.darkText,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.railSuccessBg,
                            borderRadius: AppRadius.pillAll,
                          ),
                          child: Text(
                            AppStrings.instantSettlement,
                            style: AppTextStyles.semiBoldBadge.copyWith(
                              color: AppColors.railSuccessText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Divider(color: AppColors.divider, height: 1),
                    const SizedBox(height: AppSpacing.md),

                    _buildDetailRow(
                      label: 'Customer',
                      valueWidget: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            customerName,
                            style: AppTextStyles.semiBoldMedium.copyWith(
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: AppColors.railGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  AppStrings.biometricVerified,
                                  style: AppTextStyles.semiBoldBadge.copyWith(
                                    color: AppColors.railSuccessText,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _buildDetailRow(
                      label: AppStrings.paymentRailLabel,
                      valueWidget: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildRailBadge(railName),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            railName,
                            style: AppTextStyles.semiBoldMedium.copyWith(
                              color: AppColors.darkText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _buildDetailRow(
                      label: AppStrings.terminalLabel,
                      valueWidget: Text(
                        'YETM-Terminal #04',
                        style: AppTextStyles.semiBoldMedium.copyWith(
                          color: AppColors.darkText,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _buildDetailRow(
                      label: 'Time',
                      valueWidget: Text(
                        formattedTime,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.darkText,
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),
                    const Divider(color: AppColors.divider, height: 1),
                    const SizedBox(height: AppSpacing.md),

                    // Transaction ref row with copy button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.transactionRef,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.mutedText,
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(6),
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: transactionRef),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Transaction Ref copied!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  transactionRef,
                                  style: AppTextStyles.monoSmall.copyWith(
                                    color: AppColors.darkText,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                const Icon(
                                  AppIcons.copy,
                                  size: 14,
                                  color: AppColors.subtleMuted,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Assurance Guarantee ──────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    AppIcons.shield,
                    size: 15,
                    color: AppColors.mutedText,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    AppStrings.zeroDisputeGuarantee,
                    style: AppTextStyles.bodyXS.copyWith(
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Action Buttons ───────────────────────────────────────────
              AppPrimaryButton(
                label: AppStrings.newSale,
                leadingIcon: Icons.add_circle_outline,
                onPressed: () {
                  payment.reset();
                  context.go('/charging');
                },
              ),
              const SizedBox(height: AppSpacing.md),

              AppOutlinedButton(
                label: 'View in Transactions',
                leadingIcon: AppIcons.transactions,
                onPressed: () {
                  payment.reset();
                  context.go('/transactions');
                },
              ),
              const SizedBox(height: AppSpacing.md),

              AppOutlinedButton(
                label: AppStrings.sendReceipt,
                leadingIcon: AppIcons.sms,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Receipt sent to customer mobile!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.sm),

              AppTextLinkButton(
                text: 'Back to Terminal Overview',
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

  Widget _buildRailBadge(String rail) {
    final lower = rail.toLowerCase();
    Color bgColor = const Color(0xFF0072BC);
    String text = 'tb';

    if (lower.contains('cbe')) {
      bgColor = AppColors.cbeBadgeBg;
      text = 'CBE';
    } else if (lower.contains('awash')) {
      bgColor = AppColors.awashBadgeBg;
      text = 'AW';
    } else if (lower.contains('dashen') || lower.contains('amole')) {
      bgColor = AppColors.dashenBadgeBg;
      text = 'DA';
    }

    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required Widget valueWidget,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.mutedText,
          ),
        ),
        valueWidget,
      ],
    );
  }
}

