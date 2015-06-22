part of easydr;

class _EDExpression {
  String trimmed;
  int cursor;

  _EDExpressionType expression;

  _EDExpression(String expr, String body) {
    trimmed = expr.trim().replaceAll(new RegExp(r'\s+'), ' ');
    cursor = 0;
    _build(body);
  }

  void _build(String body) {
    String keys = trimmed.split(' ');
    if (keys.length == 1) {
      expression = new _EDVariable(keys[0]);
    } else {
      if (keys[0] == 'for' && keys[2] == 'in') {
        int end = body.lastIndexOf(new RegExp(r'{%\s*endfor\s*%}'));
        if (end < 0) {
          throw new Exception('No end of Loop');
        }
        cursor = end + body.substring(end).indexOf('}') + 1;
        expression = new _EDLoop(keys[1], keys[3], body.substring(0, end ));
      }
    }
  }

  int getCursor() {
    return cursor + 1;
  }

  String parse(Map data) {
    return expression.parse(data);
  }
}