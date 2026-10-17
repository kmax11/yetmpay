import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Frosted glass header with backdrop blur, used on Terminal + Charging screens.
///
/// White 95% opacity, blur σ6, 1px bottom border.
class AppFrostedHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppFrostedHeader({super.key, required this.child});

  final Widget child;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.95),
            border: const Border(
              bottom: BorderSide(color: Color(0xCCE2E8F0)),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

