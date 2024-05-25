import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseReader {
  final _encoder = const JsonEncoder.withIndent('  ');

  Future<String> getFullPath() async {
    final directory = await getApplicationDocumentsDirectory();
    const path = '/CuntySchoolPlaner/database';
    const fileName = 'data.gz';
    final fullPath = directory.path + path + fileName;
    return fullPath;
  }

  /// Write encrypted data to file
  Future<void> writeFile({
    required Map data, required String path}) async {
      if(kIsWeb) return;

      String json = _encoder.convert(data);
      var bytes = utf8.encode(json);
      var compressed = gzip.encode(bytes);
      await File(path).writeAsBytes(compressed);
  }

  /// Read encrypted data from file
  Future<Map> readFile({required String path}) async {
    if(kIsWeb) return {};

    var compressed = await File(path).readAsBytes();
    var bytes = gzip.decode(compressed);
    var json = utf8.decode(bytes);
    return jsonDecode(json);
  }

}