import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:scenickazatva_app/providers/AppSettings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class authService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  authService() {
    getFCMtoken();
    authFirebase();
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
}
