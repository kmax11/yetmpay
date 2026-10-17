import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// White container with border and shadow — matches Figma card style.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.xl),
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppRadius.cardLargeAll,
        border:
            Border.all(color: borderColor ?? AppColors.borderDefault),
        boxShadow: AppShadows.cardShadow,
      ),
      child: child,
    );
  }
}

