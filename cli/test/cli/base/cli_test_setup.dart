import 'dart:io';

import 'package:stax/context/context.dart';

class CliTestSetup {
  String testFile;
  String bundleFile;
  String testRepoPath;

  CliTestSetup(this.testFile, this.bundleFile, this.testRepoPath);

  factory CliTestSetup.create() {
    final stackTraceLine = StackTrace.current.toString().split("\n")[2];
    final left = stackTraceLine.indexOf("(") + 1;
    final right = stackTraceLine.indexOf(
        ":",
        left +
            5 /* Just enough to jump over 'file:' at teh beginning of the uri */);
    final fileName =
        Uri.parse(stackTraceLine.substring(left, right)).toFilePath();
    final indexOfCliFolder = fileName.indexOf("/cli/test/cli/");
    return CliTestSetup(
      fileName,
      fileName.replaceRange(
          fileName.length - 4 /* Length of 'dart' filename extension*/,
          fileName.length,
          "bundle"),
      "${fileName.substring(0, indexOfCliFolder)}/cli/.test/repo",
    );
  }

  void setUp() {
    Context.implicit().git.clone.args([bundleFile, testRepoPath]).runSync();
  }

  void tearDown() {
    try {
      Directory(testRepoPath).deleteSync(recursive: true);
    } catch (e) {
      // no op, just ignore
    }
  }

  @override
  String toString() {
    return "$testFile $bundleFile $testRepoPath";
  }
}
