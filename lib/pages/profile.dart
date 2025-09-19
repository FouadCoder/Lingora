import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/extensions/theme_data.dart';
import 'package:lingora/pages/translate_screen/widgets/translate_header.dart';
import 'package:lingora/widgets/app_card.dart';
import 'package:lingora/widgets/app_container.dart';
import 'package:lingora/widgets/custom_button.dart';
import 'package:lingora/widgets/custom_swtich.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  TranslatHeader(icon: Icons.settings, title: "settings".tr()),
                  CustomSwtich(
                      title: 'dark_mode'.tr(),
                      description: 'dark_mode_description'.tr(),
                      onChanged: (value) {},
                      controller: darkController,
                      icon: Icons.nightlight_round),
                  CustomSwtich(
                      title: 'push_notifications'.tr(),
                      description: 'push_notifications_description'.tr(),
                      onChanged: (value) {},
                      controller: notificationsController,
                      icon: Icons.notifications),
                  CustomSwtich(
                      title: 'sound_effects'.tr(),
                      description: 'sound_effects_description'.tr(),
                      onChanged: (value) {},
                      controller: soundController,
                      icon: Icons.volume_up),
                ],
              ),
            ),
            // Aaccount
            AppCard(
                child: Column(
              children: [
                TranslatHeader(icon: Icons.person, title: "account".tr()),
                CustomButton(
                    text: "export_data".tr(),
                    color: Colors.transparent,
                    border:
                        Border.all(color: Theme.of(context).border, width: 2),
                    function: () {},
                    icon: Icons.book,
                    borderRadius: 12,
                    textColor: Theme.of(context).textTheme.bodyMedium?.color ??
                        Colors.black),
                SizedBox(
                  height: AppDimens.spacingM,
                ),
                CustomButton(
                    text: "logout".tr(),
                    color: Colors.transparent,
                    border:
                        Border.all(color: Theme.of(context).border, width: 2),
                    function: () {},
                    icon: Icons.logout,
                    iconColor: Theme.of(context).colorScheme.error,
                    borderRadius: 12,
                    textColor: Theme.of(context).textTheme.bodyMedium?.color ??
                        Colors.black),
              ],
            ))
          ],
        ),
      )),
    );
  }
}
