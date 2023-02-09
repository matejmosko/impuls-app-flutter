import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

//import 'package:scenickazatva_app/providers/AppSettings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';

class UserData {
  final String id;
  final String name;
  final String profileImageUrl;
  final String email;
  final String bio;

  UserData({
    this.id,
    this.name,
    this.profileImageUrl,
    this.email,
    this.bio
  });
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final bool _running = true;


  @override
  void initState() {
    super.initState();

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

  Stream<Map<Object, Object>> _pushStream() async* {
    while (_running) {
      Map<Object, Object> _data = await getPushSettings();
      yield _data;
    }
  }

  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
            onPressed: () {
              context.go("/");
            }
        ),
        title: Text(
          "Scénická žatva 100",
        ),
      ),
      body: Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text("Konto", style: Theme.of(context).textTheme.displaySmall),
          Flexible( child: Container(
            child:
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              // If the user is already signed-in, use it as initial data
              initialData: FirebaseAuth.instance.currentUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data;
                  if (user.isAnonymous){
                  return SignInScreen(
                    providers: providers,
                    actions: [
                      AuthStateChangeAction<SignedIn>((context, state) {
                        Navigator.pushReplacementNamed(context, '/profile');
                      }),
                    ],
                  );
                  } else {
                    return ProfileScreen(
                      providers: providers,
                      actions: [
                        SignedOutAction((context) {
                           Navigator.pushReplacementNamed(context, '/sign-in'); // FIXME here
                        }),
                      ],
                      children: [
                        Text("User defined content"),
                      ],
                    );
                  }
                } else return null;
                // Render your application if authenticated

              },
            ),
          ),
          ),
            Text("Push notifikácie",
                style: Theme.of(context).textTheme.displaySmall),
            Text(
                'Push notifikácie sú krátke správy o tom, že sa blíži predstavenie, ktoré sa zobrazujú medzi upozorneniami. Vyberte si tie podujatia, o ktorých chcete dostávať upozornenia.'),
            /*StreamBuilder(
                stream: _pushStream(),
                builder:
                    (context, AsyncSnapshot<Map<Object, Object>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingScreen();
                  }
                  if (snapshot.hasData) {
                    // bool x;
                    final _festivals = snapshot.data;
                    final _keys = _festivals.keys.toList();
                    return Flexible(
                      fit: FlexFit.tight,
                      child: ListView.builder(
                        itemCount: _keys != null ? _keys.length : 0,
                        itemBuilder: (BuildContext context, int index) {
                          String item = _keys[index].toString();
                          return SwitchListTile(
                            title: Text(item),
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
                  } else {
                    return _buildLoadingScreen();
                  }
                }),*/
          ]),
        ),
      ),
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
    }).then((_) {});
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
