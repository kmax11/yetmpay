import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/icons/app_icons.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/app_rail_badge.dart';
import '../../core/widgets/app_text_link_button.dart';

/// Get Started / Onboarding screen (Figma node 1-484).
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
              // ── Top Language Toggle ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: AppRadius.pillAll,
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLangOption('EN'),
                        const SizedBox(width: AppSpacing.xs),
                        _buildLangOption('አማርኛ'),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // ── Center Branding & Content ────────────────────────────────
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand Logo Icon Container
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen10,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryGreen.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          AppIcons.faceId,
                          size: 48,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),

                    // App Name (Sora Bold 32, "pay" in primary green)
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: AppTextStyles.headingXL.copyWith(
                          color: AppColors.darkText,
                        ),
                        children: const [
                          TextSpan(text: 'YETM'),
                          TextSpan(
                            text: 'pay',
                            style: TextStyle(color: AppColors.primaryGreen),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Tagline
                    Text(
                      AppStrings.tagline,
                      style: AppTextStyles.tagline.copyWith(
                        color: AppColors.subtleMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),

                    // Supported Settlement Rails Badges
                    Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.md,
                      alignment: WrapAlignment.center,
                      children: const [
                        AppRailBadge(
                          label: AppStrings.railTelebirr,
                          dotColor: AppColors.primaryGreen,
                        ),
                        AppRailBadge(
                          label: AppStrings.railCBE,
                          dotColor: AppColors.cbePill,
                        ),
                        AppRailBadge(
                          label: AppStrings.railAwash,
                          dotColor: AppColors.awashPill,
                        ),
                        AppRailBadge(
                          label: AppStrings.railDashen,
                          dotColor: AppColors.dashenPill,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // ── CTA & Actions ─────────────────────────────────────────────
              AppPrimaryButton(
                label: AppStrings.getStarted,
                trailingIcon: AppIcons.arrowRight,
                onPressed: () => context.push('/register'),
              ),
              const SizedBox(height: AppSpacing.lg),

              AppTextLinkButton(
                text: AppStrings.alreadyHaveAccount,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.mutedText,
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
                    size: 14,
                    color: AppColors.mutedText,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      AppStrings.nbeFooter,
                      style: AppTextStyles.bodyXS.copyWith(
                        color: AppColors.mutedText,
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
          ),
        ),
      ),
    );
  }
}
