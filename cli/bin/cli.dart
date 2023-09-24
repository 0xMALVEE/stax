import 'package:stax/context/context.dart';

import 'internal_command_available_commands.dart';
import 'internal_commands.dart';

void main(List<String> arguments) {
  final context = Context.implicit();
  switch (arguments) {
    case []:
      InternalCommandAvailableCommands().run([], context);
    case [final commandName, ...final args]:
      final command = internalCommandRegistry[commandName];
      if (command == null) {
        print("Unknown command '$commandName'.");
        return;
      }
      command.run(args, context);
  }
}
