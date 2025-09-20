import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingora/pages/onboarding/onboarding_widget.dart';
import 'package:lingora/widgets/app_container.dart';
import 'package:lingora/widgets/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final pageController = PageController();
  int currentIndex = 0;
  //Todo update the content
  final List onboardingData = [
    {
      "title": "Learn Smarter",
      "message": "Build your vocabulary with personalized practice every day.",
      "image": "assets/test.png",
    },
    {
      "title": "Track Progress",
      "message": "Stay motivated by watching your skills grow over time.",
      "image": "assets/test.png",
    },
    {
      "title": "Practice Anywhere",
      "message": "Quick sessions that fit right into your daily routine.",
      "image": "assets/test.png",
    },
    {
      "title": "Join the Community",
      "message": "Connect with learners worldwide and share your journey.",
      "image": "assets/test.png",
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
                height: MediaQuery.of(context).size.height * 0.30,
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
                        imageName: onboardingData[index]["image"],
                        mainText: onboardingData[index]["title"],
                        description: onboardingData[index]["message"]);
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
                    function: () {
                      if (currentIndex != onboardingData.length - 1) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.fastOutSlowIn,
                        );
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
          )),
        ],
      ),
    );
  }
}
