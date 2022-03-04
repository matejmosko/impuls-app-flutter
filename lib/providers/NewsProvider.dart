import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:impuls/models/NewsPost.dart';
import 'package:impuls/requests/api.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsPost> _news = [];
  List<NewsPost> _articles = [];
  bool loading = false;
  bool allnews = false;
  bool allarticles = false;
  int newspage = 0;
  int totalnewspages = 1;
  int magazinepage = 0;
  int totalmagazinepages = 1;

  NewsProvider() {
    fetchNews();
    fetchMagazine();
  }

  List<NewsPost> get arrangements => _news;

  List<NewsPost> get news => _news;

  List<NewsPost> get articles => _articles;

  Future<List<NewsPost>> fetchNews() async {
    setLoading(true);
    newspage++;
    if (totalnewspages >= newspage) {
      API().fetchNews(newspage).then((data) {
        if (data.statusCode == 200) {
          totalnewspages = int.parse(data.headers["x-wp-totalpages"]);
          Iterable list = json.decode(utf8.decode(data.bodyBytes));
          setArrangements(
              list.map((model) => NewsPost.fromJson(model)).toList(), "news");
        }
      });
    } else {
      allnews = true;
    }
  }

  Future<List<NewsPost>> fetchMagazine() async {
    setLoading(true);
    magazinepage++;
    if (totalmagazinepages >= magazinepage) {
      API().fetchMagazine(magazinepage).then((data) {
        if (data.statusCode == 200) {
          totalmagazinepages = int.parse(data.headers["x-wp-totalpages"]);
          Iterable list2 = json.decode(utf8.decode(data.bodyBytes));
          setArrangements(
              list2.map((model) => NewsPost.fromJson(model)).toList(),
              "magazine");
        }
      });
    } else {
      allarticles = true;
    }
  }

  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  void setArrangements(List<NewsPost> list, category) {
    if (category == "news") {
      _news = _news + list;
    }
    if (category == "magazine") {
      _articles = _articles + list;
    }

    print(list);
    notifyListeners();
    setLoading(false);
  }
}
