import 'package:flutter/material.dart';
import 'package:scenickazatva_app/models/Event.dart';
import 'package:scenickazatva_app/pages/EventEditPage.dart';
import 'package:intl/intl.dart';
import 'package:scenickazatva_app/providers/AppSettings.dart';
import 'package:scenickazatva_app/requests/api.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown/markdown.dart' as MD;

class EventDetailPage extends StatelessWidget {
  final Event event;

  EventDetailPage({@required this.event});

  @override
  Widget build(BuildContext context) {
    final startDate = event.startTime != null
        ? new DateFormat("E, d.M.", "sk_SK").format(event.startTime)
        : '';
    final startTime = event.startTime != null
        ? new DateFormat("HH:mm").format(event.startTime)
        : '';
    final endTime = event.endTime != null
        ? "\n${new DateFormat("HH:mm").format(event.endTime)}"
        : '';

    //Location
    //final location = event.location != null ? "\n${event.location}" : '';
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
                  ? Image(
                      image: FirebaseImageProvider(
                          FirebaseUrl(event.image)
                      ),
                      fit: BoxFit.cover,
                      height: 300,
                      width: double.infinity,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        return Image.asset('assets/images/icon512.png',
                          fit: BoxFit.cover,
                          height: 300,
                          width: double.infinity,);
                      },
                    )
                  : SizedBox(),
              tag: event.image,
            ),
            Card(
              child: Column(children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).dividerColor))),
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
                                          .headline3),
                                  Text("${event.artist ?? ''}"),
                                ]),
                          ),
                          Column(
                            /*crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,*/
                            children: <Widget>[
                              Icon(Venues().getIcon(event.location), color: Venues().getColor(event.location), size: 26),
                              Text(Venues().getName(event.location),
                                  style: TextStyle(color: Venues().getColor(event.location))),
                            ],
                          ),
                        ])),
                event.description != null
                    ? Padding(
                        padding: EdgeInsets.all(12),
                        child: Html(
                          data: MD.markdownToHtml(event.description),
                          onLinkTap: (url, renderContext, map, element) => API().launchURL(url),
                        )
                )
                    : SizedBox.shrink()
              ]),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventEditPage(
                event: event,
              ),
            ),
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
