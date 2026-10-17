import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Thin progress bar (h=6) with rounded ends.
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({super.key, required this.value});

  /// 0.0 to 1.0.
  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.pillAll,
      child: LinearProgressIndicator(
        value: value,
        minHeight: 6,
        backgroundColor: AppColors.progressBarBg,
        valueColor:
            const AlwaysStoppedAnimation(AppColors.primaryGreen),
      ),
    );
  }
}

