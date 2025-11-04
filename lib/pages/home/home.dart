import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/pages/home/widgets/level_card.dart';
import 'package:lingora/pages/home/widgets/shortcuts.dart';
import 'package:lingora/pages/home/widgets/vocabulary_swiper.dart';
import 'package:lingora/core/widgets/app_container.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level Card
            UserProgressCard(),
            SizedBox(
              height: AppDimens.sectionSpacing,
            ),
            // Shortcuts
            ShortcutsHome(),
            SizedBox(
              height: AppDimens.sectionBetween,
            ),
            // Vocabulary from library
            VocabularySwiper(),
          ],
        ),
      )),
    );
  }
}
