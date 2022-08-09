import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scenickazatva_app/models/NewsPost.dart';
import 'package:scenickazatva_app/requests/api.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsPost news;

  NewsDetailPage({@required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Scénická žatva 100",
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Hero(
              child: news.image != null
                  ? CachedNetworkImage(imageUrl: news.image,
                placeholder: (context, url) => Image.asset('assets/images/icon512.png'),
                errorWidget: (context, url, error) => Image.asset('assets/images/icon512.png'),
              )
                  : SizedBox(),
              tag: news.id,
            ),
            Card(
              child: Column(
                children: <Widget>[
                  Text("${news.title ?? ''}",
                      style: Theme.of(context).textTheme.headline1),
                  news.description != null
                      ? Padding(
                          padding: EdgeInsets.all(12),
                          child: //Text("${news.content ?? ''}"),
                              Html(
                            data: news.content,
                            onLinkTap: (url, renderContext, map, element) => API().launchURL(url),
                          ),
                        )
                      : SizedBox.shrink()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
