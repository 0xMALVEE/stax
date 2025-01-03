import 'package:collection/collection.dart';
import 'package:stax/command/internal_command.dart';
import 'package:stax/command/types_for_internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/settings/settings.dart';

class InternalCommandSettings extends InternalCommand {
  final availableSettings = [
    Settings.instance.branchPrefix,
  ].sortedBy((setting) => setting.name);
  final availableSubCommands = [
    'set',
  ].sorted();

  InternalCommandSettings()
      : super(
          'settings',
          'View or modify stax settings',
          type: InternalCommandType.hidden,
          arguments: {
            'arg1': 'Subcommand (set)',
            'opt2': 'Setting name (for set)',
            'opt3': 'New value (for set)',
          },
        );

  @override
  void run(final List<String> args, final Context context) {
    switch (args) {
      case ['set', final name, final value]
          when availableSettings.any((setting) => setting.name == name):
        availableSettings.firstWhere((x) => x.name == name).set(value);
        context.printToConsole('Updated setting: $name = $value');
      case ['set', final name, _]:
        context
            .printToConsole('''set: unknown setting '$name'. Available settings:
${availableSettings.map((setting) => " • ${setting.name}").join("\n")}''');
      case ['set', ...]:
        context
            .printToConsole('Usage: stax settings set <setting_name> <value>');
      case [final subCommand, ...]:
        context.printToConsole(
            '''Unknown sub-command '$subCommand'. Available sub-commands:
${availableSubCommands.map((subCommand) => " • $subCommand").join("\n")}''');
      case []:
      default:
        context.printToConsole(
            '''Please provide sub-command. Available sub-commands:
${availableSubCommands.map((subCommand) => " • $subCommand").join("\n")}''');
    }
  }
}
