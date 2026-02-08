import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lingora/features/auth/presentation/pages/onboarding/onboarding_widget.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/core/widgets/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final pageController = PageController();
  int currentIndex = 0;
  late AnimationController _rocketAnimationController;

  @override
  void initState() {
    super.initState();
    _rocketAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
  }

  @override
  void dispose() {
    _rocketAnimationController.dispose();
    super.dispose();
  }

  //Todo update the content
  final List onboardingData = [
    {
      "title": "onboarding_1_title".tr(),
      "message": "onboarding_1_message".tr(),
      "animation": "assets/animation/world_language.json",
      "repeat": true,
    },
    {
      "title": "onboarding_2_title".tr(),
      "message": "onboarding_2_message".tr(),
      "animation": "assets/animation/Idea_books.json",
      "repeat": false,
    },
    {
      "title": "onboarding_3_title".tr(),
      "message": "onboarding_3_message".tr(),
      "animation": "assets/animation/analysis.json",
      "repeat": true,
    },
    {
      "title": "onboarding_4_title".tr(),
      "message": "onboarding_4_message".tr(),
      "animation": "assets/animation/rocket_launch.json",
      "repeat": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background colors
          Column(
            children: [
              Container(
                height: min(MediaQuery.of(context).size.height * 0.15, 250),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary, // top
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor, // bottom
                ),
              ),
            ],
          ),
          // Content
          AppContainer(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Page view to switch between Pages
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: PageView(
                    onPageChanged: (val) {
                      setState(() {
                        currentIndex = val;
                      });
                    },
                    controller: pageController,
                    children: List.generate(onboardingData.length, (index) {
                      return OnboardingWidget(
                          animation: onboardingData[index]["animation"],
                          mainText: onboardingData[index]["title"],
                          description: onboardingData[index]["message"],
                          repeat: onboardingData[index]["repeat"],
                          animationController:
                              index == onboardingData.length - 1
                                  ? _rocketAnimationController
                                  : null);
                    }),
                  ),
                ),
                // Button
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                  child: CustomButton(
                      text: currentIndex == onboardingData.length - 1
                          ? "get_statred".tr()
                          : "next".tr(),
                      color: Theme.of(context).colorScheme.secondary,
                      function: () async {
                        if (currentIndex != onboardingData.length - 1) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.fastOutSlowIn,
                          );
                          return;
                        }
                        // Trigger rocket animation and wait for it to complete
                        await _rocketAnimationController.forward();
                        // Navigate to login after animation completes
                        if (mounted) {
                          context.go('/login');
                        }
                      },
                      textColor: Colors.white),
                ),
                // Animation for switch
                SmoothPageIndicator(
                  controller: pageController,
                  count: 4,
                  effect: ExpandingDotsEffect(
                      activeDotColor: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
