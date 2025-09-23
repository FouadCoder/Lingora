import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lingora/core/app_constants.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;

  final bool highLight;
  final String highlightText;

  final Widget? prefixIcon;
  final Color? prefixIconColor;

  final IconData? topIcon;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool readOnly;
  final VoidCallback? onTap;
  final void Function(String)? onChange;
  final Widget? suffixIcon;
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? textInputFormatter;
  final double? height;

  const CustomTextfield(
      {super.key,
      required this.controller,
      required this.label,
      required this.hint,
      this.highLight = false,
      this.highlightText = "",
      this.topIcon,
      this.backgroundColor,
      this.borderColor,
      this.readOnly = false,
      this.onTap,
      this.onChange,
      this.suffixIcon,
      this.maxLength,
      this.keyboardType,
      this.textInputFormatter,
      this.height,
      this.prefixIcon,
      this.prefixIconColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Text and Icon
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (topIcon != null)
              Icon(
                topIcon,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            if (topIcon != null)
              SizedBox(height: AppDimens.buttonTagHorizontal),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: AppDimens.elementBetween),

        // TextField Container
        Container(
          height: height ?? 48, // Standard height for text fields
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor ??
                  (highLight
                      ? theme.colorScheme.error
                      : theme.colorScheme.outline.withOpacity(0.1)),
              width: 1,
            ),
          ),
          child: TextFormField(
            onChanged: onChange,
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              prefixIcon: prefixIcon,
              prefixIconColor: prefixIconColor ?? theme.colorScheme.primary,
              alignLabelWithHint: true,
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.outline,
              ),

              border: InputBorder
                  .none, // Remove default border since we have custom container
              enabledBorder: InputBorder.none, // Remove enabled state border
              focusedBorder: InputBorder.none, // Remove focused state border
              errorBorder: InputBorder.none, // Remove error state border
              focusedErrorBorder:
                  InputBorder.none, // Remove focused error state border
              disabledBorder: InputBorder.none, // Remove disabled state border
              filled: false, // Don't fill since we have custom container
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding:
                          const EdgeInsets.only(right: 8), // Button padding
                      child: suffixIcon,
                    )
                  : null,
              counterText: '',
            ),
            style: theme.textTheme.bodyMedium,
            keyboardType: keyboardType,
            inputFormatters: textInputFormatter,
            minLines: 1,
            maxLines: null,
            readOnly: readOnly,
            onTap: onTap,
            maxLength: maxLength,
          ),
        ),

        // Highlight Text
        if (highLight)
          Padding(
            padding: const EdgeInsets.only(top: 8), // Related widgets spacing
            child: Text(
              highlightText,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
            ),
          ),
      ],
    );
  }
}
