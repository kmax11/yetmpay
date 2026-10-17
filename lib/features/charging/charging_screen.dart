import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/icons/app_icons.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_frosted_header.dart';
import '../../core/widgets/app_keypad.dart';
import '../../core/widgets/app_primary_button.dart';
import '../terminal/terminal_notifier.dart';
import 'payment_notifier.dart';

/// Charging Screen (Figma node 1-335).
///
/// Merchant keypad for entering charge amount, choosing payment rail,
/// and launching face-scanning biometric payment verification.
class ChargingScreen extends StatefulWidget {
  const ChargingScreen({super.key});

  @override
  State<ChargingScreen> createState() => _ChargingScreenState();
}

class _ChargingScreenState extends State<ChargingScreen> {
  static const _rails = ['Telebirr', 'CBE Birr', 'Awash', 'Amole'];

  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final payment = context.read<PaymentNotifier>();
    _phoneController = TextEditingController(text: payment.recipientPhone);
    _phoneController.addListener(() {
      context.read<PaymentNotifier>().updateRecipientPhone(_phoneController.text);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final terminal = context.watch<TerminalNotifier>();
    final payment = context.watch<PaymentNotifier>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppFrostedHeader(
        child: Row(
          children: [
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
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          terminal.merchantName,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.headingSmall.copyWith(
                            color: AppColors.darkText,
                          ),
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
            IconButton(
              icon: const Icon(
                AppIcons.notifications,
                size: 20,
                color: AppColors.subtleMuted,
              ),
              onPressed: () {},
            ),
            const SizedBox(width: AppSpacing.xs),
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
          children: [
            // ── Amount Entry Card ──────────────────────────────────────────
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  Text(
                    AppStrings.enterAmount,
                    style: AppTextStyles.capsLabel.copyWith(
                      color: AppColors.mutedText,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Amount Display
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            payment.displayAmount,
                            style: AppTextStyles.displayLarge.copyWith(
                              color: AppColors.darkText,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'ETB',
                        style: AppTextStyles.tagline.copyWith(
                          color: AppColors.slatePlaceholder,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppSpacing.md),

                  // Payment Rail Section header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.paymentRail,
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
                        child: Text(
                          AppStrings.directPush,
                          style: AppTextStyles.semiBoldBadge.copyWith(
                            color: AppColors.railSuccessText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // 4 Rail Buttons — use LayoutBuilder so they never overflow
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Row(
                        children: List.generate(_rails.length, (i) {
                          final isSelected = payment.selectedRailIndex == i;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: i < _rails.length - 1
                                    ? AppSpacing.xs
                                    : 0,
                              ),
                              child: GestureDetector(
                                onTap: () => payment.selectRail(i),
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.sm,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryGreen
                                        : AppColors.surface,
                                    borderRadius: AppRadius.badgeSmallAll,
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primaryGreen
                                          : AppColors.borderLight,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _rails[i],
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.semiBoldXS
                                          .copyWith(
                                        fontSize: constraints.maxWidth < 300
                                            ? 9
                                            : 11,
                                        color: isSelected
                                            ? AppColors.white
                                            : AppColors.darkText,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Recipient Phone — editable, responsive ───────────────
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: AppRadius.inputAll,
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      children: [
                        // Country code prefix
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                AppIcons.phone,
                                size: 16,
                                color: AppColors.mutedText,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                '+251',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.darkText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Editable phone number
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: AppTextStyles.monoMedium.copyWith(
                              color: AppColors.darkText,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[\d\s]'),
                              ),
                              LengthLimitingTextInputFormatter(12),
                            ],
                            decoration: InputDecoration(
                              hintText: '91 123 4567',
                              hintStyle: AppTextStyles.monoMedium.copyWith(
                                color: AppColors.slatePlaceholder,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: AppSpacing.md,
                              ),
                              isDense: true,
                            ),
                          ),
                        ),
                        // QR scan icon
                        IconButton(
                          icon: const Icon(
                            AppIcons.qrScan,
                            size: 18,
                            color: AppColors.primaryGreen,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('QR phone scan coming soon'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Quick Chips Row ────────────────────────────────────────────
            Row(
              children: [
                _buildQuickChip(payment, 50, '+50 ETB'),
                const SizedBox(width: AppSpacing.sm),
                _buildQuickChip(payment, 100, '+100 ETB'),
                const SizedBox(width: AppSpacing.sm),
                _buildQuickChip(payment, 500, '+500 ETB'),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Keypad ────────────────────────────────────────────────────
            AppKeypad(
              onKey: payment.onKey,
              onDelete: payment.onDelete,
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Charge CTA ────────────────────────────────────────────────
            AppPrimaryButton(
              label: 'Charge ${payment.displayAmount} ETB',
              leadingIcon: AppIcons.faceId,
              onPressed: payment.hasAmount
                  ? () => context.push('/face-scan')
                  : null,
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Today's Settled Summary Card ──────────────────────────────
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.badgeAll,
                    ),
                    child: const Icon(
                      AppIcons.transactions,
                      size: 20,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: AppSpacing.xs,
                          children: [
                            Text(
                              '14,820.00 ETB',
                              style: AppTextStyles.headingSmall.copyWith(
                                color: AppColors.darkText,
                              ),
                            ),
                            Text(
                              '• 38 settled sales',
                              style: AppTextStyles.bodyXS.copyWith(
                                color: AppColors.mutedText,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          AppStrings.autoPayoutNote,
                          style: AppTextStyles.bodyXXS.copyWith(
                            color: AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    AppIcons.chevronRight,
                    size: 18,
                    color: AppColors.slatePlaceholder,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickChip(PaymentNotifier payment, double amount, String label) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          final current = double.tryParse(payment.amount) ?? 0;
          final total = current + amount;
          payment.clearAmount();
          for (final char in total.toStringAsFixed(0).split('')) {
            payment.onKey(char);
          }
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.buttonSmallAll,
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.semiBoldSmall.copyWith(
                color: AppColors.darkText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
