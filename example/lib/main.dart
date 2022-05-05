import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:acapela_tts/acapela_tts.dart';
import 'package:acapela_tts_example/acapela_license.dart';
import 'package:acapela_tts_example/voices.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool initialized = false;
  bool downloadning = false;
  double? _speechRate = 100;
  List<String>? _voices;
  String? _selectedVoice;
  final AcapelaTts _acapelaTts = AcapelaTts();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final applicationSupportDirectory = await getApplicationSupportDirectory();
    if (applicationSupportDirectory.listSync().isEmpty) return;
    await initialize(applicationSupportDirectory.path);
    await getVoices();
    setState(() => initialized = true);
    await getSpeechRate();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Acapela TTS example app'),
        ),
        body: !initialized
            ? Center(
                child: downloadning
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _downloadVoices,
                        child: const Text('Download voices'),
                      ),
              )
            : Column(
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
                        _acapelaTts.setVoice(newValue);
                      }
                      setState(() => _selectedVoice = newValue);
                    },
                  ),
                  const Text('Click for tts'),
                  ElevatedButton(
                    onPressed: () => _acapelaTts.speak('Text till tal exempel'),
                    child: const Text('Test TTS'),
                  ),
                  const SizedBox(height: 20),
                  Text('Speechrate $_speechRate'),
                  Slider(
                    min: 0,
                    max: 255,
                    divisions: 255,
                    onChanged: _speechRate != null
                        ? (b) {
                            _acapelaTts.setSpeechRate(b);
                            setState(() => _speechRate = b);
                          }
                        : null,
                    value: _speechRate ?? 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: _acapelaTts.stop,
                        child: const Text('Stop'),
                      ),
                      ElevatedButton(
                        onPressed: _acapelaTts.pause,
                        child: const Text('Pause'),
                      ),
                      ElevatedButton(
                        onPressed: _acapelaTts.resume,
                        child: const Text('Resume'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> initialize(final String path) async {
    final license = await rootBundle.loadStructuredData(
      'assets/acapela_license',
      AcapelaLicense.parse,
    );

    await _acapelaTts.initialize(
      userId: license.userId,
      password: license.password,
      license: license.license,
      voicesPath: Directory(join(path, 'system', 'voices')).absolute.path,
    );
  }

  Future<void> getSpeechRate() async {
    double? speechRate;

    try {
      speechRate = await _acapelaTts.speechRate;
    } on PlatformException {
      speechRate = null;
    }
    if (speechRate != null) {
      speechRate = max(0, speechRate);
      speechRate = min(100, speechRate);
    }

    if (!mounted) return;

    setState(() => _speechRate = speechRate);
  }

  Future<void> getVoices() async {
    List<Object?>? voices;
    try {
      voices = await _acapelaTts.availableVoices;
      if (voices.isNotEmpty) {
        _acapelaTts.setVoice(voices.first.toString());
      }
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

  Future<void> _downloadVoices() async {
    setState(() => downloadning = true);
    final applicationSupportDirectory = await getApplicationSupportDirectory();

    await downloadVoices(
      applicationSupportDirectory.path,
      Uri.parse(await rootBundle.loadString('assets/voices_endpoint')),
    );
    await _init();
    setState(() => downloadning = false);
  }
}
