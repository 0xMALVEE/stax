import 'package:stax/context/context.dart';
import 'package:test/test.dart';

void main() {
  test('implicit', () {
    final context = Context.implicit();
    expect(context.silent, false);
    expect(context.workingDirectory, null);
  });
  test('explicit', () {
    final context = Context(true, "directory");
    expect(context.silent, true);
    expect(context.workingDirectory, "directory");
  });
  test('implicit not changing withSilence', () {
    final context = Context.implicit();
    Context modifiedContext = context.withSilence(false);
    expect(context, (c) => identical(c, modifiedContext));
  });
  test('implicit not changing withWorkingDirectory', () {
    final context = Context.implicit();
    Context modifiedContext = context.withWorkingDirectory(null);
    expect(context, (c) => identical(c, modifiedContext));
  });
  test('explicit not changing withSilence', () {
    final context = Context(true, "directory");
    Context modifiedContext = context.withSilence(true);
    expect(context, (c) => identical(c, modifiedContext));
  });
  test('explicit not changing withWorkingDirectory', () {
    final context = Context(true, "directory");
    Context modifiedContext = context.withWorkingDirectory("directory");
    expect(context, (c) => identical(c, modifiedContext));
  });
  test('implicit changing withSilence', () {
    final context = Context.implicit();
    Context modifiedContext = context.withSilence(true);
    expect(context, (c) => !identical(c, modifiedContext));
    expect(context.silent, false);
    expect(modifiedContext.silent, true);
  });
  test('implicit changing withWorkingDirectory', () {
    final context = Context.implicit();
    Context modifiedContext = context.withWorkingDirectory("directory");
    expect(context, (c) => !identical(c, modifiedContext));
    expect(context.workingDirectory, null);
    expect(modifiedContext.workingDirectory, "directory");
  });
  test('explicit changing withSilence', () {
    final context = Context(true, "directory");
    Context modifiedContext = context.withSilence(false);
    expect(context, (c) => !identical(c, modifiedContext));
    expect(context.silent, true);
    expect(modifiedContext.silent, false);
  });
  test('explicit changing withWorkingDirectory', () {
    final context = Context(true, "directory");
    Context modifiedContext = context.withWorkingDirectory(null);
    expect(context, (c) => !identical(c, modifiedContext));
    expect(context.workingDirectory, "directory");
    expect(modifiedContext.workingDirectory, null);
  });
}