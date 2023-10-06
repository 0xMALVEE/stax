import 'package:stax/log/parsed_log_line.dart';
import 'package:test/test.dart';

void main() {
  test('      + [c3b3d18] ggg', () {
    final line = ParsedLogLine.parse("      + [c3b3d18] ggg");
    expect(line.pattern, "      +");
    expect(line.commitHash, "c3b3d18");
    expect(line.commitMessage, "ggg");
  });
  test('      + [f59daac] g', () {
    final line = ParsedLogLine.parse("      + [f59daac] g");
    expect(line.pattern, "      +");
    expect(line.commitHash, "f59daac");
    expect(line.commitMessage, "g");
  });
  test('     ++ [7bc6c72] f', () {
    final line = ParsedLogLine.parse("     ++ [7bc6c72] f");
    expect(line.pattern, "     ++");
    expect(line.commitHash, "7bc6c72");
    expect(line.commitMessage, "f");
  });
  test('    +++ [600b013] e', () {
    final line = ParsedLogLine.parse("    +++ [600b013] e");
    expect(line.pattern, "    +++");
    expect(line.commitHash, "600b013");
    expect(line.commitMessage, "e");
  });
  test('   +    [7d220a8] d', () {
    final line = ParsedLogLine.parse("   +    [7d220a8] d");
    expect(line.pattern, "   +   ");
    expect(line.commitHash, "7d220a8");
    expect(line.commitMessage, "d");
  });
  test('  +++++ [d0b4d6c] c', () {
    final line = ParsedLogLine.parse("  +++++ [d0b4d6c] c");
    expect(line.pattern, "  +++++");
    expect(line.commitHash, "d0b4d6c");
    expect(line.commitMessage, "c");
  });
  test(' ++++++ [5681909] b', () {
    final line = ParsedLogLine.parse(" ++++++ [5681909] b");
    expect(line.pattern, " ++++++");
    expect(line.commitHash, "5681909");
    expect(line.commitMessage, "b");
  });
  test('+++++++ [363497b] a', () {
    final line = ParsedLogLine.parse("+++++++ [363497b] a");
    expect(line.pattern, "+++++++");
    expect(line.commitHash, "363497b");
    expect(line.commitMessage, "a");
  });
}