part of easydr.template;

class _EDLoop implements _EDExpressionType {
  String key;
  String setKey;
  EDTemplateBlock template;
  int cursor;

  _EDLoop(List expr, String body) {

    this.key = expr[1];
    this.setKey = expr[3];
    cursor = 0;
    this.template = new EDTemplateBlock.fromString(body);
    cursor = this.template.getLatItemPosition();
    if (cursor < body.length) {
      this.template = new EDTemplateBlock.fromString(body.substring(0, cursor));
    }

    int end = body.substring(cursor).indexOf(new RegExp(r'{%\s*endfor\s*%}')) + cursor;
    if (end != cursor) {
      throw 'No end of Loop';
    }

    cursor = end + body.substring(end).indexOf('}') + 1;

  }

  static bool check(List expr) {
    return expr[0] == 'for' && expr[2] == 'in';
  }

  String parse(Map data) {
    if (!data.containsKey(setKey)) {
      throw 'Variable "' + setKey + '" has not be provided';
    }
    String result = '';
    Map iteratingVal = {};
    Map localVars;
    for(var el in data[setKey]) {
      iteratingVal[key] = el;
      localVars = new Map.from(data);
      localVars.addAll(iteratingVal);
      result += template.parse(localVars);
    }

    return result;
  }

  int getCursor() {
    return cursor;
  }
}