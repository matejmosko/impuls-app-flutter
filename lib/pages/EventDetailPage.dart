import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:impuls/models/Event.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  EventDetailPage({@required this.event});

  @override
  Widget build(BuildContext context) {
    final startDate = event.startTime != null
        ? new DateFormat("E, d.M.").format(event.startTime)
        : '';
    final startTime = event.startTime != null
        ? new DateFormat("HH:mm").format(event.startTime)
        : '';
    final endTime = event.endTime != null
        ? "\n${new DateFormat("HH:mm").format(event.endTime)}"
        : '';

    //Location
    final location = event.location != null ? "\n${event.location}" : '';
    Color locColor;
    IconData locIcon;
    String locName;
    switch (event.location) {
      case "Štúdio":
        locColor = Colors.orangeAccent;
        locIcon = Icons.corporate_fare;
        locName = "Štúdio SKD";
        break;
      case "ND":
        locColor = Colors.brown;
        locIcon = Icons.house;
        locName = "Národný Dom";
        break;
      case "TKS":
        locColor = Colors.greenAccent;
        locIcon = Icons.grass;
        locName = "Pred TKS";
        break;
      case "BarMuseum":
        locColor = Colors.deepPurple;
        locIcon = Icons.museum;
        locName = "BarMuseum";
        break;
      case "Stan":
        locColor = Colors.blueAccent;
        locIcon = Icons.storefront;
        locName = "Stan";
        break;
      case "Námestie":
        locColor = Colors.blueAccent;
        locIcon = Icons.storefront;
        locName = "Divadelné námestie";
        break;
      default:
        locColor = Colors.grey;
        locIcon = Icons.location_city;
        break;
    }
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
                Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor))),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text("$startDate\n$startTime - $endTime"),
                          ),
                          Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("${event.title ?? ''}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2),
                                  Text("${event.artist ?? ''}"),
                                ]),
                          ),
                          Column(
                            /*crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,*/
                            children: <Widget>[
                              Icon(locIcon, color: locColor, size: 26),
                              Text("$locName",
                                  style: TextStyle(color: locColor)),
                            ],
                          ),
                        ])),
                event.description != null
                    ? Padding(
                        padding: EdgeInsets.all(12),
                        child: Html(
                          data: event.description,
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
                          data: event.description,
                        ),*/
                        ))
                    : SizedBox.shrink()
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
