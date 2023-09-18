import 'dart:io';

import 'package:stax/extended_process_result.dart';

import 'context_for_internal_command.dart';
import 'internal_command.dart';

class InternalCommandTerminal extends InternalCommand {
  InternalCommandTerminal()
      : super(
            "terminal",
            "Command to test how dart executes commands in terminal. "
                "Executes any provided arguments as command in terminal.");

  @override
  void run(final ContextForInternalCommand context) {
    switch (context.args) {
      case []:
        context.printToConsole("No arguments provided.");
      case [final executable, ...final arguments]:
        Process.runSync(executable, arguments).extend().printAllResultFields();
    }
  }
}
