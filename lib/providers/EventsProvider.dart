//import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:scenickazatva_app/models/Event.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EventsProvider extends ChangeNotifier {
  Map<DateTime, List<Event>> _mappedEvents = {};
  List<Event> _events = [];
  DateTime _selectedDay = DateTime.now();
  bool _loading = false;

  EventsProvider() {
    fetchAllEvents();
  }

  DateTime get selectedDay => _selectedDay;

  Map<DateTime, List> get mappedEvents => _mappedEvents;

  List<Event> get events => _events;

  bool get loading => _loading;


  List<Event> get selectedEvents {
    return _events.where((event) {
      return event.startTime.year == _selectedDay.year &&
          event.startTime.month == _selectedDay.month &&
          event.startTime.day == _selectedDay.day;
    }).toList();
  }

  void setSelectedDay(DateTime day) {
    _selectedDay = day;
  }

  /*void /*Future<bool>*/ fetchEventsForArrangement(arrangement) async {
    setLoading(true);
    API().fetchEventsForArrangement(arrangement).then((data) {
      if (data.statusCode == 200) {
        Iterable events = json.decode(data.body);
        setEvents(
          events.map((model) => Event.fromJson(model)).toList(),
        );
      }
    });
  }*/

  void fetchAllEvents() async { // returns a bool
    setLoading(true);
    //FirebaseDatabase database = FirebaseDatabase.instance;
    //database.setPersistenceEnabled(true);
    String festival = "scenickazatva2022";
    DatabaseReference eventsdb = FirebaseDatabase.instance.ref("festivals/$festival/events");
    Stream<DatabaseEvent> stream = eventsdb.onValue;

    eventsdb.keepSynced(true);
    // Get the Stream


// Subscribe to the stream!
    stream.listen((DatabaseEvent event){

      List<dynamic> _events = [];
      Map validMap = json.decode(json.encode(event.snapshot.value));
      for (var e in validMap.values){
        _events.add(e);
      }
     setEvents(
        _events.map((model) => Event.fromJson(model)).toList(),
      );
    });

       /*setLoading(true);
    API().fetchAllEvents().then((data) {
      if (data.statusCode == 200) {

        Iterable events = json.decode(utf8.decode(data.bodyBytes));
        setEvents(
          events.map((model) => Event.fromJson(model)).toList(),
        );
      }
    });*/
  }

  void setLoading(bool val) {
    _loading = val;
    notifyListeners();
  }

  void setEvents(List<Event> events) async {
    _events = events;
    _mappedEvents.clear();
    //Todo: Refactor to not have so many lists... and do it in parent method fetchEventsForArrangement
    events.forEach((event) async {
      var key = DateTime(
          event.startTime.year, event.startTime.month, event.startTime.day);

      if (!_mappedEvents.containsKey(key)) {
        _mappedEvents.putIfAbsent(key, () => [event]);
      } else {
        _mappedEvents[key].addAll([event]);
      }
      final imgUrl = await FirebaseStorage.instance.refFromURL(event.image).getDownloadURL();
      event.image = imgUrl;
    });
    notifyListeners();
  }
}
