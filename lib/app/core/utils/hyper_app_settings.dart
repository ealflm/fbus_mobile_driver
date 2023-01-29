// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/services.dart';

/// Create a file [app_settings.json] at project root folder
/// and add the file name in pubspec.yaml assets
class AppSettings {
  static final AppSettings _instance = AppSettings._internal();
  static AppSettings get instance => _instance;
  AppSettings._internal();

  late final Map<String, dynamic> _data;

  /// Data need to be loaded on app startup, recommend to do it `main.dart`
  static Future<void> init() async {
    final jsonString = await rootBundle.loadString('app_settings.json');
    _instance._data = jsonDecode(jsonString);
  }

  /// Returns a specific variable value give a [key]
  static dynamic get(String key) {
    var data = _instance._data;
    if (data.isEmpty) {
      print(
        'AppSettings data are Empty\n'
        'Ensure you have a [app_settings.json] file and you\n'
        'have called init method',
      );
    } else if (data.containsKey(key)) {
      return data[key];
    } else {
      print(
        'AppSettings Value for Key($key) not found\n'
        'Ensure you have it in [app_settings.json] file',
      );
    }
  }
}
