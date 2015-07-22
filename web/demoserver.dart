import 'package:easydr/easydr.dart';

class MyFirstController {

  @EDRoute(r'(/pippo/)([0-9]+)(/){0,1}$', const [] ,const {'id': 2})
  @EDSelectedTemplate('first')
  Map pippo({id: 0}) {
    return {
      'myVar': 1,
      'tests': ['a', 'b', 'c'],
      'myVar2': {'a' : 5, 'b': {'c': 'subObject'}},
      'myVar3': ['x','z', 'y'],
      'myVar4': ['TEST',{'b' : 'test'}, ['subA', 'subB']],
      'myVar5':  id
    };
  }

  @EDRoute('/message1')
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