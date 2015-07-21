part of easydr;

class App {
  void start() async {

    var myTemplate = new EDTemplate('./TestTemplate.html');

    var serverRequests = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4046);
    await for (var request in serverRequests) {
      request.response.headers.contentType = 'text/html';
      request.response
        ..write('Your request: ')
        ..write(myTemplate.parse({
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

