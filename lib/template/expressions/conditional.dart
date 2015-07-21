part of easydr;

class _EDConditional implements _EDExpressionType {
  String key;
  String value;
  String compareOp;
  EDTemplateBlock template;
  int cursor;
  static List comparisons = ['=', '>', '<', '<=', '>=', '!='];

  _EDConditional(List expr, String body) {

    this.key = expr[1];
    this.compareOp = expr[2];
    this.value = expr[3];
    cursor = 0;
    this.template = new EDTemplateBlock.fromString(body);
    cursor = this.template.getLatItemPosition();
    if (cursor < body.length) {
      this.template = new EDTemplateBlock.fromString(body.substring(0, cursor));
    }

    int end = body.substring(cursor).indexOf(new RegExp(r'{%\s*endif\s*%}')) + cursor;
    if (end != cursor) {
      throw 'No end of Condition';
    }

    cursor = end + body.substring(end).indexOf('}') + 1;

  }

  static bool check(List expr) {
    return expr[0] == 'if' && checkComparable(expr[2]);
  }

  static bool checkComparable(String operator) {
    return comparisons.contains(operator);
  }

  String parse(Map data) {
    var compareValueExpr = new _EDVariable([value], '');
    var compareValue = compareValueExpr.parse(data);

    bool displayIt = false;

    var compareKeyExpr = new _EDVariable([key], '');
    var compareKey = compareKeyExpr.parse(data);

    switch (compareOp) {
      case '=':
        displayIt = compareKey == compareValue;
      break;
      case '<':
        displayIt = compareKey < compareValue;
      break;
      case '>':
        displayIt = compareKey > compareValue;
      break;
      case '<=':
        displayIt = compareKey <= compareValue;
      break;
      case '>=':
        displayIt = compareKey >= compareValue;
      break;
      case '!=':
        displayIt = compareKey != compareValue;
      break;

    }

    String result = (displayIt) ? template.parse(data) : '';

    return result;
  }

  int getCursor() {
    return cursor;
  }
}