import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:scenickazatva_app/models/AppSettings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scenickazatva_app/requests/api.dart';

class AppSettingsProvider extends ChangeNotifier {
  AppSettings _appsettings = AppSettings();
  bool loading = false;
  String defaultfestival = "";

  AppSettingsProvider() {
    fetchSettings();
  }

  AppSettings get appsettings => _appsettings;

  void fetchSettings() async {
    setLoading(true);
    defaultfestival = await API().getDefaultFestival();
    FirebaseDatabase database = FirebaseDatabase.instance;
    if(!kIsWeb){database.setPersistenceEnabled(true);}



    final settingsdb = FirebaseDatabase.instance.ref("appsettings/");
    if(!kIsWeb){settingsdb.keepSynced(true);}
    // Get the Stream
    Stream<DatabaseEvent> stream = settingsdb.onValue;

// Subscribe to the stream!
    stream.listen((DatabaseEvent settingsdb) {
      Map<String,dynamic> list = json.decode(json.encode(settingsdb.snapshot.value));
      //Map<String,dynamic> validMap = json.decode(json.encode(settingsdb.snapshot.value));
      print(list);
      setSettings(
           AppSettings.fromJson(list)

      //list.map((model) => Festival.fromJson(model)).toList(),
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

  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  void setSettings(AppSettings list) {
   /* print(list);
    if (list==[]){
      list = {"default": Festival()};
    }
    print("test");
    print(list);
    _appsettings =  AppSettings(
      defaultfestival: defaultfestival,
      festivals: list,
        );
        */
    _appsettings = list;
    print(_appsettings);

    notifyListeners();
    setLoading(false);
  }
}
