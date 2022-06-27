import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:impuls/models/InfoPost.dart';
import 'package:impuls/requests/api.dart';
import 'package:firebase_database/firebase_database.dart';


class InfoProvider extends ChangeNotifier {
  List<InfoPost> _info = [];
  bool loading = false;

  InfoProvider() {
    fetchInfo();
  }

  List<InfoPost> get info => _info;

  void /*Future<List<InfoPost>>*/ fetchInfo() async {
    setLoading(true);
    FirebaseDatabase database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);

    DatabaseReference infodb = FirebaseDatabase.instance.ref("info");
    infodb.keepSynced(true);
    // Get the Stream
    Stream<DatabaseEvent> stream = infodb.onValue;

// Subscribe to the stream!
    stream.listen((DatabaseEvent info) {
      print('Event Type: ${info.type}'); // DatabaseEventType.value;
      print('Snapshot: ${info.snapshot.value}'); // DataSnapshot

      final validMap = json.decode(json.encode(info.snapshot.value)) as List<dynamic>;
      Iterable list = validMap;

      setInfo(
        list.map((model) => InfoPost.fromJson(model)).toList(),
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

  void setInfo(List<InfoPost> list) {
    _info = list;
    print(list);
    notifyListeners();
    setLoading(false);
  }
}
