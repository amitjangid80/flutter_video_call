// Created by AMIT JANGID on 20/07/20.

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_video_call/main.dart';

class UserTypeBloc extends ChangeNotifier {
  bool _isDoctorApp;

  bool get isDoctorApp => _isDoctorApp;

  set isDoctorApp(bool value) {
    _isDoctorApp = value;

    if (isDoctorApp) {
      FirebaseMessaging().subscribeToTopic(doctorTopic);
    } else {
      FirebaseMessaging().subscribeToTopic(patientTopic);
    }

    notifyListeners();
  }
}
