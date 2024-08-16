import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:scenickazatva_app/models/Festival.dart';
import 'package:scenickazatva_app/models/HivePreferences.dart';

class FestivalProvider extends ChangeNotifier {
  Festival _festival = Festival();
  bool loading = false;

  FestivalProvider() {
    fetchFestival();
  }

  Festival get festival => _festival;

  void /*Future<List<InfoPost>>*/ fetchFestival() async {
    Preferences prefs = await Preferences.getInstance();
    Festival festival = prefs.getFestival();
/*
    setLoading(true);
    FirebaseDatabase database = FirebaseDatabase.instance;
    if(!kIsWeb){database.setPersistenceEnabled(true);}


    String festival = await API().getDefaultFestival();
    final festivaldb = FirebaseDatabase.instance.ref("appsettings/festivals/$festival").orderByChild("id");
    if(!kIsWeb){festivaldb.keepSynced(true);}
    // Get the Stream
    Stream<DatabaseEvent> stream = festivaldb.onValue;

// Subscribe to the stream!
    stream.listen((DatabaseEvent festival) {

      Map<String, dynamic> validMap = json.decode(json.encode(festival.snapshot.value)) as Map<String, dynamic>;

    });
      setFestival(Festival.fromJson(validMap));
      */
  setFestival(festival);

  }

  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  void setFestival(Festival fest) {
    _festival = fest;
    notifyListeners();
    setLoading(false);
  }

  Color getColor(String colorString) {
    int colorInt = int.parse(colorString, radix: 16);
    Color color = new Color(colorInt);
    return color;
  }
}
