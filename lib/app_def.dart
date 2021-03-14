import 'dart:convert';
import 'dart:io';

import 'package:corpse_tools/entities/replacement.dart';

class AppDef {
  final List<Replacement> replacements;

  static final AppDef _instance = _fromFile(File('appdef.json'));

  AppDef._(this.replacements);

  static AppDef _fromFile(File file) {
    return _fromJson(json.decode(file.readAsStringSync()));
  }

  static AppDef _fromJson(Map<String, dynamic> json) {
    return AppDef._(Replacement.listFromJson(json['replacements']));
  }

  factory AppDef() {
    return _instance;
  }
}
