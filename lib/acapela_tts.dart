import 'dart:async';

import 'package:flutter/services.dart';

class AcapelaTts {
  static const MethodChannel _channel = MethodChannel('acapela_tts');

  static Future<void> setLicense(int userId, int password, String license) async {
    return await _channel.invokeMethod('setLicense', {'userId': userId, 'password': password, 'license': license});
  }

  static Future<void> playTts(String text) async {
    return await _channel.invokeMethod('playTts', {'text': text});
  }

  static Future<bool> setVoice(String voice) async {
    return await _channel.invokeMethod('setVoice', {'voice': voice});
  }

  static Future<bool> setSpeechRate(double speed) async {
    return await _channel.invokeMethod('setSpeechRate', {'speed': speed});
  }

  static Future<double> get speechRate async {
    return await _channel.invokeMethod('getSpeechRate');
  }

  static Future<List<Object?>> get availableVoices async {
    return await _channel.invokeMethod('getAvailableVoices');
  }

  static Future<void> pause() async {
    return await _channel.invokeMethod('pause');
  }

  static Future<void> stop() async {
    return await _channel.invokeMethod('stop');
  }

  static Future<void> resume() async {
    return await _channel.invokeMethod('resume');
  }
}
