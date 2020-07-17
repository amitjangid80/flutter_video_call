import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_call/src/pages/call.dart';
import 'package:flutter_video_call/src/pages/main_page.dart';
import 'package:permission_handler/permission_handler.dart';

final String patientTopic = "/topics/videoCall";
final String doctorTopic = "/topics/videoCallDoctor";
final String fcmPath = "https://fcm.googleapis.com/fcm/";
final String methodChannel = "com.amit.flutter_video_call/videoCall";
final String serverKey =
    "key=AAAAETZEGIU:APA91bF4RqF0cXvh3lsVFAJCZT39PQuIcTkrcbgaMj5kfdrJoavaxa3HJElBkWv423WC5Wjo0hojm3JHi7eMlcANYaEjesSuNFFTrgwQofc5_dN2u8bQsS25WLIxGtiRud-4edCkDtde";

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      home: MyApp(),
      title: 'Doctor Video Call',
      theme: ThemeData(primarySwatch: Colors.blue, buttonTheme: ButtonThemeData(height: 50)),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    MethodChannel(methodChannel).setMethodCallHandler((call) async {
      debugPrint('call method invoked is: ${call.method.toString()}');
      debugPrint('call method invoked arguments are: ${call.arguments.toString()}');

      if (call.method.toString() == 'receiveCall') {
        debugPrint('call method invoked is matched, now it should navigate to call screen');

        // requesting for storage permission
        await [Permission.camera, Permission.microphone, Permission.phone].request();

        // push video page with given channel name
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CallPage(channelName: 'doctor', role: ClientRole.Broadcaster)),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MainPage());
  }
}
