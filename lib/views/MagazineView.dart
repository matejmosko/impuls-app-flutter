import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:scenickazatva_app/providers/NewsProvider.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scenickazatva_app/requests/api.dart';
import 'package:scenickazatva_app/models/PostExtension.dart';

class MagazineView extends StatefulWidget {
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  @override
  _MagazineViewState createState() => _MagazineViewState();
}

class _MagazineViewState extends State<MagazineView>
    with TickerProviderStateMixin {
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
          opacity: newsProvider.wparticles.length > 0 ? 1.0 : 0.0,
          duration: Duration(milliseconds: 500),
          child: Container(
              child: Column(
            children: <Widget>[
              Flexible(
                child: LazyLoadScrollView(
                  onEndOfPage: () => newsProvider.fetchWpMagazine("magazine_src"),
                  isLoading: newsProvider.loading,
                  scrollOffset: 10,
                  child: RefreshIndicator(
                      child: ListView.builder(
                        itemCount: newsProvider.wparticles.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = newsProvider.wparticles[index];
                          //print(item);
                          return Card(
                            child: GestureDetector(
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          title: Text(item.title!.rendered ?? ""),
                                          titleTextStyle: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 20.0),
                                          subtitle:
                                          Html(data: item.excerpt!.rendered ?? ""),
                                        ),
                                      ),
                                      Container(
                                        width: 120.0,
                                        height: 120.0,
                                        child: CachedNetworkImage(
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
                                  context.go("/magazine/" + item.id.toString());
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
                            newsProvider.fetchWpMagazine("magazine_src",
                                refresh: true);
                          });
                        });
                      }),
                ),
              ),
              Container(
                  child: (newsProvider.loading && !newsProvider.allarticles)
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
