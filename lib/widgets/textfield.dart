import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool highLight;
  final String highlightText;
  final String? topText;
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

  const CustomTextfield({
    super.key,
    required this.controller,
    required this.hintText,
    required this.highLight,
    required this.highlightText,
    this.topIcon,
    this.topText,
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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Text and Icon
          if (topText != null || topIcon != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (topIcon != null)
                  Icon(
                    topIcon,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                if (topIcon != null && topText != null)
                  const SizedBox(width: 8), // Related widgets spacing
                if (topText != null)
                  Expanded(
                    child: Text(
                      topText!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),

          if (topText != null || topIcon != null)
            const SizedBox(
                height: 12), // Medium spacing between related sections

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
                        : theme.colorScheme.outline.withOpacity(0.3)),
                width: 1,
              ),
            ),
            child: TextFormField(
              onChanged: onChange,
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
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
                disabledBorder:
                    InputBorder.none, // Remove disabled state border
                contentPadding:
                    const EdgeInsets.all(16), // Standard container padding
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
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
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
      ),
    );
  }
}
