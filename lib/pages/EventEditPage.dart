import 'package:flutter/material.dart';
import 'package:scenickazatva_app/models/Event.dart';
import 'package:scenickazatva_app/pages/EventDetailPage.dart';
import 'package:intl/intl.dart';
import 'package:scenickazatva_app/providers/AppSettings.dart';
import 'package:scenickazatva_app/requests/api.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown/markdown.dart' as MD;

class EventEditPage extends StatefulWidget {
  //const EventEditPage({super.key, @required this.event});
  final Event event;
  const EventEditPage({Key key, @required this.event}) : super(key: key);

  @override
  EventEditPageState createState() => EventEditPageState();
}

class EventEditPageState extends State<EventEditPage> {
  final _formKey = GlobalKey<FormState>();

  var edited;

  Widget buildForm(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: widget.event.title,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "Názov podujatia",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: widget.event.artist,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "Umelec",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: widget.event.location, // TODO Prerobiť location na DropdownButtonFormField() - na to ale treba zmeniť aj spôsob priraďovania miest podujatí a prehodiť to na firebase (teraz je to hardcoded)
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "Miesto podujatia",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: widget.event.description,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "Popis",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            initialValue: widget.event.id,
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: "ID",
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    final startDate = widget.event.startTime != null
        ? new DateFormat("E, d.M.", "sk_SK").format(widget.event.startTime)
        : '';
    final startTime = widget.event.startTime != null
        ? new DateFormat("HH:mm").format(widget.event.startTime)
        : '';
    final endTime = widget.event.endTime != null
        ? "\n${new DateFormat("HH:mm").format(widget.event.endTime)}"
        : '';

    //Location
    //final location = widget.event.location != null ? "\n${widget.event.location}" : '';
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        foregroundColor: Colors.redAccent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Scénická žatva 100",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
            onPressed: () {
              // TODO Delete event
/*              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailPage(
                    event: event,
                  ),
                ),
              ); */
            },
          ),
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailPage(
                    event: widget.event,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Hero(
              child: widget.event.image != null
                  ? Image(
                      image: FirebaseImageProvider(
                          FirebaseUrl(widget.event.image)),
                      fit: BoxFit.cover,
                      height: 300,
                      width: double.infinity,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace stackTrace) {
                        return Image.asset(
                          'assets/images/icon512.png',
                          fit: BoxFit.cover,
                          height: 300,
                          width: double.infinity,
                        );
                      },
                    )
                  : SizedBox(),
              tag: widget.event.image,
            ),
            Card(
              child: buildForm(context) /* Column(children: <Widget>[
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
                                  Text("EDIT ${widget.event.title ?? ''}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3),
                                  Text("${widget.event.artist ?? ''}"),
                                ]),
                          ),
                          Column(
                            /*crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,*/
                            children: <Widget>[
                              Icon(Venues().getIcon(widget.event.location),
                                  color:
                                      Venues().getColor(widget.event.location),
                                  size: 26),
                              Text(Venues().getName(widget.event.location),
                                  style: TextStyle(
                                      color: Venues()
                                          .getColor(widget.event.location))),
                            ],
                          ),
                        ])),
                widget.event.description != null
                    ? Padding(
                        padding: EdgeInsets.all(12),
                        child: Html(
                          data: MD.markdownToHtml(widget.event.description),
                          onLinkTap: (url, renderContext, map, element) =>
                              API().launchURL(url),
                        ))
                    : SizedBox.shrink()
              ]), */
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
          }
          /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventDetailPage(
                event: widget.event,
              ),
            ),
          );*/
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
