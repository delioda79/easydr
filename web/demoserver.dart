import 'package:easydr/easydr.dart';
import 'demoserver/myFirstController.dart';
import 'demoserver/JsController.dart';

main() async {

  //var myTemplate = new EDTemplate('./TestTemplate.html');

  EDApp anApp = new EDApp();
  //anApp.addTemplate('default', myTemplate);
  anApp.addController('TestController', MyFirstController);
  anApp.addController('JsScripts', JsController);

  anApp.start();
}