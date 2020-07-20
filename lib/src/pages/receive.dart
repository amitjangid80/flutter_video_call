// Created by AMIT JANGID on 08/06/20.

import 'package:flutter/material.dart';
import 'package:flutter_video_call/main.dart';
import 'package:flutter_video_call/src/routes/routes.dart';
import 'package:permission_handler/permission_handler.dart';

class ReceivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.amberAccent.withOpacity(0.5),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Container(child: Text('Doctor Calling...', style: Theme.of(context).textTheme.headline3)),
              ),
            ),
            SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: 'Answer',
                      backgroundColor: Colors.green,
                      onPressed: () => onJoin(context),
                      child: Icon(Icons.phone, size: 30),
                    ),
                    FloatingActionButton(
                      heroTag: 'Decline',
                      backgroundColor: Colors.red,
                      onPressed: () => Navigator.pop(context),
                      child: Icon(Icons.phonelink_erase, size: 30),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onJoin(BuildContext context) async {
    // await for camera and mic permissions before pushing video page
    await _handleCameraAndMic();

    // push video page with given channel name
    await Navigator.pushReplacementNamed(context, callRoute);
  }

  Future<void> _handleCameraAndMic() async {
    // requesting for storage permission
    await [Permission.camera, Permission.microphone, Permission.phone].request();
  }
}
