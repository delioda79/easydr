import 'package:easydr/easydr.dart';

class MyFirstController {

  @EDURI('/pippo')
  @EDSelectedTemplate('first')
  Map pippo() {
    return {
      'myVar': 1,
      'tests': ['a', 'b', 'c'],
      'myVar2': {'a' : 5, 'b': {'c': 'subObject'}},
      'myVar3': ['x','z', 'y'],
      'myVar4': ['TEST',{'b' : 'test'}, ['subA', 'subB']],
      'myVar5':  5
    };
  }

  @EDURI('/message1')
  String myMessage() {
    return 'Hello, I\'m just returning a string';
  }
}

main() async {

  var myTemplate = new EDTemplate('./TestTemplate.html');

  EDApp anApp = new EDApp();
  anApp.addTemplate('first', myTemplate);
  anApp.addController('first', MyFirstController);

  anApp.start();
}