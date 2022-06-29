import 'package:flutter/material.dart';
import 'package:impuls/pages/TabPage.dart';
import 'package:impuls/providers/AppSettings.dart';
import 'package:impuls/providers/ArrangementProvider.dart';
import 'package:impuls/providers/EventsProvider.dart';
import 'package:impuls/providers/InfoProvider.dart';
import 'package:impuls/providers/NewsProvider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'dart:io' show Platform;


void main() async{
  if(Platform.isAndroid||Platform.isIOS) {
    WidgetsFlutterBinding.ensureInitialized();
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      await Firebase.app();
    }

    try {
      final userCredential =
      await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("ERROR: "+e.code);
      }
    }

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }


  initializeDateFormatting().then((_) => runApp(MyApp()));
  //runApp(MyApp());
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
      ],
      child: MaterialApp(
        title: "Scénická žatva 100",
        theme: ThemeData(
          // Define the default brightness and colors.
          //brightness: Brightness.dark,
          primaryColor: Colors.black,
          //cardColor: Colors.white,

          // Define the default font family.
          fontFamily: 'Arial',

          appBarTheme: AppBarTheme(
              backgroundColor: Colors.black87,
            foregroundColor: Color(0xffdf9f4a),
          ),

          // Define the default `TextTheme`. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            headline2: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),
            bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ).apply(
            bodyColor: Colors.black87,
            displayColor: Color(0xffdf9f4a),
          ),
        ),
          debugShowCheckedModeBanner: false,
          home: TabPage(),
        ),
    );
  }
}
