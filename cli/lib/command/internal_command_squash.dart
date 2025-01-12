import 'package:stax/command/internal_command.dart';
import 'package:stax/context/context.dart';
import 'package:stax/context/context_git_is_inside_work_tree.dart';
import 'package:stax/context/context_git_log_all.dart';
import 'package:stax/context/context_git_log_one_line_no_decorate_single_branch.dart';

class InternalCommandSquash extends InternalCommand {
  InternalCommandSquash()
      : super(
          'squash',
          'Ensures each branch has exactly one commit by squashing multiple commits if needed.',
        );

  @override
  void run(List<String> args, Context context) {
    if (context.handleNotInsideGitWorkingTree()) {
      return;
    }

    final root = context.withSilence(true).gitLogAll().collapse();

    if (root == null) {
      context.printToConsole("Can't find any branches.");
      return;
    }

    void processNode(GitLogAllNode node) {
      final branchName = node.line.branchNameOrCommitHash();
      final commits = context.logOneLineNoDecorateSingleBranch(branchName);

      // Skip if already has only one commit or is remote HEAD
      if (commits.length <= 1 || node.line.partsHasRemoteHead) {
        return;
      }

      // Get the commit message from the most recent commit
      final latestCommitMessage = commits.first.message;

      // Checkout the branch
      context.git.checkout
          .arg(branchName)
          .announce('Checking out $branchName')
          .runSync()
          .printNotEmptyResultFields();

      // Soft reset to the parent of the earliest commit
      final parentHash = commits.last.hash;
      context.git.reset
          .args(['--soft', '$parentHash~1'])
          .announce('Resetting to parent of earliest commit')
          .runSync()
          .printNotEmptyResultFields();

      // Create new commit with the latest commit message
      context.git.commitWithMessage
          .arg(latestCommitMessage)
          .announce('Creating new squashed commit')
          .runSync()
          .printNotEmptyResultFields();

      // Force push the changes
      context.git.pushForce
          .announce('Force pushing changes')
          .runSync()
          .printNotEmptyResultFields();

      // Process children recursively
      for (final child in node.children) {
        processNode(child);
      }
    }

    // Start processing from the root's children
    for (final child in root.children) {
      processNode(child);
    }
  }
}
