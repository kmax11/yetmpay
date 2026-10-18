import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/icons/app_icons.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_card.dart';
import 'transaction_notifier.dart';

/// Transactions Screen (Figma node 4-243).
///
/// Branch 1 of the StatefulShellRoute navigation shell.
/// Features real-time settled volume summary, transaction searching and filtering,
/// recent audit ledger records, and active receipt inspection with print action.
class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<TransactionNotifier>();
    final items = notifier.filteredTransactions;
    final selected = notifier.selectedTransaction;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadH,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Header Row ───────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'Y',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'YETMPAY MERCHANT',
                                style: AppTextStyles.capsLabelSemiBold.copyWith(
                                  color: AppColors.darkText,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
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
                                    const SizedBox(width: 3),
                                    Text(
                                      'Live',
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
                          const SizedBox(height: 2),
                          Text(
                            'Bole Fresh Mart',
                            style: AppTextStyles.semiBoldMedium.copyWith(
                              color: AppColors.darkText,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          AppIcons.notifications,
                          size: 20,
                          color: AppColors.subtleMuted,
                        ),
                        onPressed: () {},
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: const Icon(
                          AppIcons.person,
                          size: 16,
                          color: AppColors.subtleMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Title & Timezone Row (Responsive with Expanded) ──────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.transactionsTitle,
                          style: AppTextStyles.heading1.copyWith(
                            color: AppColors.darkText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppStrings.realtimeActivity,
                          style: AppTextStyles.bodyXS.copyWith(
                            color: AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: AppRadius.pillAll,
                      border: Border.all(color: AppColors.borderLight),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // const Icon(
                        //   AppIcons.clock,
                        //   size: 14,
                        //   color: AppColors.mutedText,
                        // ),
                        // const SizedBox(width: AppSpacing.xs),
                        // Text(
                        //   AppStrings.utcLabel,
                        //   style: AppTextStyles.bodyXXS.copyWith(
                        //     color: AppColors.subtleMuted,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Today's Settled Volume Card (Responsive Wrap) ─────────────
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.railSuccessBg,
                        borderRadius: AppRadius.badgeAll,
                      ),
                      child: const Icon(
                        AppIcons.transactions,
                        color: AppColors.primaryGreen,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notifier.selectedFilter == TransactionFilter.today
                                ? AppStrings.todaySettledVolume
                                : notifier.selectedFilter == TransactionFilter.thisWeek
                                    ? AppStrings.weekSettledVolume
                                    : AppStrings.monthSettledVolume,
                            style: AppTextStyles.capsLabel.copyWith(
                              color: AppColors.mutedText,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: AppSpacing.sm,
                            runSpacing: 4,
                            children: [
                              Text(
                                '${TransactionNotifier.formatAmount(notifier.settledVolumeForFilter)} ETB',
                                style: AppTextStyles.heading1.copyWith(
                                  color: AppColors.darkText,
                                  fontSize: 22,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.railSuccessBg,
                                  borderRadius: AppRadius.pillAll,
                                ),
                                child: Text(
                                  AppStrings.syncedLabel,
                                  style: AppTextStyles.semiBoldBadge.copyWith(
                                    color: AppColors.railSuccessText,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppStrings.autoClears,
                            style: AppTextStyles.bodyXXS.copyWith(
                              color: AppColors.slatePlaceholder,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Search Input ─────────────────────────────────────────────
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: AppRadius.inputBR,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => notifier.setSearchQuery(val),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.darkText,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      AppIcons.search,
                      size: 18,
                      color: AppColors.textPlaceholder,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              AppIcons.close,
                              size: 16,
                              color: AppColors.textPlaceholder,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              notifier.setSearchQuery('');
                            },
                          )
                        : null,
                    hintText: AppStrings.searchPlaceholder,
                    hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPlaceholder,
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Filter Pills Row (Horizontally Scrollable to Prevent Overflow) ─
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _buildFilterPill(
                            label: '${AppStrings.todayFilter} ${notifier.todayCount}',
                            isActive: notifier.selectedFilter == TransactionFilter.today,
                            onTap: () => notifier.setFilter(TransactionFilter.today),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _buildFilterPill(
                            label: '${AppStrings.thisWeekFilter} ${notifier.thisWeekCount}',
                            isActive: notifier.selectedFilter == TransactionFilter.thisWeek,
                            onTap: () => notifier.setFilter(TransactionFilter.thisWeek),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          _buildFilterPill(
                            label: '${AppStrings.thisMonthFilter} ${notifier.thisMonthCount}',
                            isActive: notifier.selectedFilter == TransactionFilter.thisMonth,
                            onTap: () => notifier.setFilter(TransactionFilter.thisMonth),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: AppRadius.buttonSmallAll,
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: const Icon(
                      AppIcons.filterList,
                      size: 18,
                      color: AppColors.subtleMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Recent Records Header ────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.recentRecords,
                    style: AppTextStyles.capsLabelSemiBold.copyWith(
                      color: AppColors.subtleMuted,
                      letterSpacing: 0.8,
                    ),
                  ),
                  Text(
                    'Showing ${items.length} transactions',
                    style: AppTextStyles.bodyXXS.copyWith(
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Transactions List (With overflow protection on text) ──────
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, index) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final tx = items[index];
                  final isSelected = selected?.id == tx.id;

                  return GestureDetector(
                    onTap: () => notifier.selectTransaction(tx),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: AppRadius.cardLargeAll,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryGreen
                              : AppColors.borderLight,
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: AppShadows.cardShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                tx.customerInitials,
                                style: AppTextStyles.semiBoldMedium.copyWith(
                                  color: AppColors.darkText,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.customerName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.semiBoldMedium.copyWith(
                                    color: AppColors.darkText,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${tx.rail} \u2022 ${tx.time}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodyXS.copyWith(
                                    color: AppColors.mutedText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                tx.formattedAmount,
                                style: AppTextStyles.semiBoldMedium.copyWith(
                                  color: tx.isPaid
                                      ? AppColors.railSuccessText
                                      : AppColors.darkText,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: tx.isPaid
                                      ? AppColors.railSuccessBg
                                      : AppColors.errorRedBg,
                                  borderRadius: AppRadius.pillAll,
                                ),
                                child: Text(
                                  tx.isPaid
                                      ? AppStrings.paidLabel
                                      : AppStrings.declinedLabel,
                                  style: AppTextStyles.semiBoldBadge.copyWith(
                                    color: tx.isPaid
                                        ? AppColors.railSuccessText
                                        : AppColors.errorRed,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Selected Transaction Receipt ─────────────────────────────
              if (selected != null) ...[
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      // Card Header: Icon + Title + ID Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: AppColors.railSuccessBg,
                                  borderRadius: AppRadius.badgeSmallAll,
                                ),
                                child: const Icon(
                                  AppIcons.receipt,
                                  color: AppColors.primaryGreen,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                AppStrings.selectedReceipt,
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
                              color: AppColors.surface,
                              borderRadius: AppRadius.badgeSmallAll,
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: Text(
                              selected.id,
                              style: AppTextStyles.monoSmall.copyWith(
                                fontSize: 10,
                                color: AppColors.darkText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Divider(color: AppColors.divider, height: 1),
                      const SizedBox(height: AppSpacing.md),

                      _buildReceiptRow('Customer', selected.customerName),
                      const SizedBox(height: AppSpacing.sm),
                      _buildReceiptRow('Account / Mobile', selected.maskedAccount),
                      const SizedBox(height: AppSpacing.sm),
                      _buildReceiptRow(
                        'Channel',
                        selected.channel,
                        customWidget: Row(
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
                            const SizedBox(width: 4),
                            Text(
                              selected.channel,
                              style: AppTextStyles.bodyXS.copyWith(
                                color: AppColors.darkText,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildReceiptRow('Timestamp', selected.timestamp),
                      const SizedBox(height: AppSpacing.md),
                      const Divider(color: AppColors.divider, height: 1),
                      const SizedBox(height: AppSpacing.md),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: AppTextStyles.semiBoldMedium.copyWith(
                              color: AppColors.darkText,
                            ),
                          ),
                          Text(
                            '${TransactionNotifier.formatAmount(selected.amount)} ETB',
                            style: AppTextStyles.heading1.copyWith(
                              color: AppColors.primaryGreen,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Printing receipt for ${selected.id}...'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              icon: const Icon(
                                AppIcons.print,
                                size: 16,
                                color: AppColors.white,
                              ),
                              label: Text(
                                AppStrings.printReceiptBtn,
                                style: AppTextStyles.semiBoldSmall.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                foregroundColor: AppColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.buttonSmallAll,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Report opened for ${selected.id}'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              icon: const Icon(
                                AppIcons.warning,
                                size: 16,
                                color: AppColors.darkText,
                              ),
                              label: Text(
                                AppStrings.reportIssue,
                                style: AppTextStyles.semiBoldSmall.copyWith(
                                  color: AppColors.darkText,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.darkText,
                                backgroundColor: AppColors.white,
                                side: const BorderSide(color: AppColors.borderDefault),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.buttonSmallAll,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // ── Footer Links (Wrapped to Prevent Pixel Overflow on Small Screens) ─
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.xs,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        AppIcons.shieldCheck,
                        size: 14,
                        color: AppColors.mutedText,
                      ),
                      label: Text(
                        AppStrings.directBoleHub,
                        style: AppTextStyles.bodyXXS.copyWith(
                          color: AppColors.mutedText,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(
                        AppIcons.download,
                        size: 14,
                        color: AppColors.mutedText,
                      ),
                      label: Text(
                        AppStrings.dailyStatement,
                        style: AppTextStyles.bodyXXS.copyWith(
                          color: AppColors.mutedText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterPill({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryGreen : AppColors.white,
          borderRadius: AppRadius.pillAll,
          border: Border.all(
            color: isActive ? AppColors.primaryGreen : AppColors.borderLight,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.semiBoldSmall.copyWith(
            color: isActive ? AppColors.white : AppColors.darkText,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value,
      {bool isMono = false, bool isBold = false, Widget? customWidget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyXS.copyWith(
            color: AppColors.mutedText,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: customWidget ??
              Text(
                value,
                textAlign: TextAlign.end,
                style: isMono
                    ? AppTextStyles.monoSmall.copyWith(
                        color: AppColors.darkText,
                        fontWeight: FontWeight.w600,
                      )
                    : (isBold
                        ? AppTextStyles.semiBoldMedium.copyWith(
                            color: AppColors.darkText,
                          )
                        : AppTextStyles.bodyXS.copyWith(
                            color: AppColors.darkText,
                          )),
              ),
        ),
      ],
    );
  }
}
