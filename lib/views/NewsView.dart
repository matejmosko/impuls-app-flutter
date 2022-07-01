import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:impuls/pages/NewsDetailPage.dart';
import 'package:impuls/providers/NewsProvider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NewsView extends StatelessWidget {
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    final NewsProvider newsProvider = Provider.of<NewsProvider>(context);

    return Stack(
      children: [
        Center(
          child: AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity: newsProvider.loading ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            // The green box must be a child of the AnimatedOpacity widget.
            child: Text(
              "Loading...",
              style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: newsProvider.news.length > 0 ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: Container(
              child: Column(
            children: <Widget>[
              Flexible(
                  child: ListView.builder(
                    itemCount: newsProvider.news.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = newsProvider.news[index];
                      return Card(
                        elevation: 10,
                        child: GestureDetector(
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Expanded(
                              child: ListTile(
                                title: Text(item.title),
                                subtitle: Html(data: item.description),
                              ),
                            ),
                            item.image != null
                                ? Container(
                                    width: 120.0,
                                    height: 120.0,
                                    child: Hero(
                                      child: CachedNetworkImage(
                                        imageUrl: item.image,
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                        ),
                                      tag: item.id,
                                    ),
                                  )
                                : SizedBox.shrink(),
                          ]),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailPage(
                                news: item,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

              ),
              Container(
                  child: (newsProvider.loading && !newsProvider.allnews)
                      ? Padding(
                      padding: EdgeInsets.all(20),
                      child: new CircularProgressIndicator())
                      : new Row())
            ],
          )),
        )
      ],
    );
  }
}