import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  /// pass title only if required to display
  final String? title;
  final String? hintText;
  final String? initialValue;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLines;
  final Color? bgColor;
  final bool showBorder;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool obscureText;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry contentPadding;
  final FocusNode? focusNode;
  final void Function(String)? onSubmit;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  static const EdgeInsetsGeometry _defaultContentPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 12,
  );

  const CustomTextField({
    super.key,
    this.title,
    this.hintText,
    this.initialValue,
    this.textEditingController,
    this.textInputType,
    this.onChanged,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.maxLines,
    this.bgColor,
    this.validator,
    this.onTap,
    this.showBorder = true,
    this.readOnly = false,
    this.margin = EdgeInsets.zero,
    this.focusNode,
    this.onSubmit,
    EdgeInsetsGeometry? contentPadding,
  }) : contentPadding = contentPadding ?? _defaultContentPadding;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
            ),
            const SizedBox(height: 12),
          ],
          TextFormField(
            focusNode: focusNode,
            keyboardType: textInputType,
            controller: textEditingController,
            initialValue: initialValue,
            style: theme.textTheme.bodyLarge,
            maxLines: maxLines,
            onTap: onTap,
            readOnly: readOnly,
            obscureText: obscureText,
            onFieldSubmitted: onSubmit,
            validator: validator,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              contentPadding: contentPadding,
              filled: true,
              fillColor: bgColor ?? theme.cardColor,
              isDense: true,
              border: _getBorder(theme.hintColor),
              enabledBorder: _getBorder(theme.hintColor),
              focusedBorder: _getBorder(theme.primaryColor),
              hintText: hintText,
              hintStyle: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputBorder _getBorder(Color color) {
    if (showBorder) {
      return OutlineInputBorder(
        borderSide: BorderSide(color: color.withValues(alpha: 0.3), width: 0.5),
        borderRadius: BorderRadius.circular(10),
      );
    } else {
      return InputBorder.none;
    }
  }
}
