import 'package:flutter/material.dart';
import 'package:lingora/widgets/app_container.dart';

class WordDetailsScreen extends StatefulWidget {
  const WordDetailsScreen({super.key});

  @override
  State<WordDetailsScreen> createState() => _WordDetailsScreenState();
}

class _WordDetailsScreenState extends State<WordDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppContainer(
          child: SingleChildScrollView(
        child: Column(
          children: [
            // Word card

            // Meaning

            // Synonyms

            // Examples

            // Category

            // Notes

            // Reminders

            // Translated at
          ],
        ),
      )),
    );
  }
}
