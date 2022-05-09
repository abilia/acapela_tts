import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:path/path.dart';

Future<List<String>> downloadVoices(final String dir, final Uri url) async {
  final res = await get(url);
  if (res.statusCode == 200) {
    final firstVoice = (json.decode(res.body) as List)
        .map((e) => Voice.fromJson(e))
        .where((v) => v.type == 1)
        .first;

    return await Future.wait(
      firstVoice.files.map(
        (file) async {
          final response = await get(Uri.parse(file.downloadUrl));
          final path = joinAll([dir, ...file.localPath.split('/')]);
          final f = await File(path).create(recursive: true);
          await f.writeAsBytes(response.bodyBytes);
          return path;
        },
      ),
    );
  }
  return [];
}

class Voice {
  String name;
  int type;
  String lang;
  List<VoiceFile> files;

  Voice({
    required this.name,
    required this.type,
    required this.lang,
    required this.files,
  });

  factory Voice.fromJson(Map<String, dynamic> _json) => Voice(
        name: _json['name'],
        type: _json['type'],
        lang: _json['lang'],
        files: (_json['files'] != null)
            ? (_json['files'] as List)
                .map((t) => VoiceFile.fromJson(t))
                .toList()
            : <VoiceFile>[],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'type': type,
        'lang': lang,
        'files': files.map((v) => v.toJson()).toList(),
      };
}

class VoiceFile {
  final String downloadUrl;
  final String md5;
  final String localPath;
  final String size;

  VoiceFile({
    required this.downloadUrl,
    required this.md5,
    required this.localPath,
    required this.size,
  });

  factory VoiceFile.fromJson(Map<String, dynamic> json) => VoiceFile(
        downloadUrl: json['downloadUrl'],
        md5: json['md5'],
        localPath: json['localPath'],
        size: json['size'],
      );

  Map<String, dynamic> toJson() => {
        'downloadUrl': downloadUrl,
        'md5': md5,
        'localPath': localPath,
        'size': size,
      };
}
