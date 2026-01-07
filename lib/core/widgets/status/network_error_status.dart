import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
      animation: "assets/animation/network_error.json",
      title: "network_error_title".tr(),
      message: "network_error_message".tr(),
      buttonText: "retry_connection".tr(),
      onTap: onTap,
      isFullScreen: isFullScreen,
    );
  }
}

void showErrorNetworkSnackBar(BuildContext context) {
  return showSnackBar(context,
      message: "network_error_quick".tr(),
      icon: Icons.wifi,
      iconColor: Colors.red);
}
