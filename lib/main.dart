import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:scenickazatva_app/requests/auth_service.dart';

import 'package:scenickazatva_app/providers/ArrangementProvider.dart';
import 'package:scenickazatva_app/providers/EventsProvider.dart';
import 'package:scenickazatva_app/providers/InfoProvider.dart';
import 'package:scenickazatva_app/providers/NewsProvider.dart';
import 'package:scenickazatva_app/providers/LocationProvider.dart';
import 'package:scenickazatva_app/pages/SettingsPage.dart';
import 'package:scenickazatva_app/pages/TabPage.dart';
import 'package:scenickazatva_app/pages/EventDetailPage.dart';
import 'package:scenickazatva_app/pages/NewsDetailPage.dart';
import 'package:scenickazatva_app/pages/EventEditPage.dart';
import 'package:scenickazatva_app/pages/InfoDetailPage.dart';

import 'package:scenickazatva_app/models/ColorScheme.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => TabPage(initialIndex: 1),
      routes: [
        GoRoute(
            path: 'news',
            builder: (context, state) => TabPage(initialIndex: 0),
            routes: [
              GoRoute(
                path: ':newsId',
                builder: (context, state) =>
                    NewsDetailPage(newsId: state.params["newsId"]),
              ),
            ]
        ),
        GoRoute(
            path: 'events',
            builder: (context, state) => TabPage(initialIndex: 1),
            routes: [

              GoRoute(
                path: ':eventId',
                builder: (context, state) =>
                    EventDetailPage(eventId: state.params["eventId"]),
              ),
              GoRoute(
                path: ':eventId/edit',
                builder: (context, state) =>
                    EventEditPage(eventId: state.params["eventId"]),
              ),
            ]
        ),
        GoRoute(
            path: 'info',
            builder: (context, state) => TabPage(initialIndex: 2),
            routes: [
              GoRoute(
                path: ':infoId',
                builder: (context, state) =>
                    InfoDetailPage(infoId: state.params["infoId"]),
              )]
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) => SettingsPage(),
        ),
        GoRoute(
          path: 'user',
          builder: (context, state) => SettingsPage(),
        ),]
    ),
  ],
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print("Notification shown!");
}

void main() async {
  //if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android) {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await authService().authFirebase();

  FirebaseAuth.instance.idTokenChanges().listen((User? user) async {
    if (user == null) {
      print('User is currently signed out! We cannot get data');
    } else {
      print('User is signed in with UID: ' + user.uid);
      var fcmToken = "";
      if (!kIsWeb) {
        FirebaseDatabase.instance.setPersistenceEnabled(true);
        fcmToken = await authService().getFCMtoken();
      }

      /*final Map<String, Object> initialSettings = {
        "timestamp": DateTime.now().toString(),
        "fcmtoken": fcmToken != null ? fcmToken : "",
        "id": user.uid,
      };*/

      var userSettings = await authService().getUserData(user);

        userSettings.timestamp = DateTime.now().toString();
      userSettings.fcmtoken = fcmToken;
      userSettings.id = user.uid;
/*
      DatabaseReference festivals =
          await FirebaseDatabase.instance.ref("appsettings/festivals");
      var _uid = user.uid;

      festivals.onValue.listen((DatabaseEvent event) async {
        DatabaseReference _usersdb =
            FirebaseDatabase.instance.ref("users/$_uid/notifications");
        final _users = await _usersdb.get();
        print(_users.value);
        final _currentUser = (_users.value as Map);

        final data = (event.snapshot.value as Map);
        final _notifications = {};

        data.forEach((key, value) {
          _notifications[key] = _currentUser != null ? _currentUser[key] : true;

        });

        userSettings.notifications = _notifications;

        FirebaseDatabase.instance
            .ref("users/" + user.uid)
            .update(userSettings.toJson())
            .then((_) {
          //   print("Firebase save success");
        }).catchError((error) {
          print(error);
        });
      });*/
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
        ChangeNotifierProvider<LocationProvider>.value(
          value: LocationProvider(),
        ),

      ],
      child: MaterialApp.router(
        title: "TVOR•BA 2023",
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
            fontFamily: 'Hind',
            appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(color: lightColor),
                backgroundColor: accentColor,
                foregroundColor: lightColor
            ),
            navigationBarTheme: NavigationBarThemeData(
              labelTextStyle: MaterialStateProperty.all(TextStyle(color: Colors.white)),
            ),
            textTheme: TextTheme(
              displayLarge: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                //color: accentColor
              ),
              displayMedium: TextStyle(
                fontSize: 18.0,
                fontStyle: FontStyle.italic,
                //color: accentColor
              ),
              displaySmall: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                //color: darkColor
              ),
              titleLarge: TextStyle(
                fontSize: 19.0,
                //fontWeight: FontWeight.bold,
                //    color: accentColor
              ),
              bodyLarge: TextStyle(
                fontSize: 14.0, fontFamily: 'Hind',
                //    color: darkColor
              ),
              bodyMedium: TextStyle(
                fontSize: 14.0, fontFamily: 'Hind',
                //color: darkColor
              ),
            )),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        /*theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: accentColor,
            fontFamily: 'Hind',/*
            appBarTheme: AppBarTheme(
              backgroundColor: darkColor,
              foregroundColor: accentColor,
            )*/

            // Define the default `TextTheme`. Use this to specify the default
            // text styling for headlines, titles, bodies of text, and more.
            textTheme: TextTheme(
              displayLarge: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  //color: accentColor
     ),
              displayMedium: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                  //color: accentColor
     ),
              displaySmall: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  //color: darkColor
    ),
              titleLarge: TextStyle(
                  fontSize: 19.0,
                  //fontWeight: FontWeight.bold,
              //    color: accentColor
              ),
              bodyLarge: TextStyle(
                  fontSize: 14.0, fontFamily: 'Hind',
              //    color: darkColor
              ),
              bodyMedium: TextStyle(
                  fontSize: 14.0, fontFamily: 'Hind',
                  //color: darkColor
    ),

            )),*/
        debugShowCheckedModeBanner: false,
        //home: TabPage(),
        routerConfig: _router,
      ),
    );
  }
}
