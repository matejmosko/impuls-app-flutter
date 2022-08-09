import 'package:flutter/material.dart';
import 'package:scenickazatva_app/models/InfoPost.dart';
import 'package:scenickazatva_app/requests/api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown/markdown.dart' as MD;

class InfoDetailPage extends StatelessWidget {
  final InfoPost info;

  InfoDetailPage({@required this.info});

  @override
  Widget build(BuildContext context) {
    //final ColorProvider colorTheme = Provider.of<ColorProvider>(context);

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
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Hero(
              child: info.image != null
                  ? CachedNetworkImage(
                      imageUrl: info.image,
                      placeholder: (context, url) =>
                          Image.asset('assets/images/icon512.png'),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/icon512.png'))
                  : SizedBox(),
              tag: info.id,
            ),
            Card(
                child: Column(
              children: <Widget>[
                ListTile(
//                  leading: Text("$startTime$location$endTime"),
                  title: Text("${info.title ?? ''}"),
                ),
                info.description != null
                    ? Padding(
                        padding: EdgeInsets.all(12),
                        child: Html(
                          data: MD.markdownToHtml(info.description),
                          onLinkTap: (url, renderContext, map, element) => API().launchURL(url),
                        ))
                    : SizedBox.shrink()
              ],
            ))
          ],
        ),
      ),
    );
  }
}
