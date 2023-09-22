import 'dart:convert';
import 'dart:io';

import 'package:stax/context_for_internal_command.dart';
import 'package:stax/file_path_dir_on_uri.dart';
import 'package:stax/shortcuts_for_internal_command_context.dart';

class Settings {
  static Settings _load() {
    dynamic error = Exception("Unknown error");
    for (int i = 0; i < 3; i++) {
      if (!_file.existsSync()) {
        _file.createSync();
        _file.writeAsStringSync("{}", flush: true);
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

  static final _rootPath = ContextForInternalCommand.silent()
      .getRepositoryRoot(workingDirectory: Platform.script.toFilePathDir());

  static final _file = File("$_rootPath/.stax_settings");

  static final instance = _load();

  final Map<String, dynamic> settings;

  Settings(this.settings);

  void save() {
    _file.writeAsStringSync(jsonEncode(settings), flush: true);
  }
}
