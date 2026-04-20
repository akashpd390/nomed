import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Color? buttonColor;
  final Color? textColor;
  final String? prefix;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final String? sufix;
  final IconData? sufixIcon;
  final Color? sufixIconColor;
  final Function()? onTap;
  final TextStyle? textStyle;
  final Color? borderColor;
  final EdgeInsetsGeometry margin;

  const CustomButton({
    super.key,
    this.text,
    this.buttonColor,
    this.prefix,
    this.prefixIcon,
    this.onTap,
    this.prefixIconColor,
    this.textColor,
    this.textStyle,
    this.borderColor,
    this.sufix,
    this.sufixIcon,
    this.sufixIconColor,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: margin,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(
                color: borderColor ?? theme.hintColor.withValues(alpha: 0.4),
              ),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 16),
          ),
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(
            buttonColor ?? theme.primaryColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixIcon != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 14.0),
                child: Icon(prefixIcon!, color: prefixIconColor, size: 18),
              ),
            if (prefix != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 18.0),
                child: Image.asset(prefix!, height: 16, width: 16),
              ),
            SizedBox(width: prefix != null || prefixIcon != null ? 10 : 0),
            if (sufix != null || sufixIcon != null)
              SizedBox(width: sufix == null || sufixIcon == null ? 10 : 0),
            Text(
              text ?? "Continue",
              style: (textStyle ?? theme.textTheme.titleMedium)?.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor ?? theme.scaffoldBackgroundColor,
              ),
              textAlign: TextAlign.center,
            ),
            // SizedBox(width: sufix != null || sufixIcon != null ? 10 : 0),
            if (sufixIcon != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 14.0),
                child: Icon(sufixIcon!, color: sufixIconColor, size: 16),
              ),
            if (sufix != null)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 18.0),
                child: Image.asset(sufix!, height: 16, width: 16),
              ),
            if (prefix != null || prefixIcon != null)
              SizedBox(width: sufix == null || sufixIcon == null ? 20 : 0),
          ],
        ),
      ),
    );
  }
}
