import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scenickazatva_app/models/NewsPost.dart';
import 'package:scenickazatva_app/providers/NewsProvider.dart';
import 'package:provider/provider.dart';
import 'package:scenickazatva_app/requests/api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class NewsDetailPage extends StatelessWidget {
  final newsId;

  NewsDetailPage({@required this.newsId});

  @override
  Widget build(BuildContext context) {
    final NewsProvider newsProvider = Provider.of<NewsProvider>(context);
    List<NewsPost> allNews = newsProvider.news;
    NewsPost news = NewsPost();
    news = allNews.where((element) => (element.id.toString() == newsId))
        .toList()[0];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              context.go("/news");
            }),
        title: Text(
          "TVOR•BA 2023",
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            CachedNetworkImage(
              imageUrl: news.image,
              placeholder: (context, url) =>
                  Image.asset('assets/images/icon512.png'),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/icon512.png'),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Text("${news.title}",
                      style: Theme.of(context).textTheme.displayLarge),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: //Text("${news.content ?? ''}"),
                        Html(
                      data: news.content,
                      onLinkTap: (url, renderContext, map, element) =>
                          API().launchURL(url),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
