import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_video_call/blocs/user_type_bloc.dart';
import 'package:flutter_video_call/src/pages/main_page.dart';
import 'package:flutter_video_call/src/routes/custom_route.dart';
import 'package:flutter_video_call/src/routes/routes.dart';
import 'package:permission_handler/permission_handler.dart';

final String callChannelName = 'testDoctor';
final String patientTopic = "/topics/videoCallPatient";
final String doctorTopic = "/topics/videoCallDoctorNew";
final String fcmPath = "https://fcm.googleapis.com/fcm/";
final String methodChannel = "com.amit.flutter_video_call/videoCall";

final String serverKey =
    "key=AAAAETZEGIU:APA91bF4RqF0cXvh3lsVFAJCZT39PQuIcTkrcbgaMj5kfdrJoavaxa3HJElBkWv423WC5Wjo0hojm3JHi7eMlcANYaEjesSuNFFTrgwQofc5_dN2u8bQsS25WLIxGtiRud-4edCkDtde";

void requestPermission() async {
  // requesting for permissions
  await [Permission.camera, Permission.microphone, Permission.phone].request();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // calling request permission method
  requestPermission();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserTypeBloc>.value(value: UserTypeBloc()),
      ],
      child: MaterialApp(
        home: MyApp(),
        initialRoute: homeRoute,
        title: 'Video Call Demo',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: CustomRoute.allRoutes,
        theme: ThemeData(primarySwatch: Colors.blue, buttonTheme: ButtonThemeData(height: 50)),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /*@override
  void initState() {
    super.initState();

    MethodChannel(methodChannel).setMethodCallHandler((call) async {
      debugPrint('call method invoked is: ${call.method.toString()}');
      debugPrint('call method invoked arguments are: ${call.arguments.toString()}');

      if (call.method.toString() == 'receiveCall') {
        debugPrint('call method invoked is matched, now it should navigate to call screen');

        await Navigator.pushNamed(context, receiveRoute);
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MainPage());
  }
}
