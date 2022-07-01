import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:impuls/models/InfoPost.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
                  ? CachedNetworkImage(imageUrl: info.image)
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
                        child: MarkdownBody(
                          onTapLink: (text, href, title) => _launchURL(href),
                          data: info.description,
                        ),
                      )
                    : SizedBox.shrink()
              ],
            ))
          ],
        ),
      ),
    );
  }
}

_launchURL(url) async {
  final Uri _url = Uri.parse(url);
  if (await canLaunchUrl(_url)) {
    await launchUrl(_url);
  } else {
    throw 'Could not launch $url';
  }
}
