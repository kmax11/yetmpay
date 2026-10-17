import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../core/icons/app_icons.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/app_text_link_button.dart';

/// Get Started / Onboarding screen (Figma node 1-484).
///
/// Features official YETMpay logo mark SVG asset, localized language toggle,
/// tagline, and primary onboarding actions matching the Figma design.
class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  String _selectedLanguage = 'EN';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadH3,
          ),
          child: Column(
            children: [
              // ── Top Header Bar (Live Pill + Language Selector) ───────────
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: AppRadius.pillAll,
                        border: Border.all(
                          color: AppColors.borderLight.withValues(alpha: 0.8),
                        ),
                        boxShadow: AppShadows.cardShadow,
                      ),
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Language Toggle Pill: [አማርኛ] [EN]
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: AppRadius.pillAll,
                        border: Border.all(
                          color: AppColors.borderLight.withValues(alpha: 0.8),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildLangOption('አማርኛ'),
                          const SizedBox(width: 2),
                          _buildLangOption('EN'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // ── Center Branding & Content ────────────────────────────────
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Official YETMpay Logo Mark from assets/svg/yetmpay_logo_mark.svg
                    SvgPicture.asset(
                      'assets/svg/yetmpay_logo_mark.svg',
                      width: 78,
                      height: 78,
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // Brand Wordmark: YETM (Dark) + pay (Primary Green)
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTextStyles.headingXL.copyWith(
                          color: AppColors.darkText,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                        children: const [
                          TextSpan(text: 'YETM'),
                          TextSpan(
                            text: 'pay',
                            style: TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Tagline
                    Text(
                      AppStrings.tagline,
                      style: AppTextStyles.tagline.copyWith(
                        color: AppColors.darkText,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 4),

              // ── Primary Actions ──────────────────────────────────────────
              AppPrimaryButton(
                label: AppStrings.getStarted,
                trailingIcon: AppIcons.arrowRight,
                onPressed: () => context.push('/register'),
              ),
              const SizedBox(height: AppSpacing.lg),

              AppTextLinkButton(
                text: AppStrings.alreadyHaveAccount,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.subtleMuted,
                  fontSize: 14,
                ),
                onPressed: () => context.push('/login'),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── NBE Compliance & Fayda ID Footer ──────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    AppIcons.lock,
                    size: 13,
                    color: AppColors.mutedText,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      AppStrings.nbeFooter,
                      style: AppTextStyles.bodyXS.copyWith(
                        color: AppColors.mutedText,
                        fontSize: 11,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLangOption(String lang) {
    final isSelected = _selectedLanguage == lang;
    return GestureDetector(
      onTap: () => setState(() => _selectedLanguage = lang),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          borderRadius: AppRadius.pillAll,
          boxShadow: isSelected ? AppShadows.cardShadow : null,
        ),
        child: Text(
          lang,
          style: AppTextStyles.labelXS.copyWith(
            color: isSelected ? AppColors.darkText : AppColors.mutedText,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
