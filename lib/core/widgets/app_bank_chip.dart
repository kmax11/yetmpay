import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Selectable bank chip for the Link Bank carousel.
class AppBankChip extends StatelessWidget {
  const AppBankChip({
    super.key,
    required this.label,
    required this.abbreviation,
    required this.avatarBg,
    required this.avatarText,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final String abbreviation;
  final Color avatarBg;
  final Color avatarText;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.sm + 1,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : AppColors.surface,
          borderRadius: AppRadius.pillAll,
          border: Border.all(
            color: isSelected
                ? AppColors.primaryGreen
                : AppColors.borderDefault,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppShadows.cardShadow : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: avatarBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  abbreviation,
                  style: AppTextStyles.semiBoldBadge
                      .copyWith(color: avatarText),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: isSelected
                  ? AppTextStyles.semiBoldMedium
                      .copyWith(color: AppColors.primaryGreen)
                  : AppTextStyles.labelMedium
                      .copyWith(color: AppColors.darkText),
            ),
            if (isSelected) ...[
              const SizedBox(width: AppSpacing.md),
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

