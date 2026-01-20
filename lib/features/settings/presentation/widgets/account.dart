import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/core/widgets/custom_alert.dart';
import 'package:lingora/core/widgets/custom_button.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/core/widgets/header.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';

class AccountWidget extends StatefulWidget {
  const AccountWidget({super.key});

  @override
  State<AccountWidget> createState() => _AccountWidgetState();
}

class _AccountWidgetState extends State<AccountWidget> {
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
            rightButtonColor: Theme.of(context).colorScheme.primary,
            functionleftButton: () {
              context.read<AuthAppCubit>().logout();
              Navigator.pop(context);
            },
            functionRightButton: () {
              Navigator.of(context).pop();
            },
            leftButtonTextColor: Theme.of(context).textTheme.bodyMedium?.color,
            rightButtonTextColor: Colors.white,
            leftBorder: Border.all(
                width: 1,
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.1)),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
        child: Column(
      children: [
        Header(icon: HeroIcons.user, title: "account".tr()),
        SizedBox(
          height: AppDimens.titleContentBetween,
        ),
        LayoutBuilder(builder: (context, _) {
          // Export button
          Widget exportButton = CustomButton(
              text: "export_data".tr(),
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.5),
                  width: 2),
              function: () {
                showSnackBar(context,
                    message: "feature_not_ready".tr(),
                    icon: HeroIcons.wrenchScrewdriver,
                    iconColor: Theme.of(context).colorScheme.primary);
              },
              icon: Icons.book,
              borderRadius: AppDimens.radiusL,
              textColor: Theme.of(context).textTheme.bodyMedium?.color ??
                  Colors.black);

          Widget logoutButton = BlocBuilder<AuthAppCubit, AuthAppState>(
            builder: (context, state) {
              bool isLoading = state.status == AuthAppStatus.loading;
              return CustomButton(
                  text: "logout".tr(),
                  color: Colors.red.withValues(alpha: 0.5),
                  isLoading: isLoading,
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.1),
                      width: 2),
                  function: () {
                    showSadMessageIfuserLogout(context);
                  },
                  icon: Icons.logout,
                  iconColor: Colors.white,
                  borderRadius: AppDimens.radiusL,
                  textColor: Colors.white);
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
    ));
  }
}
