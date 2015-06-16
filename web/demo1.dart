import 'package:easydr/easydr.dart';

main() async {

  var myTemplate = new EDTemplate('./TestTemplate.html');
  print(myTemplate.parse({'myVar': 1}));
}