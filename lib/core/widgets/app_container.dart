import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';

class AppContainer extends StatelessWidget {
  final Widget child;
  const AppContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200), // cap width
        child: Padding(
          padding: EdgeInsets.only(
            top: AppDimens.wrapperPadding + MediaQuery.of(context).padding.top,
            left: AppDimens.wrapperPadding,
            right: AppDimens.wrapperPadding,
            bottom: AppDimens.wrapperPadding,
          ),
          child: child,
        ),
      ),
    );
  }
}
