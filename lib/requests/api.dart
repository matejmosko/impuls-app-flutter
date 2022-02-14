import 'package:http/http.dart' as http;

class API {
  final String url = 'https://www.scenickazatva.eu/2021';
  final String url2 = 'https://db.panakrala.sk/zatva';
  final String selectedArrangement = '5e19cdd924cfa04fc3de1d3a';

  Future<http.Response> fetchArrangements() {
    var result = http.get(Uri.parse(url + '/arrangements'), headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }

  Future<http.Response> fetchNews() {
    var result = http.get(Uri.parse(url + '/wp-json/wp/v2/posts?order=asc&_embed'), headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }

  Future<http.Response> fetchEventsForArrangement(arrangement) {
    var result = http.get(Uri.parse(url + '/events?arrangement=$selectedArrangement'), headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }

  Future<http.Response> fetchAllEvents() {
    var result = http.get(Uri.parse(url2 + '/events.json'), headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }

  Future<http.Response> fetchInfo() {
    var result = http.get(Uri.parse(url + '/info'), headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }
}
