import 'dart:convert';
import 'dart:io';

class AppDef {
  final Map<String, String> replacements;
  final List<String> skipComparison;

  static final AppDef _instance = _fromFile(File('appdef.json'));

  AppDef._(this.replacements, this.skipComparison);

  static AppDef _fromFile(File file) {
    return _fromJson(json.decode(file.readAsStringSync()));
  }

  static AppDef _fromJson(Map<String, dynamic> json) {
    return AppDef._(
      Map.from(json['replacements']),
      List<String>.from(json['skip_comparison']),
    );
  }

  factory AppDef() {
    return _instance;
  }
}
