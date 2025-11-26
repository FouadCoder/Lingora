import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  final FlutterTts _tts = FlutterTts();

  /// Speak text in a specific language
  Future<void> speak(String text, {required String lang}) async {
    _tts.setSpeechRate(0.5);
    _tts.setPitch(1.0);
    await _tts.setLanguage(lang);
    await _tts.speak(text);
  }

  /// Stop the audio
  Future<void> stop() async {
    await _tts.stop();
  }

  /// Check if speaking is supported
  Future<bool> isLanguageAvailable(String lang) async {
    final languages = await _tts.getLanguages;
    return languages.contains(lang);
  }
}
