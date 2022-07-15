import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:scenickazatva_app/models/NewsPost.dart';
import 'package:scenickazatva_app/requests/api.dart';

class NewsProvider extends ChangeNotifier {
  List<NewsPost> _news = [];
  List<NewsPost> _articles = [];
  bool loading = false;
  bool allnews = false;
  bool allarticles = false;
  int newspage = 1;
  int totalnewspages = 1;
  int magazinepage = 1;
  int totalmagazinepages = 1;

  NewsProvider() {
    fetchNews();
    fetchMagazine();
  }

  //List<NewsPost> get arrangements => _news;

  List<NewsPost> get news => _news;

  List<NewsPost> get articles => _articles;

  void /*Future<List<NewsPost>>*/ fetchNews() async {
      setLoading(true);
      API().fetchNews(newspage).then((data) {
        Iterable _list = json.decode(data);
        if (data == []) {allnews = true;}
          setArrangements(
              _list.map((model) => NewsPost.fromJson(model)).toList(), "news");
      });
  }

  void /* Future<List<NewsPost>>*/ fetchMagazine() async {
    setLoading(true);
      API().fetchMagazine(magazinepage).then((data) {
          Iterable _list = json.decode(data);
          if (data == []) {allarticles = true;}
          setArrangements(
              _list.map((model) => NewsPost.fromJson(model)).toList(),
              "magazine");
      });
  }

  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  void setArrangements(List<NewsPost> list, category) {
    if (category == "news") {
      _news = _news + list;
      newspage++;
    }
    if (category == "magazine") {
      _articles = _articles + list;
      magazinepage++;
    }
    notifyListeners();
    setLoading(false);
  }
}
