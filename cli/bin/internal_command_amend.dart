import 'context_for_internal_command.dart';
import 'internal_command.dart';

class InternalCommandAmend extends InternalCommand {
  InternalCommandAmend() : super("amend", "Amends and pushes changes.");

  @override
  void run(ContextForInternalCommand context) {
    if (context.git.diffCachedQuiet.runSync().exitCode == 0) {
      context.printToConsole("Can't amend - there is nothing staged. "
          "Run 'git add .' to add all the changes.");
      return;
    }
    context.git.commitAmendNoEdit
        .announce()
        .runSync()
        .printNotEmptyResultFields();
    context.git.pushForce.announce().runSync().printNotEmptyResultFields();
  }
}
