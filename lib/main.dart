import 'package:flutter/material.dart';
import 'package:scenickazatva_app/pages/TabPage.dart';
import 'package:scenickazatva_app/providers/ArrangementProvider.dart';
import 'package:scenickazatva_app/providers/EventsProvider.dart';
import 'package:scenickazatva_app/providers/InfoProvider.dart';
import 'package:scenickazatva_app/providers/NewsProvider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart'; // imported for firebase messaging to log events
import 'firebase_options.dart';
import 'dart:io' show Platform;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void initializeFirebase() async{
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.app();
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
  if (Platform.isAndroid || Platform.isIOS) {
    WidgetsFlutterBinding.ensureInitialized();
    await initializeFirebase();
    final fcmToken = getFCMtoken().toString();
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    print(analytics);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();

      /* Log user login time */

      DatabaseReference auth_log = FirebaseDatabase.instance.ref("auth_log");

      await auth_log.update({
        userCredential.user.uid + "/timestamp": DateTime.now().toString(),
        userCredential.user.uid + "/notifications": fcmToken != null ? fcmToken : ""
      });
    } on FirebaseAuthException catch (e) {
      /* Catch login errors */
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("ERROR: " + e.code);
      }
    }

    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {

      // Note: This callback is fired at each app startup and whenever a new
      // token is generated.
      print("Token changed");
    }).onError((err) {
      // Error getting token.
    });

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
