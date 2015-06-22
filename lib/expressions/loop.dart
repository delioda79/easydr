part of easydr;

class _EDLoop implements _EDExpressionType {
  String key;
  String setKey;
  EDTemplate template;

  _EDLoop(String key, String setKey, String body) {
    this.key = key;
    this.setKey = setKey;
    this.template = new EDTemplate.fromString(body);
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
}