import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class TemplateService {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/credential_templates.json');
  }

  static Future<void> saveTemplate(String name, Map<String, dynamic> data) async {
    final file = await _localFile;
    Map<String, dynamic> templates = {};
    if (await file.exists()) {
      templates = json.decode(await file.readAsString());
    }
    templates[name] = data;
    await file.writeAsString(json.encode(templates));
  }

  static Future<Map<String, dynamic>> loadTemplates() async {
    final file = await _localFile;
    if (await file.exists()) {
      return json.decode(await file.readAsString());
    }
    return {};
  }
}
