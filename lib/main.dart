import 'package:flutter/material.dart';
import 'package:scenickazatva_app/pages/TabPage.dart';
import 'package:scenickazatva_app/providers/ArrangementProvider.dart';
import 'package:scenickazatva_app/providers/EventsProvider.dart';
import 'package:scenickazatva_app/providers/InfoProvider.dart';
import 'package:scenickazatva_app/providers/NewsProvider.dart';
//import 'package:scenickazatva_app/providers/AppSettings.dart';
import 'package:scenickazatva_app/requests/auth_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart'; // imported for firebase messaging to log events

import 'dart:io' show Platform;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Notification shown!");
}



void main() async {
  if (Platform.isAndroid || Platform.isIOS) {
    WidgetsFlutterBinding.ensureInitialized();

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await authService().authFirebase();
    } else {
      await Firebase.app();
      await authService().authFirebase();
    }

    FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    FirebaseAuth.instance.idTokenChanges().listen((User user) async{
      if (user == null) {
        print('User is currently signed out! We cannot get data');
      } else {
        print('User is signed in with UID: '+user.uid);
        var _uid = user.uid;
        FirebaseDatabase.instance.setPersistenceEnabled(true);
        final fcmToken = await authService().getFCMtoken();

        final Map<String, Object> userSettings = {
          "timestamp": DateTime.now().toString(),
          "fcmtoken": fcmToken != null ? fcmToken : "",
        };

        DatabaseReference festivals = await FirebaseDatabase.instance.ref("appsettings/festivals");

        festivals.onValue.listen((DatabaseEvent event) async{
          DatabaseReference _usersdb = FirebaseDatabase.instance.ref("users/$_uid/notifications");
          final _users = await _usersdb.get();
          final _currentUser = (_users.value as Map);


          final data = (event.snapshot.value as Map);
          final _notifications = {};

            data.forEach((key, value) {
              if (_currentUser !=null) {
              _notifications[key] =
              _currentUser[key] != null ? _currentUser[key] : true;
              } else {
                _notifications[key] =
                true;
              }
            });

          userSettings["notifications"] = _notifications;

          FirebaseDatabase.instance.ref("users/"+user.uid).update(userSettings).then((_) {
            print("Firebase save success");
          }).catchError((error) {
            print(error);
          });
        });


      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
      print("Token changed: $fcmToken");
    }).onError((err) {
      // Error getting token.
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color darkColor = Colors.black87;
    Color lightColor = Colors.white;
    Color accentColor = Color(0xffdf9f4a);

    return MultiProvider(
      providers: [
        /*ChangeNotifierProvider<ColorProvider>.value(
          value: ColorProvider(),
        ),*/
        ChangeNotifierProvider<NewsProvider>.value(
          value: NewsProvider(),
        ),
        ChangeNotifierProvider<EventsProvider>.value(
          value: EventsProvider(),
        ),
        ChangeNotifierProvider<InfoProvider>.value(
          value: InfoProvider(),
        ),
        ChangeNotifierProvider<ArrangementProvider>.value(
          value: ArrangementProvider(),
        ),
      ],
      child: MaterialApp(
        title: "Scénická žatva 100",
        theme: ThemeData(
            scaffoldBackgroundColor: lightColor,
            primaryColor: darkColor,
            backgroundColor: lightColor,
            dividerColor: Colors.grey,
            cardColor: lightColor,
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: accentColor),
            fontFamily: 'Hind',
            appBarTheme: AppBarTheme(
              backgroundColor: darkColor,
              foregroundColor: accentColor,
            ),

            // Define the default `TextTheme`. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: TextTheme(
              headline1: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: accentColor),
              headline2: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  color: accentColor),
              headline3: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: darkColor),
              headline6: TextStyle(
                  fontSize: 19.0,
                  //fontWeight: FontWeight.bold,
                  color: accentColor),
              bodyText1: TextStyle(
                  fontSize: 14.0, fontFamily: 'Hind', color: lightColor),
              bodyText2: TextStyle(
                  fontSize: 14.0, fontFamily: 'Hind', color: darkColor),
            )),
        debugShowCheckedModeBanner: false,
        home: TabPage(),
      ),
    );
  }
}
