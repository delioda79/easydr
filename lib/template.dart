part of easydr;

class Template {
  List<String> blocks = [];
  Map<Int, String> mapping = {};

  Template(String location) {
    File file = new File(location);
    String content = file.readAsStringSync();
    _build(content);
  }

  Template.fromString(String content) {
    _build(content);
  }

  String parse(Map data) {
    String parsed = '';
    for(String s in blocks) {
      if (mapping.containsKey(blocks.indexOf(s))) {
        if (!data.containsKey(mapping[blocks.indexOf(s)])) {
          throw new Exception('No value provided for ' + mapping[blocks.indexOf(s)]);
        }
        parsed += data[mapping[blocks.indexOf(s)]].toString();
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
      var key = content.substring(tVarIdx+2, cursor-1).replaceAll(' ', '');
      blocks.add('{%' + key + '%}');
      mapping[blocks.length -1] = key;
      _build(content.substring(cursor+1));
    }
  }
}