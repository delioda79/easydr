part of easydr;

class _EDExpression {
  String trimmed;
  _EDExpression(String expr) {
    trimmed = expr.trim().replaceAll('  ', ' ');
  }

  String parse(Map data) {
    String keys = trimmed.split(' ');
    if (keys.length == 1) {
      if (!data.containsKey(keys[0])) {
        throw new Excpetion('Variable ' + keys[0].toString() + ' has not be provided');
      }
      return data[keys[0]].toString();
    }
  }
}