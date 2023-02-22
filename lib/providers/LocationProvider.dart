import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:scenickazatva_app/models/Location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scenickazatva_app/requests/api.dart';

class LocationProvider extends ChangeNotifier {
  List<Location> _venues = [];
  bool loading = false;

  InfoProvider() {
    fetchLocations();
    getIcon("default");
  }

  List<Location> get venues => _venues;

  void /*Future<List<InfoPost>>*/ fetchLocations() async {
    setLoading(true);
    FirebaseDatabase database = FirebaseDatabase.instance;
    if(!kIsWeb){database.setPersistenceEnabled(true);}


    String festival = await API().getDefaultFestival();
    final locationdb = FirebaseDatabase.instance.ref("festivals/$festival/locations");
    if(!kIsWeb){locationdb.keepSynced(true);}
    // Get the Stream
    Stream<DatabaseEvent> stream = locationdb.onValue;

// Subscribe to the stream!
    stream.listen((DatabaseEvent venue) {
      List<dynamic> list = [];
      Map validMap = json.decode(json.encode(venue.snapshot.value));
      for (var e in validMap.values){
        list.add(e);
      }
      setLocations(
        _venues = list.map((model) => Location.fromData(model)).toList()
      );
    });
    /*API().fetchInfo().then((data) {
      if (data.statusCode == 200) {
        Iterable list = json.decode(utf8.decode(data.bodyBytes));
        setInfo(
          list.map((model) => InfoPost.fromJson(model)).toList(),
        );
      }
    });*/
  }

  IconData getIcon(loc){
    if (_venues == []) {fetchLocations();}

    Location _venue = _venues.where((element) => (element.id == loc))
        .toList()[0];

    int icon = _venue !=null ? _venue.icon : 57402;
    return IconData(icon, fontFamily: 'MaterialIcons');


    /*Location event = locationProvider.venues
        .where((element) => (element.id == loc))
        .toList()[0];*/
  }

  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  void setLocations(List<Location> list) {
    _venues = list;
    notifyListeners();
    setLoading(false);
  }

}
