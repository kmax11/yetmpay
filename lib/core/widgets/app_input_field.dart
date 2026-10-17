import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/theme.dart';

/// Form input field matching the Figma design.
///
/// PIN and password fields: set [obscureText] to true — this also disables
/// autocorrect and text suggestions.
class AppInputField extends StatefulWidget {
  const AppInputField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.leadingIcon,
    this.trailingWidget,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.prefixText,
    this.prefixWidget,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final IconData? leadingIcon;
  final Widget? trailingWidget;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? prefixText;
  final Widget? prefixWidget;

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.labelMedium
                .copyWith(color: AppColors.subtleMuted),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        SizedBox(
          height: 48,
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            obscureText: _obscure,
            autocorrect: !widget.obscureText,
            enableSuggestions: !widget.obscureText,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            style:
                AppTextStyles.bodyMedium.copyWith(color: AppColors.darkText),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.slatePlaceholder),
              prefixText: widget.prefixText,
              prefixStyle: AppTextStyles.labelMedium
                  .copyWith(color: AppColors.darkText),
              prefixIcon: widget.prefixWidget ??
                  (widget.leadingIcon != null
                      ? Icon(widget.leadingIcon,
                          size: 18, color: AppColors.slatePlaceholder)
                      : null),
              suffixIcon: widget.obscureText
                  ? IconButton(
                      onPressed: () =>
                          setState(() => _obscure = !_obscure),
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: AppColors.slatePlaceholder,
                      ),
                    )
                  : widget.trailingWidget,
              filled: true,
              fillColor: AppColors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.inputAll,
                borderSide:
                    const BorderSide(color: AppColors.borderDefault),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.inputAll,
                borderSide:
                    const BorderSide(color: AppColors.borderDefault),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.inputAll,
                borderSide: const BorderSide(
                    color: AppColors.primaryGreen, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

