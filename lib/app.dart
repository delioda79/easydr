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
    this.addController('Static', StaticController);
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
      urlObj["controller"] = controllerKey;
      urlObj["method"] = key;
      var regex = '';
      method.metadata.forEach((annot) {
        if (annot.type.reflectedType.toString() == 'EDRoute') {
          regex = annot.reflectee;
          //@toDo seems able to handle multiple routes declaration
          if (!urls.containsKey(regex)) {
            urls[regex] = {};
          }
        }

        if (annot.type.reflectedType.toString() == 'EDSelectedTemplate') {
          urlObj["template"] = annot.reflectee;
        }

        if (annot.type.reflectedType.toString() == 'EDSelectedTemplatePath') {
          var myTemplate = new EDTemplate(dirname(Platform.script.toFilePath()) + '/' + annot.reflectee.toString());
          addTemplate(annot.reflectee.toString(), myTemplate);
          urlObj["template"] = annot.reflectee;
        }

        if (annot.type.reflectedType.toString() == 'EDGET') {
          urls[regex]['GET'] = urlObj;
        }

        if (annot.type.reflectedType.toString() == 'EDPOST') {
          urls[regex]['POST'] = urlObj;
        }

        if (annot.type.reflectedType.toString() == 'EDPUT') {
          urls[regex]['PUT'] = urlObj;
        }

        if (annot.type.reflectedType.toString() == 'EDDELETE') {
          urls[regex]['DELETE'] = urlObj;
        }
      });
    });
    _di.add('controllers', controllerKey,
        reflect(controllerM.newInstance(new Symbol(''), []).reflectee));
    _di.getBucket('controllers');
  }

  void addStatics(String name, String location) {
    String pattern = '(/' + name + r'/)(.*)(/){0,1}$';
    EDRoute route = new EDRoute(pattern, const [] ,const {'fileName': 2});
    var urlObj = {};
    urlObj["controller"] = 'Static';
    urlObj["method"] = new Symbol('serveFiles');
    urlObj["params"] = {"location": location};
    urls[route] = {
      'GET': urlObj
    };
  }

  start() async {
    var serverRequests =
        await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, this._port);
    await for (var request in serverRequests) {
      request.response.headers.contentType = ContentType.HTML;
      var data = await request.toSet();

      data.forEach((val) {
        String toPrint = new String.fromCharCodes(val);
        print(toPrint);
      });

      EDRoute match = null;

      for (var route in urls.keys) {
        if (route.getPattern().hasMatch(request.uri.toString())) {
          if (urls[route].containsKey(request.method)) {
            match = route;
          }
          break;
        }
      }

      if (/*urls.containsKey(request.uri.toString())*/ match != null) {
        //Map action = urls[request.uri.toString()];
        Map action = urls[match][request.method];
        var controller = _di.getBucket('controllers')[action['controller']];
        Map arguments = {};
        match.getNamed().forEach((key, value) {
          arguments[new Symbol(key)] = match
              .getPattern()
              .firstMatch(request.uri.toString())
              .group(value);
        });

        if (action.containsKey('params')) {
          action['params'].forEach((key, value) {
            arguments[new Symbol(key)] = value;
          });
        }

        Map data = controller.invoke(
            action['method'], match.getPositional(), arguments).reflectee;
        String result;
        if (action.containsKey('template')) {
          result = _di.getBucket('templates')[action['template'].toString()]
              .parse(data);
        } else {
          result = data.toString();
        }
        request.response
          ..write(result)
          ..close();
      } else {
        request.response
          ..write('UNKNOWN')
          ..close();
      }
    }
  }
}
