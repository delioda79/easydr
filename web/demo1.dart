import 'package:easydr/easydr.dart';

main() async {

  var myTemplate = new EDTemplate('./TestTemplate.html');
  print(myTemplate.parse({
    'myVar': 1,
    'tests': ['a', 'b', 'c'],
    'myVar2': {'a' : 5, 'b': {'c': 'subObject'}},
    'myVar3': ['x','z', 'y'],
    'myVar4': ['x',{'b' : 'test'}, ['subA', 'subB']],
    'myVar5':  5
  }));
}