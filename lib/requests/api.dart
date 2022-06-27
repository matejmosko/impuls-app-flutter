import 'package:http/http.dart' as http;


class API {
  final String url = 'https://www.scenickazatva.eu/2021';
  final String url2 = 'https://db.panakrala.sk/zatva';
  final String selectedArrangement = '5e19cdd924cfa04fc3de1d3a';

  Future<http.Response> fetchArrangements() {
    var result = http.get(Uri.parse(url2 + '/events.json'), headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }

  Future<http.Response> fetchNews(page) {
    var result = http.get(Uri.parse(url + '/wp-json/wp/v2/posts?order=desc&categories_exclude=18,19,20&_embed&page='+page.toString()), headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }

  Future<http.Response> fetchMagazine(page) {
    var result = http.get(Uri.parse(url + '/wp-json/wp/v2/posts?order=desc&_embed&categories=18,19,20&page='+page.toString()), headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }

  Future<http.Response> fetchEventsForArrangement(arrangement) {
    var result = http.get(Uri.parse(url2 + '/events.json?arrangement=$selectedArrangement'), headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }

  Future<http.Response> fetchAllEvents() async {
    var result = await http.get(Uri.parse(url2 + '/events.json'), headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }

  Future<http.Response> fetchInfo() {
    var result = http.get(Uri.parse(url2 + '/info.json'), headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }
}
