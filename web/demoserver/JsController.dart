import 'package:easydr/easydr.dart';

class JsController {

  @EDRoute('/scripts/example.js')
  @EDSelectedTemplatePath('./demoserver/test.js')
  @EDGET()
  String myTemplatedMessage() {
  }
}