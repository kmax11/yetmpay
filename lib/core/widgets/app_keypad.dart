import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// Numeric keypad: 4×3 grid matching the Charging screen design.
class AppKeypad extends StatelessWidget {
  const AppKeypad({
    super.key,
    required this.onKey,
    required this.onDelete,
  });

  final ValueChanged<String> onKey;
  final VoidCallback onDelete;

  static const _keys = [
    '1', '2', '3',
    '4', '5', '6',
    '7', '8', '9',
    '.', '0', '',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        mainAxisExtent: 56,
      ),
      itemCount: 12,
      itemBuilder: (_, i) {
        if (i == 11) return _deleteKey();
        return _numKey(_keys[i]);
      },
    );
  }

  Widget _numKey(String label) {
    return _KeyButton(
      onTap: () => onKey(label),
      child: Text(
        label,
        style: AppTextStyles.heading3.copyWith(
          fontFamily: 'Sora',
          fontSize: 22,
          height: 1,
          color: AppColors.darkText,
        ),
      ),
    );
  }

  Widget _deleteKey() {
    return _KeyButton(
      onTap: onDelete,
      child: Icon(
        Icons.backspace_outlined,
        size: 22,
        color: AppColors.subtleMuted,
      ),
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: AppRadius.inputAll,
      child: InkWell(
        borderRadius: AppRadius.inputAll,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.inputAll,
            border: Border.all(color: AppColors.borderDefault),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

