part of easydr.template;

class EndBlockException implements Exception {
  final String text;
  final int cursor;

  const EndBlockException(this.text, this.cursor);

  String toString() => 'EndBlockException: found end of block $text but no start of block found';

  int getCursor() => cursor;
  int getText() => text;
}