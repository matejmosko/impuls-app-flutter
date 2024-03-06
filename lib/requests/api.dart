//import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_analytics/firebase_analytics.dart'; // imported for firebase messaging to log events


class API {
  final String selectedArrangement = '5e19cdd924cfa04fc3de1d3a';

  Future<String> getRestSrc(src) async {
    DatabaseReference optionsdb = FirebaseDatabase.instance.ref("appsettings");
    final options = await optionsdb.get();
    if (options.exists) {
      final _options = (options.value
          as Map); // https://github.com/firebase/flutterfire/issues/7945#issuecomment-1065871088
      return _options["festivals"][_options["defaultfestival"]][src];
    } else {
      print('No data in AppSettings');
      return "";
    }
  }

  Future<String> getDefaultFestival() async {
    DatabaseReference optionsdb = FirebaseDatabase.instance.ref("appsettings");
    final options = await optionsdb.get();
    if (options.exists) {
      final _options = (options.value as Map);
      return _options["defaultfestival"];
    } else {
      return "";
    }
  }

  Future<List<Post>> fetchWpNews(src, page) async {
    var _url = await getRestSrc(src);
    final baseUrl = Uri.parse(_url);
    final client = WordpressClient(baseUrl: baseUrl);

    client.initialize();

    final request =
        ListPostRequest(page: page, perPage: 20, extra: {"_embed": 1});

    final wpResponse = await client.posts.list(request);

    List<Post> data = [];

    switch (wpResponse) {
      case WordpressSuccessResponse():
        data = wpResponse.data; // List<Post>
        break;
      case WordpressFailureResponse():
        final error = wpResponse.error; //// WordpressError
        print(error);
        break;
    }
    return data;
  }

  Future<String> fetchNews(src, page) async {
    try {
      var _url = await getRestSrc(src);
      _url = _url.toString() + page.toString();
      /* if (!kIsWeb) { */
      var file = await DefaultCacheManager()
          .getSingleFile(_url, headers: {'Cache-Control': 'max-age=0'});
      /*} else {
        print(_url);
        file = await getFileForWeb(_url);
        print(file);
      }*/

      if (await file.exists()) {
        final text = await file.readAsString();
        return text;
      }
      return "[]";
    } catch (e) {
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
      parameters: {"content_type": "post", "item_id": id},
    );
  }
}
