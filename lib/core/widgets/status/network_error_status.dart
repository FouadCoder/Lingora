import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/widgets/custom_status.dart';
import 'package:lingora/core/widgets/flushbar.dart';

class NetworkErrorView extends StatelessWidget {
  final VoidCallback onTap;
  final bool isFullScreen;
  const NetworkErrorView(
      {super.key, required this.onTap, this.isFullScreen = true});

  @override
  Widget build(BuildContext context) {
    return CustomState(
      animation: "assets/animation/cat_error_network.json",
      title: "network_error_title".tr(),
      message: "network_error_message".tr(),
      buttonText: "retry_connection".tr(),
      onTap: onTap,
      color: Theme.of(context).colorScheme.primary,
      isFullScreen: isFullScreen,
      buttonTextColor: Colors.white,
    );
  }
}

void showErrorNetworkSnackBar(BuildContext context) {
  return showSnackBar(context,
      message: "network_error_quick".tr(),
      icon: HeroIcons.wifi,
      iconColor: Colors.red);
}
