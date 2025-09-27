import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/extensions/theme_data.dart';
import 'package:lingora/widgets/header.dart';
import 'package:lingora/widgets/app_card.dart';
import 'package:lingora/widgets/app_container.dart';
import 'package:lingora/widgets/custom_alert.dart';
import 'package:lingora/widgets/custom_button.dart';
import 'package:lingora/widgets/custom_swtich.dart';
import 'package:lingora/widgets/flushbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ValueNotifier<bool> darkController = ValueNotifier(false);
  final ValueNotifier<bool> notificationsController = ValueNotifier(false);
  final ValueNotifier<bool> soundController = ValueNotifier(false);

  @override
  void dispose() {
    darkController.dispose();
    notificationsController.dispose();
    soundController.dispose();
    super.dispose();
  }

  void showSadMessageIfuserLogout(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomeAlertdialog(
              headline: 'isThisGoodbye'.tr(),
              title: 'leaveMessage'.tr(),
              animation: "assets/animation/cry.json",
              isAnimation: true,
              leftButtonText: 'logout'.tr(),
              rightButtonText: 'stay'.tr(),
              leftbuttonColor: Theme.of(context).colorScheme.onSurface,
              rightButtonColor: Theme.of(context).colorScheme.secondary,
              functionleftButton: () {
                context.read<AuthAppCubit>().logout();
                Navigator.pop(context);
              },
              functionRightButton: () {
                Navigator.of(context).pop();
              },
              leftButtonTextColor: Theme.of(context).colorScheme.primary,
              rightButtonTextColor: Colors.white);
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthAppCubit, AuthAppState>(
      listener: (context, state) {
        // success
        if (state.status == AuthAppStatus.success && context.mounted) {
          context.go('/login');
        }

        // Error
        else if (state.status == AuthAppStatus.error) {
          showSnackBar(
            context,
            message: 'error_words_title'.tr(),
            icon: Icons.error_outline,
            iconColor: Theme.of(context).colorScheme.error,
          );
        }
      },
      child: Scaffold(
        body: AppContainer(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ), // Todo delete this
              // Setting
              AppCard(
                child: Column(
                  children: [
                    Header(icon: Icons.settings, title: "settings".tr()),
                    SizedBox(
                      height: AppDimens.titleContentBetween,
                    ),
                    CustomSwtich(
                        title: 'dark_mode'.tr(),
                        description: 'dark_mode_description'.tr(),
                        onChanged: (value) {},
                        controller: darkController,
                        icon: Icons.nightlight_round),
                    SizedBox(
                      height: AppDimens.sectionSpacing,
                    ),
                    CustomSwtich(
                        title: 'push_notifications'.tr(),
                        description: 'push_notifications_description'.tr(),
                        onChanged: (value) {},
                        controller: notificationsController,
                        icon: Icons.notifications),
                    SizedBox(
                      height: AppDimens.sectionSpacing,
                    ),
                    CustomSwtich(
                        title: 'sound_effects'.tr(),
                        description: 'sound_effects_description'.tr(),
                        onChanged: (value) {},
                        controller: soundController,
                        icon: Icons.volume_up),
                  ],
                ),
              ),
              SizedBox(
                height: AppDimens.sectionSpacing,
              ),
              // Aaccount
              AppCard(
                  child: Column(
                children: [
                  Header(icon: Icons.person, title: "account".tr()),
                  SizedBox(
                    height: AppDimens.titleContentBetween,
                  ),
                  CustomButton(
                      text: "export_data".tr(),
                      color: Colors.transparent,
                      border:
                          Border.all(color: Theme.of(context).border, width: 2),
                      function: () {},
                      icon: Icons.book,
                      borderRadius: AppDimens.radiusL,
                      textColor:
                          Theme.of(context).textTheme.bodyMedium?.color ??
                              Colors.black),
                  SizedBox(
                    height: AppDimens.sectionSpacing,
                  ),
                  // Logout
                  BlocBuilder<AuthAppCubit, AuthAppState>(
                    builder: (context, state) {
                      bool isLoading = state.status == AuthAppStatus.loading;
                      return CustomButton(
                          text: "logout".tr(),
                          color: Colors.transparent,
                          isLoading: isLoading,
                          border: Border.all(
                              color: Theme.of(context).border, width: 2),
                          function: () {
                            showSadMessageIfuserLogout(context);
                          },
                          icon: Icons.logout,
                          iconColor: Theme.of(context).colorScheme.error,
                          borderRadius: AppDimens.radiusL,
                          textColor: Theme.of(context).colorScheme.error);
                    },
                  ),
                ],
              ))
            ],
          ),
        )),
      ),
    );
  }
}
