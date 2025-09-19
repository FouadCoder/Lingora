import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final bool isLoading;
  final VoidCallback function;
  final double? width;
  final double? height;
  final double borderRadius;
  final Gradient? gradient;
  final Border? border;
  final IconData? icon;
  final Color? iconColor;
  final Widget? loadingWidget;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.function,
    required this.textColor,
    this.gradient,
    this.height,
    this.borderRadius = AppDimens.radiusXL,
    this.isLoading = false,
    this.border,
    this.width,
    this.icon,
    this.iconColor,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? () {} : function,
      child: Container(
          width: width ?? AppButtonSizes.width(context),
          height: height ?? AppButtonSizes.height(context),
          decoration: BoxDecoration(
            border: border,
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: gradient,
            color: gradient == null ? color : null,
          ),
          alignment: Alignment.center,
          child: isLoading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null)
                      Icon(
                        icon,
                        size: AppDimens.iconM,
                        color:
                            iconColor ?? Theme.of(context).colorScheme.primary,
                      ),
                    SizedBox(
                      width: AppDimens.spacingM,
                    ),
                    // button text
                    Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: AppButtonSizes.textSize(context),
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                )),
    );
  }
}
