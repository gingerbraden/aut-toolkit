import 'package:flutter_tts/flutter_tts.dart';

/// Service used as a wrapper for text2speech features..
class TtsService {
  static final FlutterTts _tts = FlutterTts();

  static String _currentLocale = 'en-GB';

  static double _speechRate = 0.5;
  static double _volume = 1.0;
  static double _pitch = 1.0;

  static final String TEST_ENG = "This is a test";
  static final String TEST_SK = "Toto je test";
  static final String TEST_CZ = "Tohle je test";

  static Future<void> setLanguage(String locale) async {
    switch (locale) {
      case "SK":
        _currentLocale = "sk-SK";
        await _tts.setLanguage(_currentLocale);
        await _tts.setVoice({
          "name": "sk-SK-language",
          "locale": _currentLocale,
        });
        break;

      case "CS":
        _currentLocale = "cs-CZ";
        await _tts.setLanguage(_currentLocale);
        await _tts.setVoice({
          "name": "cs-cz-x-jfs-local",
          "locale": _currentLocale,
        });
        break;

      case "EN":
      default:
        _currentLocale = "en-GB";
        await _tts.setLanguage(_currentLocale);
        await _tts.setVoice({
          "name": "en-gb-x-gba-local",
          "locale": _currentLocale,
        });
        break;
    }

    await _applySettings();
  }

  static Future<void> setSpeechRate(double value) async {
    _speechRate = value;
    await _tts.setSpeechRate(value);
  }

  static Future<void> setVolume(double value) async {
    _volume = value;
    await _tts.setVolume(value);
  }

  static Future<void> setPitch(double value) async {
    _pitch = value;
    await _tts.setPitch(value);
  }

  static double getSpeechRate() {
    return _speechRate;
  }

  static double getVolume() {
    return _volume;
  }

  static double getPitch() {
    return _pitch;
  }

  static Future<void> _applySettings() async {
    await _tts.setSpeechRate(_speechRate);
    await _tts.setVolume(_volume);
    await _tts.setPitch(_pitch);
  }

  static Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  static Future<void> speakTest() async {
    switch(_currentLocale) {
      case "sk-SK": speak(TEST_SK);
      case "en-GB": speak(TEST_ENG);
      case "cs-CZ": speak(TEST_CZ);
    }
  }
}
