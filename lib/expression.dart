part of easydr;

class _EDExpression {
  List exprPts;
  int cursor;
  List expressions = [_EDVariable, _EDLoop, _EDConditional];

  _EDExpressionType expression;

  _EDExpression(String expr, String body) {
    //RegExp pattern =  new RegExp(r'"[^"]+"|[^\s]+');
    RegExp pattern =  new RegExp('\'[^\']+\'|"[^"]+"|[^\\s]+');
    exprPts = pattern.allMatches(expr.trim()).fold([], (prev, element) {
      prev.add(element.group(0));
      return prev;
    });

    cursor = 0;
    _build(body);
  }

  void _build(String body) {

    Iterator i = expressions.iterator;
    bool found = false;
    while (i.moveNext()) {
      var reflected = reflectClass(i.current);
      if (reflected.invoke(#check, [exprPts]).reflectee ) {
        expression = reflected.newInstance(new Symbol(''),[exprPts, body]).reflectee;
        cursor = expression.getCursor();
        found = true;
        break;
      }
    }

    if (!found) {
      //print(trimmed);
    }
  }

  int getCursor() {
    return cursor + 1;
  }

  String parse(Map data) {
    return expression.parse(data);
  }
}