part of easydr;

class EDApp {
  int _port;
  EDDI _di;

  EDApp([int port = 4046]) {
    this._port = port;
    _di = new EDDI();

    _di.createBucket('templates');
    _di.createBucket('controllers');
    _di.createBucket('models');
  }

  void getDI() {
    return _di;
  }

  void addTemplate(String key, EDTemplate template) {
    _di.add('templates', key, template);
  }

  void start() async {

    var serverRequests = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, this._port);
    await for (var request in serverRequests) {
      request.response.headers.contentType = 'text/html';
      request.response
        ..write(_di.getBucket('templates')['first'].parse({
          'myVar': 1,
          'tests': ['a', 'b', 'c'],
          'myVar2': {'a' : 5, 'b': {'c': 'subObject'}},
          'myVar3': ['x','z', 'y'],
          'myVar4': [request.uri,{'b' : 'test'}, ['subA', 'subB']],
          'myVar5':  5
        }))
        ..close();
    }
  }
}

