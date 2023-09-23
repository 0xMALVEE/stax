import 'package:stax/context/context.dart';

enum AheadOrBehind { ahead, behind, none }

extension ContextHitIsCurrentBranchAheadOrBehind on Context {
  AheadOrBehind? isCurrentBranchAheadOrBehind({String? workingDirectory}) {
    final statusSb = git.statusSb
        .announce("Checking if current branch is behind remote.")
        .runSync(workingDirectory: workingDirectory)
        .printNotEmptyResultFields()
        .assertSuccessfulExitCode()
        ?.stdout
        .toString();
    if (statusSb == null) return null;
    if (statusSb.contains(" [behind ")) return AheadOrBehind.behind;
    if (statusSb.contains(" [ahead ")) return AheadOrBehind.ahead;
    return AheadOrBehind.none;
  }

  bool isCurrentBranchBehind({String? workingDirectory}) {
    return isCurrentBranchAheadOrBehind(workingDirectory: workingDirectory) ==
        AheadOrBehind.behind;
  }
}
