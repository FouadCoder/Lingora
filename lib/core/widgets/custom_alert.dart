import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/custom_button.dart';
import 'package:lottie/lottie.dart';

class CustomeAlertdialog extends StatelessWidget {
  final String? image;
  final String animation;
  final bool isAnimation;
  final String headline;
  final String title;
  final String? leftButtonText;
  final String rightButtonText;
  final Color? leftbuttonColor;
  final Color rightButtonColor;
  final Color? leftButtonTextColor;
  final Color rightButtonTextColor;
  final VoidCallback? functionleftButton;
  final VoidCallback functionRightButton;
  final Gradient? leftGradient;
  final Gradient? rightGradient;

  const CustomeAlertdialog({
    super.key,
    this.image,
    required this.headline,
    required this.title,
    required this.animation,
    required this.isAnimation,
    this.leftButtonText,
    required this.rightButtonText,
    this.leftbuttonColor,
    required this.rightButtonColor,
    this.functionleftButton,
    required this.functionRightButton,
    this.leftButtonTextColor,
    required this.rightButtonTextColor,
    this.leftGradient,
    this.rightGradient,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: AppPlatform.isDesktop(context)
            ? MediaQuery.of(context).size.width * 0.5
            : MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Or Animation
            isAnimation
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: double.infinity,
                    child: Lottie.asset(animation),
                  )
                : SizedBox(
                    height: 75,
                    width: 75,
                    child: Image.asset(image!),
                  ),
            SizedBox(height: AppDimens.sectionBetween),
            // Headline
            Text(
              headline,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              height: AppDimens.subElementBetween,
            ),
            // message
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimens.sectionBetween),
            // Buttons
            Row(
              mainAxisAlignment: leftbuttonColor == null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              children: [
                if (leftButtonText != null)
                  Expanded(
                    child: CustomButton(
                        text: leftButtonText!,
                        color: leftGradient != null
                            ? Colors.transparent
                            : leftbuttonColor!,
                        function: functionleftButton!,
                        textColor: leftButtonTextColor,
                        gradient: leftGradient,
                        width: double.infinity),
                  ),
                if (leftButtonText != null)
                  SizedBox(width: AppDimens.buttonTagHorizontal),
                Expanded(
                  child: CustomButton(
                      text: rightButtonText,
                      color: rightGradient != null
                          ? Colors.transparent
                          : rightButtonColor,
                      function: functionRightButton,
                      textColor: rightButtonTextColor,
                      gradient: rightGradient,
                      width: double.infinity),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
