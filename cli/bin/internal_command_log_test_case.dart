import 'package:collection/collection.dart';
import 'package:stax/context/context.dart';

import 'internal_command.dart';
import 'types_for_internal_command.dart';

class _Commit {
  final _Commit? parent;
  final int id;
  final List<_Commit> children = List.empty(growable: true);
  static int nextId = 1;

  _Commit([this.parent]) : id = nextId;

  _Commit newChildCommit() => _Commit(this);

  void assignChild() {
    if (parent == null) return;
    parent?.children.add(this);
  }
}

class InternalCommandLogTestCase extends InternalCommand {
  InternalCommandLogTestCase()
      : super("log-test-case", "shows test case for log command",
            type: InternalCommandType.hidden);

  @override
  void run(List<String> args, Context context) {
    var commitsSet = [
      [_Commit()]
    ];
    void printUml(int prefix) {
      for (int index = 0; index < commitsSet.length; index++) {
        for (int mainId = 1; mainId <= commitsSet[index].length; mainId++) {
          String name(_Commit commit) =>
              "${prefix}_${index + 1}_${mainId}_${commit.id}${commit.id == mainId ? "_main" : ""}";
          String nodeName(_Commit commit) => "(${name(commit)})";
          final commits = commitsSet[index];
          for (var commit in commits) {
            commit.children.clear();
          }
          for (var commit in commits) {
            commit.assignChild();
          }
          if (commits.length == 1) {
            context.printToConsole(nodeName(commits.first));
          } else {
            for (var commit in commits) {
              if (commit.parent == null) continue;
              context.printToConsole(
                  "${nodeName(commit.parent!)} -up-> ${nodeName(commit)}");
            }
          }
          List<String> gitLines(_Commit commit) => [
                "stax commit -a --accept-all ${name(commit)}",
                ...commit.children.expand((element) => [
                      ...gitLines(element),
                      "git checkout ${name(commit)}",
                    ])
              ];
          context.printToConsole("note bottom of ${nodeName(commits.first)}");
          String previousValue = "";
          bool haveSeenNonCheckout = false;
          gitLines(commits.first)
              .reversed
              .whereIndexed((index, element) {
                if (haveSeenNonCheckout) return true;
                if (!element.startsWith("git checkout")) {
                  return haveSeenNonCheckout = true;
                }
                return false;
              })
              .where((element) {
                final result = !(previousValue.startsWith("git checkout") &&
                    element.startsWith("git checkout"));
                previousValue = element;
                return result;
              })
              .toList()
              .reversed
              .forEach((element) {
                context.printToConsole(element);
              });
          context.printToConsole("end note");
        }
      }
    }

    List<List<_Commit>> next() {
      _Commit.nextId++;
      return commitsSet
          .expand((commits) => commits.mapIndexed(
              (index, element) => [...commits, element.newChildCommit()]))
          .toList();
    }

    context.printToConsole("@startuml");
    int prefix = 1;
    printUml(prefix++);
    commitsSet = next();
    printUml(prefix++);
    commitsSet = next();
    printUml(prefix++);
    commitsSet = next();
    printUml(prefix++);
    context.printToConsole("@enduml");
  }
}
