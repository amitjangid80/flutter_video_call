import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_call/src/pages/index.dart';

final String topic = "/topics/videoCall";
final String fcmPath = "https://fcm.googleapis.com/fcm/";
final String serverKey = "key=AAAAETZEGIU:APA91bF4RqF0cXvh3lsVFAJCZT39PQuIcTkrcbgaMj5kfdrJoavaxa3HJElBkWv423WC5Wjo0hojm3JHi7eMlcANYaEjesSuNFFTrgwQofc5_dN2u8bQsS25WLIxGtiRud-4edCkDtde";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging().subscribeToTopic(topic);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doctor Video Call',
      home: IndexPage(),
      theme: ThemeData(primarySwatch: Colors.blue, buttonTheme: ButtonThemeData(height: 50)),
    );
  }
}
