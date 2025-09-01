import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lingora/core/app_colors.dart';
import 'package:lingora/core/platfrom.dart';
import 'package:lingora/pages/translate/widgets/translation_input_output.dart';
import 'package:lingora/pages/translate/widgets/language_selector.dart';
import 'package:lingora/widgets/action_buttons.dart';
import 'package:lingora/pages/translate/widgets/info_cards.dart';

class TranslateScreen extends StatefulWidget {
  const TranslateScreen({super.key});

  @override
  State<TranslateScreen> createState() => _TranslateScreenState();
}

class _TranslateScreenState extends State<TranslateScreen> {
  final TextEditingController _inputController = TextEditingController();
  bool _isSwapped = false;

  @override
  void initState() {
    super.initState();
    _inputController.text = "Nice"; // Mock data
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
                  isSwapped: _isSwapped,
                  onSwap: () {
                    setState(() {
                      _isSwapped = !_isSwapped;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // Translation Input/Output
                TranslationInputOutput(
                  inputController: _inputController,
                  isSwapped: _isSwapped,
                  onTranslate: () {
                    // TODO: Implement translate functionality
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
