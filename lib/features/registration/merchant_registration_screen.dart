import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/icons/app_icons.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_back_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_input_field.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/app_text_link_button.dart';
import 'registration_notifier.dart';

/// Step 1: Merchant Registration Screen — MVP form.
class MerchantRegistrationScreen extends StatefulWidget {
  const MerchantRegistrationScreen({super.key});

  @override
  State<MerchantRegistrationScreen> createState() =>
      _MerchantRegistrationScreenState();
}

class _MerchantRegistrationScreenState
    extends State<MerchantRegistrationScreen> {
  late final TextEditingController _shopController;
  late final TextEditingController _ownerController;
  late final TextEditingController _phoneController;
  late final TextEditingController _tinController;
  late final TextEditingController _licenseController;
  // Settlement
  late final TextEditingController _mobileController;
  late final TextEditingController _accountController;

  @override
  void initState() {
    super.initState();
    final reg = context.read<RegistrationNotifier>();
    _shopController    = TextEditingController(text: reg.businessName);
    _ownerController   = TextEditingController(text: reg.ownerName);
    _phoneController   = TextEditingController(text: reg.phone);
    _tinController     = TextEditingController(text: reg.tin);
    _licenseController = TextEditingController(text: reg.businessLicense);
    _mobileController  = TextEditingController(text: reg.linkedMobile);
    _accountController = TextEditingController(text: reg.accountNumber);
  }

  @override
  void dispose() {
    _shopController.dispose();
    _ownerController.dispose();
    _phoneController.dispose();
    _tinController.dispose();
    _licenseController.dispose();
    _mobileController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final reg = context.read<RegistrationNotifier>();
    reg.updateBusinessName(_shopController.text.trim());
    reg.updateOwnerName(_ownerController.text.trim());
    reg.updatePhone(_phoneController.text.trim());
    reg.updateTin(_tinController.text.trim());
    reg.updateBusinessLicense(_licenseController.text.trim());
    reg.updateLinkedMobile(_mobileController.text.trim());
    reg.updateAccountNumber(_accountController.text.trim());

    final success = await reg.submitStep1();
    if (success && mounted) {
      context.push('/register/link-bank');
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
            horizontal: AppSpacing.screenPadH,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBackButton(),
              const SizedBox(height: AppSpacing.xl),

              // ── Header ────────────────────────────────────────────────────
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen10,
                  borderRadius: AppRadius.badgeAll,
                ),
                child: const Center(
                  child: Icon(AppIcons.store, color: AppColors.primaryGreen, size: 24),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                AppStrings.merchantRegistration,
                style: AppTextStyles.heading1.copyWith(color: AppColors.darkText),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.merchantRegistrationSub,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mutedText),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Section 1: Business Info ───────────────────────────────────
              _sectionLabel('BUSINESS INFORMATION'),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Shop Name
                    AppInputField(
                      controller: _shopController,
                      label: AppStrings.fieldBusinessName,
                      hint: AppStrings.fieldBusinessNameHint,
                      leadingIcon: AppIcons.store,
                      onChanged: reg.updateBusinessName,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Owner Name
                    AppInputField(
                      controller: _ownerController,
                      label: AppStrings.fieldOwnerName,
                      hint: AppStrings.fieldOwnerNameHint,
                      leadingIcon: AppIcons.person,
                      onChanged: reg.updateOwnerName,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Phone
                    AppInputField(
                      controller: _phoneController,
                      label: AppStrings.fieldPhone,
                      hint: AppStrings.fieldPhoneHint,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: reg.updatePhone,
                      prefixWidget: Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.xs),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('🇪🇹', style: TextStyle(fontSize: 14)),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text('+251', style: AppTextStyles.labelMedium.copyWith(color: AppColors.darkText)),
                            const SizedBox(width: AppSpacing.xs),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Section 2: Tax & Legal ─────────────────────────────────────
              _sectionLabel('TAX & LEGAL IDENTITY'),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TIN
                    AppInputField(
                      controller: _tinController,
                      label: 'TIN (Tax Identification Number)',
                      hint: 'e.g. 0012345678',
                      leadingIcon: AppIcons.shieldCheck,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: reg.updateTin,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Business License
                    AppInputField(
                      controller: _licenseController,
                      label: 'Business License / Commercial Reg. No.',
                      hint: 'e.g. BL-2023-04821',
                      leadingIcon: AppIcons.info,
                      onChanged: reg.updateBusinessLicense,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Section 3: Settlement Account ──────────────────────────────
              _sectionLabel('SETTLEMENT ACCOUNT'),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Toggle: Telebirr / Bank
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.buttonSmallAll,
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          _settlementTab(
                            label: 'Telebirr',
                            icon: AppIcons.mobile,
                            selected: reg.settlementType == SettlementType.telebirr,
                            onTap: () => reg.updateSettlementType(SettlementType.telebirr),
                          ),
                          _settlementTab(
                            label: 'Bank Account',
                            icon: AppIcons.bank,
                            selected: reg.settlementType == SettlementType.bank,
                            onTap: () => reg.updateSettlementType(SettlementType.bank),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Telebirr mobile number (always shown)
                    AppInputField(
                      controller: _mobileController,
                      label: reg.settlementType == SettlementType.telebirr
                          ? 'Telebirr Mobile Number'
                          : 'Linked Mobile Number',
                      hint: '9X XXX XXXX',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      leadingIcon: AppIcons.mobile,
                      onChanged: reg.updateLinkedMobile,
                      prefixWidget: Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.xs),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('🇪🇹', style: TextStyle(fontSize: 14)),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Text('+251', style: AppTextStyles.labelMedium.copyWith(color: AppColors.darkText)),
                            const SizedBox(width: AppSpacing.xs),
                          ],
                        ),
                      ),
                    ),

                    // Bank account number (only when bank selected)
                    if (reg.settlementType == SettlementType.bank) ...[
                      const SizedBox(height: AppSpacing.lg),
                      AppInputField(
                        controller: _accountController,
                        label: 'Bank Account Number',
                        hint: '13 digits',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        leadingIcon: AppIcons.bank,
                        onChanged: reg.updateAccountNumber,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Bank selector chips
                      _sectionLabel('SELECT BANK'),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.md,
                        runSpacing: AppSpacing.md,
                        children: [
                          _bankChip(0, 'CBE', AppColors.cbeBadgeBg, reg),
                          _bankChip(1, 'Awash', AppColors.awashBadgeBg, reg),
                          _bankChip(2, 'Dashen', AppColors.dashenBadgeBg, reg),
                          _bankChip(3, 'BoA', AppColors.boaBadgeBg, reg),
                        ],
                      ),
                    ],

                    const SizedBox(height: AppSpacing.md),
                    // Compliance note
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(AppIcons.shieldCheck, size: 14, color: AppColors.railSuccessText),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            'Must match your national Fayda ID registration. Protected under NBE clearing standards.',
                            style: AppTextStyles.bodyXS.copyWith(color: AppColors.mutedText),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Submit ────────────────────────────────────────────────────
              AppPrimaryButton(
                label: AppStrings.continueToPayoutAccount,
                trailingIcon: AppIcons.arrowRight,
                isLoading: reg.status == RegistrationStatus.loading,
                onPressed: reg.step1Valid ? _handleSubmit : null,
              ),
              const SizedBox(height: AppSpacing.lg),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.alreadyRegistered,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.mutedText),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  AppTextLinkButton(
                    text: AppStrings.signIn,
                    style: AppTextStyles.semiBoldSmall.copyWith(color: AppColors.primaryGreen),
                    onPressed: () => context.push('/login'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(
      label,
      style: AppTextStyles.capsLabel.copyWith(color: AppColors.mutedText, letterSpacing: 0.8),
    );
  }

  Widget _settlementTab({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: selected ? AppColors.white : Colors.transparent,
            borderRadius: AppRadius.buttonSmallAll,
            boxShadow: selected ? AppShadows.cardShadow : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: selected ? AppColors.primaryGreen : AppColors.mutedText),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: selected ? AppColors.primaryGreen : AppColors.mutedText,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bankChip(int index, String label, Color color, RegistrationNotifier reg) {
    final selected = reg.selectedBankIndex == index;
    return GestureDetector(
      onTap: () => reg.updateBankIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(
            color: selected ? color : AppColors.borderDefault,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: selected ? color : AppColors.textSubtle,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
