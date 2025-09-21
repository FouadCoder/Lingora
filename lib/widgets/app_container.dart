import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';

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
          padding: EdgeInsets.all(AppDimens.wrapperPadding),
          child: child,
        ),
      ),
    );
  }
}
