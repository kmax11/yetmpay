import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/icons/app_icons.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_back_button.dart';
import '../../core/widgets/app_bank_chip.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_input_field.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/app_text_link_button.dart';
import 'registration_notifier.dart';

/// Step 2: Link Bank / Settlement Account Screen (Figma node 1-84).
class LinkBankScreen extends StatefulWidget {
  const LinkBankScreen({super.key});

  @override
  State<LinkBankScreen> createState() => _LinkBankScreenState();
}

class _LinkBankScreenState extends State<LinkBankScreen> {
  late final TextEditingController _accountController;
  late final TextEditingController _phoneController;

  static const _banks = [
    (
      label: 'CBE',
      abbr: 'CBE',
      bg: AppColors.cbeBadgeBg,
      text: AppColors.cbeBadgeText,
    ),
    (
      label: 'Awash Bank',
      abbr: 'AW',
      bg: AppColors.awashBadgeBg,
      text: AppColors.awashBadgeText,
    ),
    (
      label: 'Dashen Bank',
      abbr: 'DB',
      bg: AppColors.dashenBadgeBg,
      text: AppColors.dashenBadgeText,
    ),
    (
      label: 'Abyssinia',
      abbr: 'BoA',
      bg: AppColors.boaBadgeBg,
      text: AppColors.boaBadgeText,
    ),
  ];

  @override
  void initState() {
    super.initState();
    final reg = context.read<RegistrationNotifier>();
    _accountController = TextEditingController(
      text: reg.accountNumber.isEmpty ? '1000284918231' : reg.accountNumber,
    );
    _phoneController = TextEditingController(
      text: reg.linkedMobile.isEmpty ? '91 450 8821' : reg.linkedMobile,
    );
  }

  @override
  void dispose() {
    _accountController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleComplete() async {
    final reg = context.read<RegistrationNotifier>();
    reg.updateAccountNumber(_accountController.text.trim());
    reg.updateLinkedMobile(_phoneController.text.trim());

    final success = await reg.submitStep2();
    if (success && mounted) {
      // Registration complete — go to login so the merchant signs in
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final reg = context.watch<RegistrationNotifier>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadH2,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Navigation & Step Indicator ───────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppBackButton(fallbackLocation: '/register'),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.pillAll,
                    ),
                    child: Text(
                      AppStrings.stepIndicator,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.mutedText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Heading & Subtitle ────────────────────────────────────────
              Text(
                AppStrings.linkSettlementAccount,
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.linkSettlementSub,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mutedText,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Segmented Tab Pill ────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: AppRadius.pillAll,
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabOption(
                        label: AppStrings.tabBankAccount,
                        isSelected: reg.selectedTabIndex == 0,
                        onTap: () => reg.updateTabIndex(0),
                      ),
                    ),
                    Expanded(
                      child: _buildTabOption(
                        label: AppStrings.tabTelebirrSuperApp,
                        isSelected: reg.selectedTabIndex == 1,
                        onTap: () => reg.updateTabIndex(1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Bank Selection Section ────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.selectRailBank,
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
                      borderRadius: AppRadius.badgeSmallAll,
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
                          AppStrings.instantSettled,
                          style: AppTextStyles.semiBoldBadge.copyWith(
                            color: AppColors.railSuccessText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Horizontal Bank Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_banks.length, (i) {
                    final bank = _banks[i];
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.md),
                      child: AppBankChip(
                        label: bank.label,
                        abbreviation: bank.abbr,
                        avatarBg: bank.bg,
                        avatarText: bank.text,
                        isSelected: reg.selectedBankIndex == i,
                        onTap: () => reg.updateBankIndex(i),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Form Card ─────────────────────────────────────────────────
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppInputField(
                      controller: _accountController,
                      label: AppStrings.fieldAccountNumber,
                      hint: AppStrings.fieldAccountNumberHint,
                      keyboardType: TextInputType.number,
                      trailingWidget: IconButton(
                        icon: const Icon(
                          AppIcons.copy,
                          size: 18,
                          color: AppColors.primaryGreen,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account number copied'),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      onChanged: reg.updateAccountNumber,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    AppInputField(
                      controller: _phoneController,
                      label: AppStrings.fieldLinkedMobile,
                      keyboardType: TextInputType.phone,
                      onChanged: reg.updateLinkedMobile,
                      prefixWidget: Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.xs),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('🇪🇹', style: TextStyle(fontSize: 14)),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              '+251',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.darkText,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    Row(
                      children: [
                        const Icon(
                          AppIcons.info,
                          size: 14,
                          color: AppColors.mutedText,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            AppStrings.faydaMatch,
                            style: AppTextStyles.bodyXXS.copyWith(
                              color: AppColors.mutedText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Account Holder Verification Card ──────────────────────────
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                          AppStrings.accountHolderVerified,
                          style: AppTextStyles.capsLabelSemiBold.copyWith(
                            color: AppColors.railSuccessText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ABEBE BIKILA DESTA',
                          style: AppTextStyles.heading3.copyWith(
                            color: AppColors.darkText,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.railSuccessBg,
                            borderRadius: AppRadius.pillAll,
                            border: Border.all(
                              color: AppColors.railGreen.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            AppStrings.matchLabel,
                            style: AppTextStyles.semiBoldBadge.copyWith(
                              color: AppColors.railSuccessText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: AppSpacing.sm),

                    Row(
                      children: [
                        const Icon(
                          AppIcons.checkCircle,
                          size: 16,
                          color: AppColors.railGreen,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            AppStrings.verifiedWithCBE,
                            style: AppTextStyles.bodyXS.copyWith(
                              color: AppColors.subtleMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── NBE Compliance Note ───────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: AppRadius.buttonSmallAll,
                  border: Border.all(color: AppColors.borderDefault),
                ),
                child: Row(
                  children: [
                    const Icon(
                      AppIcons.lock,
                      size: 16,
                      color: AppColors.mutedText,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        AppStrings.nbeCompliance,
                        style: AppTextStyles.bodyXS.copyWith(
                          color: AppColors.mutedText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── CTA & Actions ─────────────────────────────────────────────
              AppPrimaryButton(
                label: AppStrings.completeActivateTerminal,
                trailingIcon: AppIcons.arrowRight,
                isLoading: reg.status == RegistrationStatus.loading,
                onPressed: _handleComplete,
              ),
              const SizedBox(height: AppSpacing.sm),

              Center(
                child: AppTextLinkButton(
                  text: AppStrings.changeSettlementRail,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.mutedText,
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: AppRadius.pillAll,
          boxShadow: isSelected ? AppShadows.cardShadow : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.semiBoldSmall.copyWith(
              color: isSelected ? AppColors.darkText : AppColors.mutedText,
            ),
          ),
        ),
      ),
    );
  }
}

