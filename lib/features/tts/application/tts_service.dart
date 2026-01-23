import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();

  TTSService() {
    _init();
  }

  void _init() async {
    await _flutterTts.setLanguage("tr-TR"); // Turkish default
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      // Web platformunda dilin bazen varsayılana dönmesini engellemek için
      // konuşmadan önce dili tekrar set ediyoruz.
      await _flutterTts.setLanguage("tr-TR");
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}

final ttsServiceProvider = Provider<TTSService>((ref) {
  return TTSService();
});
