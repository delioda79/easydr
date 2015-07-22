part of easydr;

class EDApp {
  int _port;
  EDDI _di;
  Map urls = {};

  EDApp([int port = 4046]) {
    this._port = port;
    _di = new EDDI();

    _di.createBucket('templates');
    _di.createBucket('controllers');
    _di.createBucket('models');
  }

  EDDI getDI() {
    return _di;
  }

  void addTemplate(String key, EDTemplate template) {
    _di.add('templates', key, template);
  }

  void addController(String controllerKey, Object controllerClass) {
    var controllerM = reflectClass(controllerClass);
    controllerM.declarations.forEach((key, method) {
      var urlObj = {};
      method.metadata.forEach((annot) {
        if(annot.type.reflectedType.toString() == 'EDRoute') {
          urlObj["controller"] = controllerKey;
          urlObj["method"] = key;
          urls[annot.reflectee] = urlObj;
        }

        if(annot.type.reflectedType.toString() == 'EDSelectedTemplate') {
          urlObj["template"] = annot.reflectee;
        }
      });
    });
    _di.add('controllers', controllerKey, reflect(controllerM.newInstance(new Symbol(''),[]).reflectee));
    _di.getBucket('controllers');
  }

  start() async {

    var serverRequests = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, this._port);
    await for (var request in serverRequests) {
      request.response.headers.contentType = ContentType.HTML;

      EDRoute match = null;

      for (var route in urls.keys) {
        if (route.getPattern().hasMatch(request.uri.toString())) {
          match = route;
          break;
        }
      }

      if (/*urls.containsKey(request.uri.toString())*/ match != null) {
        //Map action = urls[request.uri.toString()];
        Map action = urls[match];
        var controller = _di.getBucket('controllers')[action['controller']];
        Map arguments = {};
        match.getNamed().forEach((key, value) {
          arguments[new Symbol(key)] = match.getPattern().firstMatch(request.uri.toString()).group(value);
        });

        Map data = controller.invoke(action['method'], match.getPositional(),  arguments).reflectee;
        String result;
        if (action.containsKey('template')) {
          result = _di.getBucket('templates')[action['template'].toString()].parse(data);
        } else {
          result = data.toString();
        }
        request.response..write(result)
        ..close();
      } else {
        request.response
          ..write('UNKNOWN')
          ..close();
      }
    }
  }
}

