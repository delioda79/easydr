part of easydr;

class _EDVariable implements _EDExpressionType{
  String name;
  _EDVariable(this.name);

  String parse(Map data) {
    String key;
    int keyLength = name.indexOf(new RegExp(r'(\.|\[)'));
    if (keyLength >= 0) {
      key = name.substring(0, keyLength);
    } else {
      key = name;
    }
    print(data);
    if (!data.containsKey(key)) {
      throw 'Variable ' + name + ' has not be provided';
    }
    if (keyLength >= 0) {
      if (data[key] is Map) {
        return _getFromMap(name.substring(keyLength), data[key]);
      }

      if (data[key] is List) {
        return _getFromArray(name.substring(keyLength), data[key]);
      }
    }
    return data[name].toString();
  }

  String _getFromMap(String value, Map data) {
    if (value[0] != '.') {
      throw 'Expected an object property';
    }
    _EDVariable subKey = new _EDVariable(value.substring(1));
    return subKey.parse(data);
  }


  String _getFromArray(String value, List data) {
    if (value[0] != '[') {
      throw 'Expected an array key';
    }
    int idx = int.parse(value.substring(1,value.indexOf(']')), onError: (source) => -1);

    if (idx == -1) {
      throw 'Expected an integer, found' + value.substring(1,value.indexOf(']'));
    }

    if (data.length <= idx) {
      throw 'The index ' + idx.toString() + ' is out of range';
    }

    if(value.indexOf(']') == (value.length-1)) {
      return data[idx].toString();
    }

    int cursor = value.indexOf(']')+1;
    if (value[cursor] == '.') {
      cursor++;
    }
    _EDVariable subKey = new _EDVariable(value.substring(cursor));
    return subKey.parse(data[idx]);
  }

}