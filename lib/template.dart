part of easydr;

class EDTemplate {
  List<String> blocks = [];
  Map<int, String> mapping = {};

  EDTemplate(String location) {
    File file = new File(location);
    String content = file.readAsStringSync();
    _build(content);
  }

  EDTemplate.fromString(String content) {
    _build(content);
  }

  String parse(Map data) {
    String parsed = '';
    for(String s in blocks) {
      if (mapping.containsKey(blocks.indexOf(s))) {
        parsed += mapping[blocks.indexOf(s)].parse(data);
      } else {


        parsed += blocks[blocks.indexOf(s)];
      }
    }
    return parsed;
  }

  void _build(content) {
    if (content.length <= 0) {
      return;
    }
    int cursor = 0;
    int tVarIdx = content.indexOf('{%', cursor);
    blocks.add(content.substring(cursor, (tVarIdx >= 0) ? tVarIdx : content.length));
    if (tVarIdx < content.length && tVarIdx >= 0) {
      cursor = content.indexOf('%}', tVarIdx)+1;
      var key = content.substring(tVarIdx+2, cursor-1);
      blocks.add('{%' + key + '%}');
      mapping[blocks.length -1] = new _EDExpression(key, content.substring(cursor+1));
      _build(content.substring(cursor + mapping[blocks.length -1].getCursor()));
    }
  }
}