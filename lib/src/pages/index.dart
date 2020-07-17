import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_call/main.dart';
import 'package:flutter_video_call/src/pages/receive.dart';
import 'package:flutter_video_call/src/rest/api_services.dart';
import 'package:permission_handler/permission_handler.dart';

class IndexPage extends StatefulWidget {
  final bool isDoctorApp;

  IndexPage({@required this.isDoctorApp});

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  @override
  void initState() {
    super.initState();

    // calling register app method
    _registerApp();
  }

  _registerApp() async {
    if (widget.isDoctorApp) {
      FirebaseMessaging().subscribeToTopic(doctorTopic);
    } else {
      FirebaseMessaging().subscribeToTopic(patientTopic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agora Flutter QuickStart')),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person, size: 30, color: Colors.black),
              title: Text(
                !widget.isDoctorApp ? 'Doctor Name' : 'Patient Name',
                style: Theme.of(context).textTheme.title,
              ),
              trailing: widget.isDoctorApp
                  ? IconButton(
                      iconSize: 30,
                      onPressed: () => onJoin(),
                      icon: Icon(Icons.videocam, color: Colors.black),
                    )
                  : null,
            ),
            Divider(),
            /*Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                elevation: 4,
                onPressed: onJoin,
                textColor: Colors.white,
                color: Colors.blueAccent,
                child: Text('Call', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                elevation: 4,
                textColor: Colors.white,
                color: Colors.blueAccent,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReceivePage())),
                child: Text('Receive', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();

    // calling send notification method
    await ApiService.sendNotification();

    /*// push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CallPage(channelName: 'doctor', role: ClientRole.Broadcaster)),
    );*/
  }

  Future<void> _handleCameraAndMic() async {
    // requesting for storage permission
    await [Permission.camera, Permission.microphone, Permission.phone].request();
  }
}
