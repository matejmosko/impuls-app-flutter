import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_analytics/firebase_analytics.dart'; // imported for firebase messaging to log events



class API {
  final String url = 'https://www.scenickazatva.eu/2021';
  final String url2 = 'https://db.panakrala.sk/zatva';
  final String selectedArrangement = '5e19cdd924cfa04fc3de1d3a';

  static const key = 'newsCacheKey';
  static CacheManager _newsCache = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(seconds: 60),
      maxNrOfCacheObjects: 20,
      repo: JsonCacheInfoRepository(databaseName: key),
    ),
  );

  Future<String> getRestSrc(src) async {
    DatabaseReference optionsdb = FirebaseDatabase.instance.ref("appsettings");
    final options = await optionsdb.get();
    if (options.exists) {
      final _options = (options.value
          as Map); // https://github.com/firebase/flutterfire/issues/7945#issuecomment-1065871088
      return _options["festivals"][_options["defaultfestival"]][src];
      //return "https://panakrala.sk/wp-json/wp/v2/posts?per_page=10&order=desc&categories_exclude=18,19,20&_embed&page=";
    } else {
      //print('No data in AppSettings');
      return null;
    }
  }

  Future getFileForWeb(url) async {
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var _file = response.body;
        return _file;
      }
    } catch (e) {
    }
  }

  Future<http.Response> fetchArrangements() {
    var result = http.get(Uri.parse(url2 + '/events.json'),
        headers: {'Content-Type': 'application/json; charset=utf-8'});
    return result;
  }

  Future<String> fetchNews(page) async {
    try {
      var _url = await getRestSrc("news_src");
      _url = _url.toString() + page.toString();
      var file;
      if (!kIsWeb) {
        file = await _newsCache.getSingleFile(_url, headers: {'Cache-Control':	'max-age=60'});
      } else {
        file = await getFileForWeb(_url);
      }


      if (file != null && await file.exists()) {
        final text = await file.readAsString();
        return text;
      }
      return "[]";
    } catch (e) {
      return "[]";
    }
  }

  Future<String> fetchMagazine(page) async {
    try {
      var _url = await getRestSrc("magazine_src");
      _url = _url.toString() + page.toString();
      var file = await DefaultCacheManager().getSingleFile(_url, headers: {'Cache-Control':	'max-age=60'});

      if (file != null && await file.exists()) {
        final text = await file.readAsString();
        return text;
      }
      return "[]";
    } catch (e) {
      // print(e);
      return "[]";
    }
  }

  launchURL(url) async {
    final Uri _url = Uri.parse(url);
    if (await canLaunchUrl(_url)) {
      await launchUrl(_url, mode: LaunchMode.inAppWebView);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Analytics {
  sendEvent(id) async {
    await FirebaseAnalytics.instance.logEvent(
      name: "select_content",
      parameters: {
        "content_type": "post",
        "item_id": id
      },
    );
  }
}
