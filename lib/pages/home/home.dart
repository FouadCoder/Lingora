import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/pages/home/widgets/level_card.dart';
import 'package:lingora/pages/home/widgets/shortcuts.dart';
import 'package:lingora/widgets/app_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppContainer(
          child: SingleChildScrollView(
        child: Column(
          children: [
            // Level Card
            LevelCard(),
            SizedBox(
              height: AppDimens.sectionSpacing,
            ),
            // Shortcuts
            ShortcutsHome(),
            SizedBox(
              height: AppDimens.sectionSpacing,
            ),
          ],
        ),
      )),
    );
  }
}
