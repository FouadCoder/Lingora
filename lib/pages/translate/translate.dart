import 'package:flutter/material.dart';
import 'package:lingora/core/platfrom.dart';
import 'package:lingora/pages/translate/widgets/translation_input_output.dart';
import 'package:lingora/pages/translate/widgets/language_selector.dart';
import 'package:lingora/pages/translate/widgets/info_cards.dart';
import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/widgets/flushbar.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final TextEditingController _inputController = TextEditingController();
  late Language translateFrom;
  late Language translateTo;

  @override
  void initState() {
    super.initState();
    _inputController.text = "Nice"; // Mock data

    // Initialize with default languages
    translateFrom = LanguageData.getLanguageByCode("en")!;
    translateTo = LanguageData.getLanguageByCode("ar")!;
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = AppPlatform.isDesktop(context);
    final isTablet = AppPlatform.isTablet(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Language Selector
                LanguageSelector(
                  translateFrom: translateFrom,
                  translateTo: translateTo,
                  onSwap: () {
                    setState(() {
                      final temp = translateFrom;
                      translateFrom = translateTo;
                      translateTo = temp;
                    });
                  },
                  onTaptranslateTo: (Language language) {
                    setState(() {
                      translateTo = language;
                    });
                  },
                  onTaptranslateFrom: (Language language) {
                    setState(() {
                      translateFrom = language;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Translation Input/Output
                TranslationInputOutput(
                  inputController: _inputController,
                  isSwapped: false,
                  onTranslate: () {
                    showSnackBar(
                        context,
                        "",
                        "Thanks for using our app ",
                        Icons.verified_rounded,
                        Theme.of(context).colorScheme.secondary);
                  },
                ),

                const SizedBox(height: 24),

                // Info Cards
                InfoCards(
                  isDesktop: isDesktop,
                  isTablet: isTablet,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
