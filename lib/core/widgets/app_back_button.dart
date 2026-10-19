import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/theme.dart';
import '../icons/app_icons.dart';

/// Circular white back button with border.
///
/// Safely pops the current route if possible via [GoRouterExtension.canPop],
/// or navigates to [fallbackLocation] if this was the last page on the stack,
/// preventing "You have popped the last page off of the stack" assertions.
class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
    this.onPressed,
    this.size = 40,
    this.fallbackLocation = '/',
  });

  final VoidCallback? onPressed;
  final double size;
  final String fallbackLocation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed!();
        } else if (context.canPop()) {
          context.pop();
        } else {
          context.go(fallbackLocation);
        }
      },
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
