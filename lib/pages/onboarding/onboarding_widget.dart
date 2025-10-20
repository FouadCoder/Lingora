import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';
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
    return SingleChildScrollView(
      child: Column(
        children: [
          // Container for the images
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Container(
            padding: const EdgeInsets.all(AppDimens.paddingM),
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.transparent),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.radiusXL),
                child: Lottie.asset(animation,
                    controller: animationController, repeat: repeat)),
          ),
          const SizedBox(height: 40),
          // Main Text
          Text(
            mainText,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // description
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingM),
            child: Text(description,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).textTheme.bodySmall!.color),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
