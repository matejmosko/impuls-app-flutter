import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scenickazatva_app/models/Event.dart';
import 'package:provider/provider.dart';
import 'package:scenickazatva_app/providers/EventsProvider.dart';
import 'package:intl/intl.dart';
import 'package:scenickazatva_app/requests/api.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown/markdown.dart' as MD;
import 'package:go_router/go_router.dart';

class EventDetailPage extends StatelessWidget {
  final eventId;

  EventDetailPage({@required this.eventId});

  @override
  Widget build(BuildContext context) {
    EventsProvider eventsProvider =
        Provider.of<EventsProvider>(context, listen: false);
    Event event = eventsProvider.events
        .where((element) => (element.id == eventId))
        .toList()[0];

    final startDate = event.startTime != null
        ? new DateFormat("E, d.M.", "sk_SK").format(event.startTime!)
        : '';
    final startTime = event.startTime != null
        ? new DateFormat("HH:mm").format(event.startTime!)
        : '';
    final endTime = event.endTime != null
        ? "\n${new DateFormat("HH:mm").format(event.endTime!)}"
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
            onPressed: () {
              context.go("/events");
            }),
        title: Text(
          "TVOR•BA 2023",
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Hero(
              child: event.image != null
                  ? Image(
                      image: FirebaseImageProvider(FirebaseUrl(event.image)),
                      fit: BoxFit.cover,
                      height: 300,
                      width: double.infinity,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Image.asset(
                          'assets/images/icon512.png',
                          fit: BoxFit.cover,
                          height: 300,
                          width: double.infinity,
                        );
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
                                  Text("${event.title}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall),
                                  Text("${event.artist}"),
                                ]),
                          ),
                          Column(
                            /*crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,*/
                            children: <Widget>[
                              Icon(eventsProvider.getLocationIcon(event.location),
                                  color: eventsProvider.getLocationColor(event.location),
                                  size: 26),
                              Text(eventsProvider.getLocationName(event.location),
                                  style: TextStyle(
                                      color:
                                      eventsProvider.getLocationColor(event.location))),
                            ],
                          ),
                        ])),
                event.description != null
                    ? Padding(
                        padding: EdgeInsets.all(12),
                        child: Html(
                          data: MD.markdownToHtml(event.description),
                          onLinkTap: (url, renderContext, map, element) =>
                              API().launchURL(url),
                        ))
                    : SizedBox.shrink()
              ]),
            ),
          ],
        ),
      ),
      floatingActionButton: kIsWeb == true ? FloatingActionButton(
        onPressed: () {
          context.go("/events/" + event.id + "/edit");
          /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventEditPage(
                eventId: event,
              ),
            ),
          );*/
        },
        child: const Icon(Icons.edit),
      ) : SizedBox(),
    );
  }
}
