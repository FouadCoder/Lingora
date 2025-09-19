import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/widgets/custom_button.dart';
import 'package:lottie/lottie.dart';

class CustomState extends StatelessWidget {
  final Color textColor;
  final String animation;
  final double spaceInScreen;
  final String title;
  final String message;
  final VoidCallback? onTap;
  final String? buttonText;
  final LinearGradient? gradient;
  final Color? color;
  final Border? border;
  const CustomState(
      {super.key,
      required this.textColor,
      required this.animation,
      required this.spaceInScreen,
      required this.title,
      this.onTap,
      this.buttonText,
      this.gradient,
      this.color,
      this.border,
      required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  height: MediaQuery.of(context).size.height * spaceInScreen,
                ), // space to set the image in center
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.30,
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: Lottie.asset(animation),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Title
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                // message
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(
                  height: 15,
                ),
                if (onTap != null)
                  CustomButton(
                      text: buttonText!,
                      color: color!,
                      gradient: gradient,
                      function: onTap!,
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
