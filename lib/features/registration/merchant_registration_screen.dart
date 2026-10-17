import 'package:flutter/material.dart';
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

/// Step 1: Merchant Registration Screen (Figma node 1-2).
class MerchantRegistrationScreen extends StatefulWidget {
  const MerchantRegistrationScreen({super.key});

  @override
  State<MerchantRegistrationScreen> createState() =>
      _MerchantRegistrationScreenState();
}

class _MerchantRegistrationScreenState
    extends State<MerchantRegistrationScreen> {
  late final TextEditingController _businessController;
  late final TextEditingController _ownerController;
  late final TextEditingController _phoneController;
  late final TextEditingController _pinController;

  @override
  void initState() {
    super.initState();
    final reg = context.read<RegistrationNotifier>();
    _businessController = TextEditingController(text: reg.businessName);
    _ownerController = TextEditingController(text: reg.ownerName);
    _phoneController = TextEditingController(text: reg.phone);
    _pinController = TextEditingController(text: reg.pin);
  }

  @override
  void dispose() {
    _businessController.dispose();
    _ownerController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    final reg = context.read<RegistrationNotifier>();
    reg.updateBusinessName(_businessController.text.trim());
    reg.updateOwnerName(_ownerController.text.trim());
    reg.updatePhone(_phoneController.text.trim());
    reg.updatePin(_pinController.text.trim());

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
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Navigation Bar ────────────────────────────────────────
              const AppBackButton(),
              const SizedBox(height: AppSpacing.xl),

              // ── Header Icon & Title ───────────────────────────────────────
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen10,
                  borderRadius: AppRadius.badgeAll,
                ),
                child: const Center(
                  child: Icon(
                    AppIcons.store,
                    color: AppColors.primaryGreen,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                AppStrings.merchantRegistration,
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.merchantRegistrationSub,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mutedText,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Form Card ─────────────────────────────────────────────────
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppInputField(
                      controller: _businessController,
                      label: AppStrings.fieldBusinessName,
                      hint: AppStrings.fieldBusinessNameHint,
                      leadingIcon: AppIcons.store,
                      onChanged: reg.updateBusinessName,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    AppInputField(
                      controller: _ownerController,
                      label: AppStrings.fieldOwnerName,
                      hint: AppStrings.fieldOwnerNameHint,
                      leadingIcon: AppIcons.person,
                      onChanged: reg.updateOwnerName,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    AppInputField(
                      controller: _phoneController,
                      label: AppStrings.fieldPhone,
                      hint: AppStrings.fieldPhoneHint,
                      keyboardType: TextInputType.phone,
                      onChanged: reg.updatePhone,
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
                    const SizedBox(height: AppSpacing.lg),

                    AppInputField(
                      controller: _pinController,
                      label: AppStrings.fieldPIN,
                      hint: AppStrings.fieldPINHint,
                      obscureText: true,
                      leadingIcon: AppIcons.lock,
                      keyboardType: TextInputType.number,
                      onChanged: reg.updatePin,
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Settlement Rails Row
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface2,
                        borderRadius: AppRadius.buttonSmallAll,
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          Text(
                            AppStrings.settlementRails,
                            style: AppTextStyles.capsLabel.copyWith(
                              color: AppColors.mutedText,
                              fontSize: 11,
                            ),
                          ),
                          const Spacer(),
                          Wrap(
                            spacing: AppSpacing.xs,
                            children: [
                              _buildMiniChip('CBE Birr'),
                              _buildMiniChip('Telebirr'),
                              _buildMiniChip('Awash'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Action Buttons ────────────────────────────────────────────
              AppPrimaryButton(
                label: AppStrings.continueToPayoutAccount,
                trailingIcon: AppIcons.arrowRight,
                isLoading: reg.status == RegistrationStatus.loading,
                onPressed: _handleContinue,
              ),
              const SizedBox(height: AppSpacing.lg),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.alreadyRegistered,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.mutedText,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  AppTextLinkButton(
                    text: AppStrings.signIn,
                    style: AppTextStyles.semiBoldSmall.copyWith(
                      color: AppColors.primaryGreen,
                    ),
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

  Widget _buildMiniChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.badgeSmall),
      ),
      child: Text(
        label,
        style: AppTextStyles.semiBoldXS.copyWith(
          color: AppColors.slate300,
          fontSize: 10,
        ),
      ),
    );
  }
}

