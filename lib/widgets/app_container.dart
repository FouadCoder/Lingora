import 'package:flutter/material.dart';

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
          padding:
              const EdgeInsets.only(top: 35, right: 16, left: 16, bottom: 10),
          child: child,
        ),
      ),
    );
  }
}
