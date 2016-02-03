import 'package:easydr/easydr.dart';

class MyFirstController {

  @EDRoute(r'(/pippo/)([0-9]+)(/){0,1}$', const [] ,const {'id': 2})
  @EDSelectedTemplatePath('./demoserver/DemoServerFirstCtrlTemplate.html')
  Map pippo({String id: 0}) {
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

  @EDRoute('/message2')
  @EDSelectedTemplatePath('./demoserver/plainMessage.html')
  String myTemplatedMessage() {
  }
}
