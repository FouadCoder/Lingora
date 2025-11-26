import 'package:lingora/core/service/audio_service.dart';

class PlayAudioUsecase {
  final AudioService audioService;

  PlayAudioUsecase(this.audioService);

  Future<void> call(String text, {required String lang}) async {
    if (text.trim().isEmpty || lang.isEmpty) return;
    await audioService.speak(text, lang: lang);
  }
}
