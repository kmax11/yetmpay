import 'package:flutter/material.dart';
import '../theme/theme.dart';
import '../icons/app_icons.dart';

/// Circular white back button with border.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed, this.size = 40});

  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.borderDefault),
          shape: BoxShape.circle,
          boxShadow: AppShadows.cardShadow,
        ),
        child: Icon(
          AppIcons.arrowLeft,
          size: size * 0.35,
          color: AppColors.slate300,
        ),
      ),
    );
  }
}

