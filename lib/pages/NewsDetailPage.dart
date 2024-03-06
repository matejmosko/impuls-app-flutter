import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scenickazatva_app/providers/NewsProvider.dart';
import 'package:provider/provider.dart';
import 'package:scenickazatva_app/requests/api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'package:scenickazatva_app/models/PostExtension.dart';

class NewsDetailPage extends StatelessWidget {
  final newsId;

  NewsDetailPage({@required this.newsId});

  @override
  Widget build(BuildContext context) {
    final NewsProvider newsProvider = Provider.of<NewsProvider>(context);
    List<Post> allNews = newsProvider.wpnews;
    List<Post> allArticles = newsProvider.wparticles;

    Post news = Post(
      id: 0,
      slug: "",
      status: getContentStatusFromValue(null),
      link: "",
      author: 0,
      commentStatus: getStatusFromValue(null),
      pingStatus: getStatusFromValue(null),
      sticky: false,
      format: getFormatFromValue(null),
      self: {},
    );

    if (GoRouterState.of(context).uri.toString().contains("magazine") &&
        allArticles.map((element) => (element.id == newsId)).length > 0) {
    news = allArticles
          .where((element) => (element.id.toString() == newsId))
          .toList()[0];
    } else if (GoRouterState.of(context).uri.toString().contains("news") &&
        allNews.map((element) => (element.id == newsId)).length > 0) {
    news = allNews
          .where((element) => (element.id.toString() == newsId))
          .toList()[0];
    }

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
          "TVOR•BA 2024",
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            CachedNetworkImage(
              imageUrl: news.featuredImageSourceUrl(),
              placeholder: (context, url) =>
                  Image.asset('assets/images/icon512.png'),
              errorWidget: (context, url, error) =>
                  Image.asset('assets/images/icon512.png'),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Text("${news.title!.rendered}",
                      style: Theme.of(context).textTheme.displayLarge),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: //Text("${news.content ?? ''}"),
                        Html(
                      data: news.content!.rendered,
                      onLinkTap: (url, map, element) => API().launchURL(url),
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
