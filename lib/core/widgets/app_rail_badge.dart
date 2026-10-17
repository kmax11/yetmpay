import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Payment-rail badge pill with colored dot — matches Get Started badges.
class AppRailBadge extends StatelessWidget {
  const AppRailBadge({
    super.key,
    required this.label,
    required this.dotColor,
  });

  final String label;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.pillAll,
        border: Border.all(
          color: AppColors.borderLight.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: AppTextStyles.labelSmall
                .copyWith(color: AppColors.subtleMuted),
          ),
        ],
      ),
    );
  }
}

