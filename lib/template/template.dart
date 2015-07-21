part of easydr.template;

class EDTemplate {
  EDTemplateBlock _block;

  EDTemplate(String location) {
    _block = new EDTemplateBlock(location);
    if (_block.getLatItemPosition() < _block.getContentLength()) {
      File file = new File(location);
      String content = file.readAsStringSync();
      throw new EndBlockException('Extra content: "' + content.substring(_block.getLatItemPosition()) + '"', _block.getLatItemPosition());
    }
  }

  EDTemplate.fromString(String content) {
    _block = new EDTemplateBlock.fromString(content);
    throw new EndBlockException('Extra content: "' + content.substring(_block.getLatItemPosition()) + '"', _block.getLatItemPosition());
  }

  String parse(Map data) {
    return _block.parse(data);
  }
}