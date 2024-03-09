import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:scenickazatva_app/providers/NewsProvider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scenickazatva_app/requests/api.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:scenickazatva_app/models/PostExtension.dart';

class NewsView extends StatefulWidget {
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> with TickerProviderStateMixin {

  static String stripHtml(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }


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
              "Načítavam...",
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: newsProvider.wpnews.length > 0 ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: Container(
              child: Column(
            children: <Widget>[
              Flexible(
                child: LazyLoadScrollView(
                  onEndOfPage: () => newsProvider.fetchWpNews("news_src"),
                  isLoading: newsProvider.loading,
                  scrollOffset: 10,
                  child: RefreshIndicator(
                      child: ListView.builder(
                        itemCount: newsProvider.wpnews.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = newsProvider.wpnews[index];

                          return Card(
                            child: GestureDetector(
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(item.title!.rendered ?? ""),
                                          titleTextStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18.0),
                                          subtitle: Text(stripHtml(item.excerpt!.rendered ?? "").substring(1,105)+"..."),
                                        ),
                                      ),
                                      Container(
                                        width: 120.0,
                                        height: 120.0,
                                       child: CachedNetworkImage(
                                          //item['_embedded'][0]['wp:featuredimage']['source_url'] ?? "",
                                          imageUrl: item.featuredImageSourceUrl(),
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                          width: double.infinity,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                  'assets/images/icon512.png'),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  'assets/images/icon512.png'),
                                        ),
                                      ),
                                    ]),
                                onTap: () {
                                  Analytics().sendEvent(item.title!.rendered);
                                  context.go("/news/" + item.id.toString());
/*                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewsDetailPage(
                                      newsId: item.id,
                                    ),
                                  ),
                                );*/
                                }),
                          );
                        },
                      ),
                      onRefresh: () {
                        return Future.delayed(Duration(seconds: 0), () {
                          /// adding elements in list after [1 seconds] delay
                          /// to mimic network call
                          ///
                          /// Remember: [setState] is necessary so that
                          /// build method will run again otherwise
                          /// list will not show all elements
                          setState(() {
                            newsProvider.fetchWpNews("news_src", refresh: true);
                          });
                        });
                      }),
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
