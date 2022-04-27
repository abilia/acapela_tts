import 'dart:async';

import 'package:flutter/services.dart';

class AcapelaTts {
  static const MethodChannel _channel = MethodChannel('acapela_tts');

  Future<bool> setLicense(int userId, int password, String license) async {
    return await _channel.invokeMethod('setLicense',
        {'userId': userId, 'password': password, 'license': license});
  }

  Future<void> speak(String text) async {
    return await _channel.invokeMethod('speak', {'text': text});
  }

  Future<bool> setVoice(String voice) async {
    return await _channel.invokeMethod('setVoice', {'voice': voice});
  }

  Future<bool> setSpeechRate(double speed) async {
    return await _channel.invokeMethod('setSpeechRate', {'speed': speed});
  }

  Future<double> get speechRate async {
    return await _channel.invokeMethod('getSpeechRate');
  }

  Future<List<Object?>> get availableVoices async {
    return await _channel.invokeMethod('getAvailableVoices');
  }

  Future<void> pause() async {
    return await _channel.invokeMethod('pause');
  }

  Future<void> stop() async {
    return await _channel.invokeMethod('stop');
  }

  Future<void> resume() async {
    return await _channel.invokeMethod('resume');
  }
}
