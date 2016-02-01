import 'package:easydr/easydr.dart';
import 'package:http_server/http_server.dart';
import 'package:path/path.dart';
import 'dart:io';

class StaticController {

  @EDRoute(r'(/css/)(.*)(/){0,1}$', const [] ,const {'location': 2})
  String cssFiles({String location: ''}) {
    location.replaceAll('../', '');
    var pathToBuild = join(dirname(Platform.script.toFilePath()), location.split('/').join(separator));
    print(pathToBuild);
    print(Platform.script.toFilePath());

    try {
      var file = new File(pathToBuild);
      String content = file.readAsStringSync();
      return content;
    } on FileSystemException catch (exc) {
      return 'File: ' + location + ' does not exist';
    }

  }
}