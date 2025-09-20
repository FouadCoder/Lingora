import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';

class OnboardingWidget extends StatelessWidget {
  final String imageName;
  final String mainText;
  final String description;
  const OnboardingWidget({
    super.key,
    required this.imageName,
    required this.mainText,
    required this.description,
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
                child: Image.asset(
                  imageName,
                  fit: BoxFit.cover,
                )),
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
