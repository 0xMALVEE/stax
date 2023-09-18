import 'external_command.dart';

class Git {
  static final branch = ExternalCommand.split("git branch");
  static final branchCurrent = branch.withArgument("--show-current");
  static final branchDelete = branch.withArgument("-D");
  static final branchVv = branch.withArgument("-vv");
  static final checkout = ExternalCommand.split("git checkout");
  static final checkoutNewBranch = checkout.withArgument("-b");
  static final commit = ExternalCommand.split("git commit");
  static final commitWithMessage = commit.withArgument("-m");
  static final diff = ExternalCommand.split("git diff");
  static final diffCachedQuiet = diff.withArguments(["--cached", "--quiet"]);
  static final fetch = ExternalCommand.split("git fetch");
  static final fetchWithPrune = fetch.withArgument("-p");
  static final pull = ExternalCommand.split("git pull");
  static final push = ExternalCommand.split("git push");
  static final revList = ExternalCommand.split("git rev-list");
  static final revListCount = revList.withArgument("--count");
  static final remote = ExternalCommand.split("git remote");
  static final revParse = ExternalCommand.split("git rev-parse");
  static final revParseAbbrevRef = revParse.withArgument("--abbrev-ref");
  final branch_ = branch;
  final branchCurrent_ = branchCurrent;
  final branchDelete_ = branchDelete;
  final branchVv_ = branchVv;
  final checkout_ = checkout;
  final checkoutNewBranch_ = checkoutNewBranch;
  final commit_ = commit;
  final commitWithMessage_ = commitWithMessage;
  final diff_ = diff;
  final diffCachedQuiet_ = diffCachedQuiet;
  final fetch_ = fetch;
  final fetchWithPrune_ = fetchWithPrune;
  final pull_ = pull;
  final push_ = push;
  final revList_ = revList;
  final revListCount_ = revListCount;
  final remote_ = remote;
  final revParse_ = revParse;
  final revParseAbbrevRef_ = revParseAbbrevRef;
}
