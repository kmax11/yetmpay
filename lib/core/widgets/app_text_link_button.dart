import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Minimal text-link button.
class AppTextLinkButton extends StatelessWidget {
  const AppTextLinkButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.style,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? AppColors.mutedText,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: style ??
            AppTextStyles.labelMedium
                .copyWith(color: color ?? AppColors.mutedText),
        textAlign: TextAlign.center,
      ),
    );
  }
}

