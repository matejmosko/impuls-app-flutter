import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:scenickazatva_app/providers/AppSettings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<Map<Object, Object>> _pushSettings;

  @override
  void initState() {
    super.initState();
    _pushSettings = getPushSettings();
  }

  Future<Map<Object, Object>> getPushSettings() async {
    DatabaseReference festivalsdb =
        FirebaseDatabase.instance.ref("appsettings/festivals");
    final festivals = await festivalsdb.get();
    if (festivals.exists) {
      final _uid = FirebaseAuth.instance.currentUser.uid;
      DatabaseReference usersdb =
          FirebaseDatabase.instance.ref("users/$_uid/notifications");

      final usersettings = await usersdb.get();

      final _festivals = festivals.value as Map;
      final _user = usersettings.value as Map;
      Map<String, bool> _data = {};

      _festivals.forEach((key, value) {
        if (key != null) {
          _data[key] = _user[key] != null ? _user[key] : true;
        }
      });
      return _data != null ? _data : {};
    } else {
      print('No data in AppSettings');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Card(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text("Push notifikácie",
              style: Theme.of(context).textTheme.headline3),
          FutureBuilder<Map<Object, Object>>(
              future: _pushSettings, // function where you call your api
              builder: (BuildContext context,
                  AsyncSnapshot<Map<Object, Object>> snapshot) {
                if (snapshot.hasData) {
                  final _festivals = snapshot.data;
                  final _keys = _festivals.keys.toList();
                  return /*Text("Test");*/
                      Expanded(
                    child: ListView.builder(
                      itemCount: _keys != null ? _keys.length : 0,
                      itemBuilder: (BuildContext context, int index) {
                        String item = _keys[index].toString();
                        print(_festivals[item]);

                        return SwitchListTile(
                          title: Text(item),
                          subtitle: Text(
                              'Krátke správy o tom, že sa blíži predstavenie'),
                          secondary: Icon(Icons.notifications),
                          onChanged: (value) {
                            setState(() {
                              changeSubscription(item, value);
                            });
                          },
                          value: _festivals[item],
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return _buildLoadingScreen();
                }
              })
        ]),
      ),
      /* Card(
            child: Column(
              children: <Widget>[
                ListTile(
                  // A setting to change main festival in the app
                  title: Text('Vyberte si festival',
                      style: Theme.of(context).textTheme.headline6),
                ),
                RadioListTile(
                    // A setting to change main festival in the app
                    value: festivals.scenickazatva2022,
                    groupValue: selectedFestival,
                    onChanged: (value) {
                      setState(() {
                        selectedFestival = value;
                      });
                    },
                    title: Text('Scénická žatva 2022'),
                    subtitle: Text("30.8. - 4.9. 2022")),
                RadioListTile(
                  value: festivals['scenickazatva2022'],
                  groupValue: selectedFestival,
                  onChanged: (value) {
                    setState(() {
                      selectedFestival = value;
                      //_showMessageDialog(context);
                    });
                  },
                  title: Text('Tvorba 2022'),
                ),
                RadioListTile(
                  value: festivals['scenickazatva2022'],
                  groupValue: selectedFestival,
                  onChanged: (value) {
                    setState(() {
                      selectedFestival = value;
                      //_showMessageDialog(context);
                    });
                  },
                  title: Text('Belopotockého Mikuláš 2023'),
                ),
              ],
            ),
          )*/
    );
  }

  void changeSubscription(topic, value) async {
    final _uid = FirebaseAuth.instance.currentUser.uid;
    if (value == true) {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    } else {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    }

    DatabaseReference users = FirebaseDatabase.instance.ref("users/$_uid");
    users.update({
      "notifications/$topic": value,
    }).then((_) {
      _pushSettings = getPushSettings();
    });
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
