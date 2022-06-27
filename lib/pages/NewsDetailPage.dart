import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:impuls/models/Event.dart';
import 'package:impuls/models/NewsPost.dart';
import 'package:impuls/providers/AppSettings.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsPost news;

  NewsDetailPage({@required this.news});

  @override
  Widget build(BuildContext context) {
    final ColorProvider colorTheme = Provider.of<ColorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorTheme.mainColor,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: colorTheme.secondaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Scénická žatva 100",
          style: TextStyle(color: colorTheme.secondaryColor),
        ),
      ),
      backgroundColor: colorTheme.secondaryColor,
      body: SafeArea(
        child: ListView(
          children: [
            Hero(
              child: news.image != null ? Image.network(news.image) : SizedBox(),
              tag: news.id,
            ),
            Card(
                color: Colors.white,
                child: ListTile(
//                  leading: Text("$startTime$location$endTime"),
                  title: Text("${news.title ?? ''}"),
                ),
              ),

            news.description != null
                ? Card(
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: //Text("${news.content ?? ''}"),
                          Html(data: news.content,
                            onLinkTap: (url, renderContext, map, element) async {
                            final Uri _url = Uri.parse(url);
                              if (await canLaunchUrl(_url)) {
                                await launchUrl(_url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                      /*child: MarkdownBody(
                        onTapLink: (text, href, title) => _launchURL(href),
                        data: news.description,
                      ),*/
                    ),
                  )
            ): SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
