import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:impuls/models/Event.dart';
import 'package:impuls/providers/AppSettings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  EventDetailPage({@required this.event});

  @override
  Widget build(BuildContext context) {
    //final ColorProvider colorTheme = Provider.of<ColorProvider>(context);
    final startTime = event.startTime != null
        ? new DateFormat("hh:mm").format(event.startTime)
        : '';
    final endTime = event.endTime != null
        ? "\n${new DateFormat("hh:mm").format(event.endTime)}"
        : '';

    //Location
    final location = event.location != null ? "\n${event.location}" : '';

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
              child: event.image != null
                  ? CachedNetworkImage(imageUrl: event.image)
                  : SizedBox(),
              tag: event.id,
            ),
            Card(
              child: Column(children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("$startTime - $endTime"),
                      Expanded(
                        child: Text("${event.title ?? ''}",
                            style: Theme.of(context).textTheme.headline2),
                      ),
                      Text("$location"),
                    ]),
                event.description != null
                    ? Padding(
                        padding: EdgeInsets.all(12),
                        child: MarkdownBody(
                          onTapLink: (text, href, title) => _launchURL(href),
                          data: event.description,
                        ),
                      )
                    : SizedBox.shrink()
              ]),
            ),
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
