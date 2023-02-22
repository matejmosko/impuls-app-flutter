import 'package:flutter/material.dart';
import 'package:scenickazatva_app/models/Event.dart';
import 'package:provider/provider.dart';
import 'package:scenickazatva_app/providers/EventsProvider.dart';
import 'package:intl/intl.dart';
//import 'package:scenickazatva_app/providers/AppSettings.dart';
//import 'package:scenickazatva_app/requests/api.dart';
//import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:go_router/go_router.dart';

class EventEditPage extends StatefulWidget {
  //const EventEditPage({super.key, @required this.event});
  final eventId;
  const EventEditPage({Key? key, @required this.eventId}) : super(key: key);

  @override
  EventEditPageState createState() => EventEditPageState();
}

class EventEditPageState extends State<EventEditPage> {
  final _formKey = GlobalKey<FormState>();
  var startDate;
  var endDate;
  late Event event;

  @override
  void initState() {
    super.initState();
    // Start listening to changes.
  }

  Widget buildForm(BuildContext context) {
    EventsProvider eventsProvider =
        Provider.of<EventsProvider>(context, listen: false);
    Event event = eventsProvider.events
        .where((element) => (element.id == widget.eventId))
        .toList()[0];
    print(event);

    startDate = event.startTime;
    endDate = event.endTime;

    HtmlEditorController htmlcontroller = HtmlEditorController();

    Future<void> displayTimeDialog(BuildContext context, iniTime, field) async {
      final TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(iniTime),
          builder: (ctx, child) => PointerInterceptor(child: child!));
      if (time != null) {
        setState(() {
          if (field == "start") {
            startDate = DateTime(iniTime.year, iniTime.month, iniTime.day,
                time.hour, time.minute);
          } else if (field == "end") {
            endDate = DateTime(iniTime.year, iniTime.month, iniTime.day,
                time.hour, time.minute);
          }
        });
      }
    }

    Future<DateTime?> displayDateDialog(BuildContext context, iniDate, field) async {
      final DateTime? date = await showDatePicker(
          context: context,
          initialDate: iniDate,
          firstDate: DateTime(1970),
          lastDate: DateTime(2201),
          builder: (ctx, child) => PointerInterceptor(child: child!));

      if (date != null) {
        setState(() {
          if (field == "start") {
            startDate = DateTime(
                date.year, date.month, date.day, iniDate.hour, iniDate.minute);
            print("after");
            print(startDate.toLocal());
          } else if (field == "end") {
            endDate = DateTime(
                date.year, date.month, date.day, iniDate.hour, iniDate.minute);
          }
        });
      }
      return date;
    }

    // Build a Form widget using the _formKey created above.
    return Container(
      padding: EdgeInsets.all(45),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                child: TextFormField(
                  initialValue: event.title,
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
              ),
              Flexible(
                child: TextFormField(
                  initialValue: event.id,
                  readOnly: true,
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
              ),
            ]),

            TextFormField(
              initialValue: event.artist,
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
              initialValue: event
                  .location, // TODO Prerobiť location na DropdownButtonFormField() - na to ale treba zmeniť aj spôsob priraďovania miest podujatí a prehodiť to na firebase (teraz je to hardcoded)
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
            Row(
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    controller: TextEditingController(
                        text:
                            "${DateFormat("E, d.M. yyyy", "sk_SK").format(startDate)}"),
                    readOnly: true,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Dátum začiatku",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Prosím, vyklikajte si dátum.';
                      }
                      return null;
                    },
                    onTap: () {
                      displayDateDialog(context, startDate, "start");
                    },
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    controller: TextEditingController(
                        text:
                            "${DateFormat("HH:mm", "sk_SK").format(startDate)}"),
                    readOnly: true,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Čas začiatku",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Prosím, vyklikajte si čas.';
                      }
                      return null;
                    },
                    onTap: () {
                      displayTimeDialog(context, startDate, "start");
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: TextFormField(
                    controller: TextEditingController(
                        text:
                            "${DateFormat("E, d.M. yyyy", "sk_SK").format(endDate)}"),
                    readOnly: true,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Dátum konca",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Prosím, vyklikajte si dátum.';
                      }
                      return null;
                    },
                    onTap: () {
                      displayDateDialog(context, endDate, "end");
                    },
                  ),
                ),
                Flexible(
                  child: TextFormField(
                    controller: TextEditingController(
                        text:
                            "${DateFormat("HH:mm", "sk_SK").format(endDate)}"),
                    readOnly: true,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Čas začiatku",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Prosím, vyklikajte si čas.';
                      }
                      return null;
                    },
                    onTap: () {
                      displayTimeDialog(context, endDate, "end");
                    },
                  ),
                ),
              ],
            ),
            HtmlEditor(
              controller: htmlcontroller, //required
              htmlEditorOptions: HtmlEditorOptions(
                hint: "Your text here...",
                initialText: event.description,
                shouldEnsureVisible: true,
              ),
              htmlToolbarOptions: HtmlToolbarOptions(
                toolbarPosition: ToolbarPosition.aboveEditor, //by default
                toolbarType: ToolbarType.nativeScrollable, //by default
                defaultToolbarButtons: [
                  StyleButtons(),
                  //FontSettingButtons(),
                  FontButtons(),
                  //ColorButtons(),
                  ListButtons(listStyles: false),
                  //ParagraphButtons(),
                  //InsertButtons(),
                  OtherButtons(),
                ],
              ),
              otherOptions: OtherOptions(
                height: 400,
              ),
            ),

            // Add TextFormFields and ElevatedButton here.
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
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
            onPressed: () {
              context.go("/events/" + widget.eventId);
            }),
        title: Text(
          "TVOR•BA 2023",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.redAccent,
            ),
            onPressed: () {
              // TODO Delete event
              context.go("/events/"+widget.eventId);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              context.go("/events/" + widget.eventId);
              /* Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailPage(
                    eventId: event.id,
                  ),
                ),
              );*/
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            /*Hero(
              child: event.image != null
                  ? Image(
                      image: FirebaseImageProvider(
                          FirebaseUrl(event.image)),
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
              tag: event.image,
            ),*/
            Card(child: buildForm(context)),
          ],
        ),
      ),
      floatingActionButton: PointerInterceptor(
        child: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Processing Data')),
              );
            }
            context.go("/events/" + widget.eventId);
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
      ),
    );
  }
}
