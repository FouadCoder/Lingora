import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/core/platfrom.dart';
import 'package:lingora/widgets/custom_button.dart';
import 'package:lottie/lottie.dart';

class CustomState extends StatelessWidget {
  final String animation;
  final String title;
  final String message;
  final VoidCallback? onTap;
  final String? buttonText;
  final LinearGradient? gradient;
  final Color? textColor;
  final Color? color;
  final Color? titleColor;
  final Border? border;
  final bool isFullScreen;
  final AnimationController? animationController;
  const CustomState({
    super.key,
    required this.animation,
    required this.title,
    required this.message,
    this.onTap,
    this.buttonText,
    this.isFullScreen = false,
    this.textColor,
    this.gradient,
    this.titleColor,
    this.color,
    this.border,
    this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double smallAnimationHeight = AppPlatform.isPhone(context)
        ? min(MediaQuery.of(context).size.height * 0.30, 300)
        : min(MediaQuery.of(context).size.height * 0.35, 500);

    double fullAnimationHeight = AppPlatform.isPhone(context)
        ? min(MediaQuery.of(context).size.height * 0.50, 350)
        : min(MediaQuery.of(context).size.height * 0.50, 600);

    return Center(
      child: Container(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height:
                      isFullScreen ? fullAnimationHeight : smallAnimationHeight,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child:
                      Lottie.asset(animation, controller: animationController),
                ),
                SizedBox(
                  height: AppDimens.sectionBetween,
                ),
                // Title
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: titleColor ?? theme.textTheme.titleMedium!.color,
                  ),
                ),
                SizedBox(
                  height: AppDimens.subElementBetween,
                ),
                // message
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.outline),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: AppDimens.sectionBetween,
                ),

                if (onTap != null)
                  CustomButton(
                      text: buttonText ?? "",
                      color: color ?? Colors.transparent,
                      gradient: gradient,
                      function: onTap ?? () {},
                      border: border,
                      textColor: textColor)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
