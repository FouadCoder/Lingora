import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lingora/core/platfrom.dart';
import 'package:lingora/models/word.dart';
import 'package:lingora/pages/library/library_card.dart';
import 'package:lingora/widgets/app_container.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final exampleWord = Word(
    word: "water waterwaterwaterwaterwater",
    translation: "waterwaterwaterwaterwater",
    partOfSpeech: "Noun",
    definition:
        "A colorless, transparent, odorless liquid essential transparent, odorless liquid essential transparent, odorless liquid essential",
    example:
        "Please bring me a glass of water transparent, odorless liquid essential transparent, odorless liquid essential",
    category: "Learning",
    transaltedTime: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    int getCrossAxisCount() {
      if (AppPlatform.isDesktop(context)) return 3;
      if (AppPlatform.isTablet(context)) return 2;
      if (AppPlatform.isPhone(context)) return 1;
      return 1;
    }

    return Scaffold(
      body: AppContainer(
          child: SingleChildScrollView(
        child: Column(
          children: [
            // List of words
            MasonryGridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: getCrossAxisCount(),
              ),
              crossAxisSpacing: 16,
              mainAxisSpacing: 8,
              itemBuilder: (context, index) {
                return WordCard(word: exampleWord);
              },
            ),
          ],
        ),
      )),
    );
  }
}
