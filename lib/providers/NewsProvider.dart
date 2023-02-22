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
  int magazinepage = 1;

  NewsProvider() {
    fetchNews("news_src");
    fetchMagazine("magazine_src");
  }

  //List<NewsPost> get arrangements => _news;

  List<NewsPost> get news => _news;

  List<NewsPost> get articles => _articles;

  void /*Future<List<NewsPost>>*/ fetchNews(src, {refresh = false}) async {
    setLoading(true);
    if (refresh){
      allnews = false;
      newspage = 1;
    }

    API().fetchNews(src, newspage).then((data) {
      Iterable _list = json.decode(data);
      if (data == []) {
        allnews = true;
      }
      setArrangements(
          _list.map((model) => NewsPost.fromJson(model)).toList(), "news", refresh);
    });
  }

  void /* Future<List<NewsPost>>*/ fetchMagazine(src, {refresh = false}) async {
    setLoading(true);
    if (refresh){
      allarticles = false;
      magazinepage = 1;
    }

    API().fetchNews(src, magazinepage).then((data) {
      Iterable _list = json.decode(data);
      if (data == []) {
        allarticles = true;
      }
      setArrangements(
          _list.map((model) => NewsPost.fromJson(model)).toList(), "magazine", refresh);
    });
  }

  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  void setArrangements(List<NewsPost> list, category, refresh) {
    if (category == "news") {
      if (refresh){
       _news = [];
       refresh = false;
      }
      _news = _news + list;
      newspage++;
    }
    if (category == "magazine") {
      if (refresh){
        _articles = [];
        refresh = false;
      }
      _articles = _articles + list;
      magazinepage++;
    }
    setLoading(false);
    notifyListeners();
  }
}
