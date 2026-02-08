import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lottie/lottie.dart';

class OnboardingWidget extends StatelessWidget {
  final String animation;
  final String mainText;
  final String description;
  final AnimationController? animationController;
  final bool? repeat;
  const OnboardingWidget({
    super.key,
    required this.animation,
    required this.mainText,
    required this.description,
    this.repeat = true,
    this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    double animationHeight = AppPlatform.isPhone(context)
        ? min(MediaQuery.of(context).size.height * 0.50, 350)
        : min(MediaQuery.of(context).size.height * 0.50, 600);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: AppDimens.sectionBetween),
        // Container for the images
        Container(
          padding: const EdgeInsets.all(AppDimens.paddingM),
          height: animationHeight,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Center(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.radiusXL),
                child: Lottie.asset(animation,
                    controller: animationController, repeat: repeat)),
          ),
        ),
        SizedBox(height: AppDimens.sectionBetween),
        // Main Text
        Text(
          mainText,
          style: Theme.of(context).textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimens.subElementBetween),
        // description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingM),
          child: Text(description,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).textTheme.bodySmall!.color),
              textAlign: TextAlign.center),
        ),
      ],
    );
  }
}
