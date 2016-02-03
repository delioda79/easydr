import 'package:easydr/easydr.dart';
import 'demoserver/myFirstController.dart';
import 'demoserver/JsController.dart';
import 'package:path/path.dart';
import 'dart:io';

main() async {

  //var myTemplate = new EDTemplate('./TestTemplate.html');

  EDApp anApp = new EDApp();
  //anApp.addTemplate('default', myTemplate);
  anApp.addController('TestController', MyFirstController);
  anApp.addController('JsScripts', JsController);
  //anApp.addController('StaticFiles', StaticController);
  anApp.addStatics('css', join(dirname(Platform.script.toFilePath()), 'demoserver/css'));
  anApp.start();
}