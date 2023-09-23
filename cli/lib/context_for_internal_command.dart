import 'package:stax/context.dart';
import 'package:stax/git.dart';

class ContextForInternalCommand {
  final List<String> args;
  final bool silent;

  late final git = Git(silent.toContext());

  ContextForInternalCommand(this.args, {this.silent = false});

  ContextForInternalCommand.empty() : this([]);

  ContextForInternalCommand.silent() : this([], silent: true);

  void printToConsole(Object? object) {
    if (silent) return;
    print(object);
  }
}
