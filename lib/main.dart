import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:scenickazatva_app/pages/TabPage.dart';
import 'package:scenickazatva_app/providers/ArrangementProvider.dart';
import 'package:scenickazatva_app/providers/EventsProvider.dart';
import 'package:scenickazatva_app/providers/InfoProvider.dart';
import 'package:scenickazatva_app/providers/NewsProvider.dart';
import 'package:scenickazatva_app/providers/AppSettings.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
 // print("Notification shown!");
}

void authFirebase() async {
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    userData = userCredential;

    /* Log user login time */

  } on FirebaseAuthException catch (e) {
    /* Catch login errors */
    switch (e.code) {
      case "operation-not-allowed":
        print("Anonymous auth hasn't been enabled for this project.");
        break;
      default:
        print("Firebase Auth FAILED: " + e.code);
    }
  }
}

Future<String> getFCMtoken() async{
  FirebaseMessaging _messaging;
  _messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await _messaging.requestPermission(
    alert: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: false,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission: ${settings.authorizationStatus}');
  } else {
    print('User declined or has not accepted permission');
  }

  final fcmToken = await _messaging.getToken();
  return fcmToken;
}


void main() async {
  //if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
    WidgetsFlutterBinding.ensureInitialized();

    /*if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await authFirebase();
    } else {
      await Firebase.app();
      await authFirebase();
    }*/

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await authFirebase();

    FirebaseAuth.instance.idTokenChanges().listen((User user) async{
      if (user == null) {
        print('User is currently signed out! We cannot get data');
      } else {
        print('User is signed in with UID: '+user.uid);
        var _uid = user.uid;
        if(!kIsWeb){FirebaseDatabase.instance.setPersistenceEnabled(true);}
        final fcmToken = await getFCMtoken();

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
         //   print("Firebase save success");
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
  /*} else {
    // Some web specific code there
    // https://stackoverflow.com/questions/58459483/unsupported-operation-platform-operatingsystem
  }*/

  initializeDateFormatting('sk_SK').then((_) => runApp(MyApp()));
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
