import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:firebase_database/firebase_database.dart';



class API {
  final String url = 'https://www.scenickazatva.eu/2021';
  final String url2 = 'https://db.panakrala.sk/zatva';
  final String selectedArrangement = '5e19cdd924cfa04fc3de1d3a';

  Future<String> getRestSrc(src) async{

    String festival = "scenickazatva2022";
    DatabaseReference optionsdb = FirebaseDatabase.instance.ref(
        "festivals/$festival/options");
    final options = await optionsdb.get();
    if (options.exists) {
      final result = (options.value as Map)[src]; // https://github.com/firebase/flutterfire/issues/7945#issuecomment-1065871088
      return result;
    } else {
      print('no data;');
      return null;
    }


    /*  Stream<DatabaseEvent> streamopts = optionsdb.onValue;
    streamopts.listen((DatabaseEvent option) {
      print(option.snapshot.value?.news_src);
    });*/

  }

/*  Future<List<Post>> fetchPosts() async {
    final wp = WordPressAPI('wp-site.com');
    final WPResponse res = await wp.posts.fetch();
    for (final post in res.data as List<Post>) {
      print(WPUtils.parseHtml(post.content));
    }
    return res.data as List<Post>;
  }*/

  Future<http.Response> fetchArrangements() {
    var result = http.get(Uri.parse(url2 + '/events.json'),
        headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }




  Future<String> fetchNews(page) async {
    try {
      /*var _url = url +
          '/wp-json/wp/v2/posts?per_page=100&order=desc&categories_exclude=18,19,20&_embed&page=' +
          page.toString();*/
      var _url = await getRestSrc("news_src");
      _url = _url.toString()+page.toString();
      var file = await DefaultCacheManager().getSingleFile(_url);

      if (file != null && await file.exists()) {
        final text = await file.readAsString();
        return text;
      }
      return "[]";
    }
    catch (e) {
      return "[]";
    }
  }
  Future<String> fetchMagazine(page) async {
    try {
      /*var _url = url +
          '/wp-json/wp/v2/posts?per_page=100&order=desc&_embed&categories=18,19,20&page=' +
          page.toString();*/
      var _url = await getRestSrc("magazine_src");
      _url = _url.toString()+page.toString();
      var file = await DefaultCacheManager().getSingleFile(_url);

      if (file != null && await file.exists()) {
        final text = await file.readAsString();
        return text;
      }
      print("File is null");
      return "[]";
    }
    catch (e){
      print(e);
      return "[]";
    }
  }

  /*Future<http.Response> fetchEventsForArrangement(arrangement) {
    var result = http.get(Uri.parse(url2 + '/events.json?arrangement=$selectedArrangement'), headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }*/

  /*Future<http.Response> fetchAllEvents() async {
    var result = await http.get(Uri.parse(url2 + '/events.json'), headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }

  Future<http.Response> fetchInfo() {
    var result = http.get(Uri.parse(url2 + '/info.json'), headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }*/

}
