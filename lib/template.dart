part of easydr;

class EDTemplate {
  int lastItemPosition = 0;
  List<String> blocks = [];
  Map<int, String> mapping = {};

  EDTemplate(String location) {
    File file = new File(location);
    String content = file.readAsStringSync();
    _build(content);
  }

  EDTemplate.fromString(String content) {
    lastItemPosition = content.length -1;
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

    int endBlock = content.indexOf(new RegExp(r'{%\s*end'));

    blocks.add(content.substring(cursor, (tVarIdx >= 0) ? tVarIdx : content.length));

    /**
     * The expression is an end of block, but no start of block exists
     */
    if (endBlock == tVarIdx && tVarIdx >= 0) {
      throw new EndBlockException(content.substring(tVarIdx, content.indexOf(new RegExp(r'%\s*}'))), endBlock);
    }

    if (tVarIdx < content.length && tVarIdx >= 0) {
      cursor = content.indexOf('%}', tVarIdx)+1;
      var key = content.substring(tVarIdx+2, cursor-1);
      blocks.add('{%' + key + '%}');

      _EDExpression currentBlock = new _EDExpression(key, content.substring(cursor+1));

      int currentBlockIdx = blocks.length -1;
      mapping[blocks.length -1] = currentBlock;
      try {
        _build(content.substring(cursor + mapping[blocks.length -1].getCursor()));
      } on EndBlockException catch(e) {
        int localCursor = e.getCursor() + cursor + mapping[currentBlockIdx].getCursor();
        throw new EndBlockException(e.getText(), localCursor);
      }
    }
  }

  int getLatItemPosition() {
    return lastItemPosition;
  }
}