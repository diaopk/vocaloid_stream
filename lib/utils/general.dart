import 'dart:convert';
import 'package:flutter/services.dart';

Future<dynamic> loadJSON(String path) async {
  final String res = await rootBundle.loadString(path);
  return json.decode(res);
}
