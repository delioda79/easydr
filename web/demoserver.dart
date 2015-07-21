import 'package:easydr/easydr.dart';

main() async {

  var myTemplate = new EDTemplate('./TestTemplate.html');

  EDApp anApp = new EDApp();
  anApp.addTemplate('first', myTemplate);

  anApp.start();
}