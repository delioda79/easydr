part of easydr;

class StaticController {

  String serveFiles({String location: '', String fileName: ''}) {
    //Platform.script.toFilePath()
    location.replaceAll('../', '');
    var pathToBuild = join(/*dirname(Platform.script.toFilePath()), */location, fileName.split('/').join(separator));
    print("Path: " + pathToBuild);
    print("Location: " + location);
    print("Filename: " + fileName);
    print("Dirname: " + dirname(Platform.script.toFilePath()));

    try {
      var file = new File(pathToBuild);
      String content = file.readAsStringSync();
      return content;
    } on FileSystemException catch (exc) {
      return 'File: ' + location + ' does not exist';
    }

  }
}