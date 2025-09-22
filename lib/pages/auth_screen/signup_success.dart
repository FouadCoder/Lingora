import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingora/widgets/app_container.dart';
import 'package:lingora/widgets/status/custom_status.dart';

class SignupSuccessScreen extends StatefulWidget {
  const SignupSuccessScreen({super.key});

  @override
  State<SignupSuccessScreen> createState() => _SignupSuccessScreenState();
}

class _SignupSuccessScreenState extends State<SignupSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3))
          ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppContainer(
          child: CustomState(
        animation: 'assets/animation/celebrate.json',
        animationController: _controller,
        title: 'signup_success_title'.tr(),
        message: 'signup_success_message'.tr(),
        buttonText: 'signup_success_button'.tr(),
        color: Theme.of(context).colorScheme.secondary,
        onTap: () {},
        isFullScreen: true,
        titleColor: Theme.of(context).colorScheme.secondary,
      )),
    );
  }
}
