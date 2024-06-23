import 'dart:math';

import 'package:collection/collection.dart';
import 'package:stax/log/decorated/decorated_log_line_producer.dart';

class CommitTreeForTestCases implements DecoratedLogLineProducerAdapter<int> {
  static final _alphabet =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  static const initialCommitId = 0;

  final List<int> indexes;
  final int mainId;
  final int currentId;
  late String compacted = indexes.map((e) => _alphabet[e]).join();

  CommitTreeForTestCases([
    this.indexes = const [],
    this.mainId = 0,
    this.currentId = 0,
  ]);

  int get length => indexes.length;

  CommitTreeForTestCases next() {
    if (isTimeToLengthen()) {
      return lengthenAndReset();
    }
    if (currentId != length) {
      return CommitTreeForTestCases(indexes, mainId, currentId + 1);
    }
    if (mainId != length) {
      return CommitTreeForTestCases(indexes, mainId + 1, 0);
    }
    final newIndexes = [...indexes];
    for (int i = newIndexes.length - 1; i >= 0; i--) {
      if (newIndexes[i] != i) {
        newIndexes[i]++;
        break;
      } else {
        newIndexes[i] = 0;
      }
    }
    return CommitTreeForTestCases(newIndexes, 0, 0);
  }

  bool isTimeToLengthen() {
    if (currentId != length) return false;
    if (mainId != length) return false;
    for (int i = 0; i < length; i++) {
      if (indexes[i] != i) return false;
    }
    return true;
  }

  CommitTreeForTestCases lengthenAndReset() {
    return CommitTreeForTestCases(List.filled(length + 1, 0), 0, 0);
  }

  CommitTreeForTestCases subIndexes(int end) {
    if (end < 0) return this;
    final biggestId = end + 1;
    int newId(int currentId) {
      while (currentId >= biggestId) {
        currentId = indexes[currentId - 1];
      }
      return currentId;
    }

    return CommitTreeForTestCases(
      indexes.sublist(0, end),
      newId(mainId),
      newId(currentId),
    );
  }

  List<CommitTreeForTestCases> allSubIndexes() {
    final result = <CommitTreeForTestCases>[];
    for (int i = 0; i <= length; i++) {
      result.add(subIndexes(i));
    }
    return result;
  }

  factory CommitTreeForTestCases.fromCompacted(
      String compactedWithMainAndCurrentIds) {
    final indexes = <int>[];
    final parts = compactedWithMainAndCurrentIds.split("_");
    final compacted = parts.first;
    for (int i = 0; i < compacted.length; i++) {
      final char = compacted[i];
      final index = _alphabet.indexOf(char);
      if (index == -1) {
        throw Exception("'$char' is not in base64 alphabet '$_alphabet'");
      }
      indexes.add(index);
    }
    final mainId = int.tryParse(parts.elementAtOrNull(1) ?? "") ?? 0;
    final currentId = int.tryParse(parts.elementAtOrNull(2) ?? "") ?? 0;
    return CommitTreeForTestCases(indexes, mainId, currentId);
  }

  factory CommitTreeForTestCases.random(int length,
      [int? mainId, int? currentId]) {
    final random = Random();
    final indexes = <int>[];
    for (int i = 0; i < length; i++) {
      indexes.add(random.nextInt(i + 1));
    }
    return CommitTreeForTestCases(indexes, mainId ?? random.nextInt(length),
        currentId ?? random.nextInt(length));
  }

  String toUmlString() {
    String result = "";
    void addToResult(String string) {
      result += "$string\n";
    }

    String nodeName(int id) => "(${commitName(id)})";
    if (length == 0) {
      addToResult(nodeName(initialCommitId));
    } else {
      indexes.forEachIndexed((index, element) {
        addToResult("${nodeName(element)} -up-> ${nodeName(index + 1)}");
      });
    }
    addToResult("note bottom of ${nodeName(initialCommitId)}");
    getTargetCommands().forEach(addToResult);
    getTargetOutput().forEach((element) => addToResult("\"\"$element\"\""));
    addToResult("end note");
    return result.trim();
  }

  List<String> getTargetCommands() {
    String previousValue = "";
    bool haveSeenNonCheckout = false;
    List<String> gitLines(int id) => [
          "echo '${commitName(id)}' > ${commitName(id)}",
          "stax commit -a --accept-all ${commitName(id)}",
          ..._children(id).expand((element) => [
                ...gitLines(element),
                "git checkout ${commitName(id)}",
              ])
        ];

    return ["git init"]
        .followedBy(gitLines(initialCommitId)
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
            .followedBy(["git checkout ${commitName(currentId)}"]))
        .toList();
  }

  List<String> getTargetOutput() {
    return materializeDecoratedLogLines(initialCommitId, this);
  }

  @override
  String toString() {
    return "mainId:$mainId currentId:$currentId indexes:$indexes compacted:$compacted";
  }

  String compactedWithMainAndCurrentId() {
    return "${compacted}_${mainId}_$currentId";
  }

  String commitName(int commitId) {
    return "${compactedWithMainAndCurrentId()}_$commitId";
  }

  @override
  String branchName(int id) {
    final rawName = commitName(id);
    final name = " $rawName ";
    if (isDefaultBranch(id)) {
      return name;
    }
    if (isDefaultBranchOrHasDefaultBranchAsAChild(id)) {
      return "[$rawName]";
    }
    return name;
  }

  bool isDefaultBranchOrHasDefaultBranchAsAChild(int id) {
    return isDefaultBranch(id) ||
        _children(id).any(
            (element) => isDefaultBranchOrHasDefaultBranchAsAChild(element));
  }

  int sortingValue(int id) {
    return isDefaultBranchOrHasDefaultBranchAsAChild(id) ? 10000 : id;
  }

  int collapsedChild(int id) {
    if (isCurrent(id)) return id;
    if (isDefaultBranch(id)) return id;
    if (_children(id).length != 1) return id;
    if (!isDefaultBranchOrHasDefaultBranchAsAChild(id)) return id;
    return collapsedChild(_children(id).single);
  }

  List<int> _children(int id) {
    return indexes
        .expandIndexed<int>(
            (index, element) => element == id ? [index + 1] : [])
        .toList();
  }

  @override
  List<int> children(int id) {
    return _children(id)
        .map(collapsedChild)
        .sorted((a, b) => sortingValue(b) - sortingValue(a));
  }

  @override
  bool isDefaultBranch(int id) {
    return id == mainId;
  }

  @override
  bool isCurrent(int id) {
    return id == currentId;
  }
}
