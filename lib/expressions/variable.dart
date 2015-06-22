part of easydr;

class _EDVariable implements _EDExpressionType{
  String name;
  _EDVariable(this.name);

  String parse(Map data) {
    if (!data.containsKey(name)) {
      throw 'Variable ' + name + ' has not be provided';
    }
    return data[name].toString();
  }

}