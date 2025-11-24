import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/core/extensions/theme_data.dart';
import 'package:lingora/core/widgets/header.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/core/widgets/custom_alert.dart';
import 'package:lingora/core/widgets/custom_button.dart';
import 'package:lingora/core/widgets/custom_swtich.dart';
import 'package:lingora/core/widgets/flushbar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final ValueNotifier<bool> darkController = ValueNotifier(false);
  final ValueNotifier<bool> notificationsController = ValueNotifier(false);

  @override
  void dispose() {
    darkController.dispose();
    notificationsController.dispose();
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
                        title: 'notifications'.tr(),
                        description: 'general_notifications'.tr(),
                        onChanged: (value) {},
                        controller: notificationsController,
                        icon: Icons.notifications),
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
                  LayoutBuilder(builder: (context, _) {
                    // Export button
                    Widget exportButton = CustomButton(
                        text: "export_data".tr(),
                        color: Colors.transparent,
                        border: Border.all(
                            color: Theme.of(context).border, width: 2),
                        function: () {},
                        icon: Icons.book,
                        borderRadius: AppDimens.radiusL,
                        textColor:
                            Theme.of(context).textTheme.bodyMedium?.color ??
                                Colors.black);

                    Widget logoutButton =
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
                    );

                    // Layout
                    if (AppPlatform.isPhone(context)) {
                      return Column(
                        children: [
                          exportButton,
                          SizedBox(
                            height: AppDimens.sectionSpacing,
                          ),
                          logoutButton
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          exportButton,
                          SizedBox(
                            width: AppDimens.buttonTagHorizontal,
                          ),
                          logoutButton
                        ],
                      );
                    }
                  }),
                ],
              ))
            ],
          ),
        )),
      ),
    );
  }
}
