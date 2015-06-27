part of easydr;

class _EDLoop implements _EDExpressionType {
  String key;
  String setKey;
  EDTemplate template;
  int cursor;

  _EDLoop(String key, String setKey, String body) {
    this.key = key;
    this.setKey = setKey;
    cursor = 0;
    try {
      this.template = new EDTemplate.fromString(body);
      cursor = this.template.getLatItemPosition();
    } on EndBlockException catch (e) {

      cursor = e.getCursor();
      this.template = new EDTemplate.fromString(body.substring(0, cursor));
    } finally {

      int end = body.substring(cursor).indexOf(new RegExp(r'{%\s*endfor\s*%}')) + cursor;
      if (end < 0) {
        throw 'No end of Loop';
      }

      cursor = end + body.substring(end).indexOf('}') + 1;
    }
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