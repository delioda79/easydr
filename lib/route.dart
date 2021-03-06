part of easydr;

class EDRoute {
  final String _pattern;
  final List _positional;
  final Map<String, Int> _named;
  const EDRoute(this._pattern, [List this._positional = const [],
      Map<String, Int> this._named = const {}]);

  RegExp getPattern() {
    return new RegExp(this._pattern);
  }

  List getPositional() {
    return this._positional;
  }

  Map<String, Int> getNamed() {
    return this._named;
  }
  String toString() => _pattern;
}
