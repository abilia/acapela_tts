import 'dart:async';

import 'package:acapela_tts/acapela_tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double? _speechRate = 100;
  List<String>? _voices;
  String? _selectedVoice;

  @override
  void initState() {
    super.initState();
    setLicense();
    getSpeechRate();
    getVoices();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Acapela TTS example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              value: _selectedVoice,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: _voices?.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  AcapelaTts.setVoice(newValue);
                }
                setState(() {
                  _selectedVoice = newValue;
                });
              },
            ),
            const Text('Click for tts'),
            ElevatedButton(
              onPressed: () => AcapelaTts.speak('Text till tal exempel'),
              child: const Text('Test TTS'),
            ),
            const SizedBox(height: 20),
            Text('Speechrate $_speechRate'),
            Slider(
              min: 0,
              max: 1000,
              onChanged: _speechRate != null
                  ? (b) {
                      AcapelaTts.setSpeechRate(b);
                      setState(() => _speechRate = b);
                    }
                  : null,
              value: _speechRate ?? 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => AcapelaTts.stop(),
                  child: const Text('Stop'),
                ),
                ElevatedButton(
                  onPressed: () => AcapelaTts.pause(),
                  child: const Text('Pause'),
                ),
                ElevatedButton(
                  onPressed: () => AcapelaTts.resume(),
                  child: const Text('Resume'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setLicense() async {
    // TODO: insert license here
    await AcapelaTts.setLicense(
    0,
    0,
    "");
}

  Future<void> getSpeechRate() async {
    double? volume;

    try {
      volume = await AcapelaTts.speechRate;
    } on PlatformException {
      volume = null;
    }

    if (!mounted) return;

    setState(() {
      _speechRate = volume;
    });
  }

  Future<void> getVoices() async {
    List<Object?>? voices;
    try {
      voices = await AcapelaTts.availableVoices;
    } on PlatformException {
      voices = null;
    }

    if (!mounted) return;

    setState(() {
      _voices?.clear();
      if (voices != null) {
        _voices = (voices.map((e) => e.toString())).toList();
      }
    });
  }
}
