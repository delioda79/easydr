import 'package:easydr/easydr.dart';

main() async {
  
  var myTemplate = new Template('./TestTemplate.html');
  print(myTemplate.parse({'myVar': 1}));
}