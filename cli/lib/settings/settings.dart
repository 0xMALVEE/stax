import 'dart:convert';
import 'dart:io';

import 'package:cli_util/cli_util.dart';
import 'package:stax/settings/date_time_setting.dart';
import 'package:path/path.dart' as path;
import 'package:stax/settings/string_setting.dart';

class Settings {
  static Settings _load() {
    dynamic error = Exception('Unknown error');
    for (int i = 0; i < 3; i++) {
      if (!_file.existsSync()) {
        _file.createSync(recursive: true);
        _file.writeAsStringSync('{}', flush: true);
      }
      try {
        final map = jsonDecode(_file.readAsStringSync());
        return Settings(map);
      } catch (e) {
        _file.deleteSync();
        error = e;
      }
    }
    throw error;
  }

  static final _file = File.fromUri(
    path.toUri(path.join(applicationConfigHome('stax'), '.stax_config')),
  );

  static final instance = _load();

  final Map<String, dynamic> settings;

  late final DateTimeSetting lastUpdatePrompt =
      DateTimeSetting('last_update_prompt', DateTime.now(), this);

  late final StringSetting branchPrefix = StringSetting(
    'branch_prefix',
    '', // Default empty string
    this,
    'Prefix to add to all new branch names (e.g., "feature/")',
  );

  Settings(this.settings);

  String? operator [](String key) {
    final value = settings[key];
    return value is String ? value : null;
  }

  void operator []=(String key, String? value) {
    settings[key] = value;
  }

  void save() {
    _file.writeAsStringSync(jsonEncode(settings), flush: true);
  }
}
