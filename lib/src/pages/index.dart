import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_call/src/pages/receive.dart';
import 'package:permission_handler/permission_handler.dart';
import './call.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agora Flutter QuickStart')),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
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
                textColor: Colors.white,
                color: Colors.blueAccent,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReceivePage())),
                child: Text('Receive', style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onJoin() async {
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();

    // push video page with given channel name
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CallPage(channelName: 'doctor', role: ClientRole.Broadcaster)),
    );
  }

  Future<void> _handleCameraAndMic() async {
    // requesting for storage permission
    await [Permission.camera, Permission.microphone, Permission.phone].request();
  }
}
