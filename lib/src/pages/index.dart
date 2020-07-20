import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_video_call/blocs/user_type_bloc.dart';
import 'package:flutter_video_call/main.dart';
import 'package:flutter_video_call/src/rest/api_services.dart';
import 'package:flutter_video_call/src/routes/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  @override
  Widget build(BuildContext context) {
    UserTypeBloc _userTypeBloc = Provider.of<UserTypeBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Mumbai Clinic Demo')),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.person, size: 30, color: Colors.black),
              title: Text(
                !_userTypeBloc.isDoctorApp ? 'Doctor Name' : 'Patient Name',
                style: Theme.of(context).textTheme.title,
              ),
              trailing: _userTypeBloc.isDoctorApp
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

    // push video page with given channel name
    await Navigator.pushNamed(context, callRoute);
  }

  Future<void> _handleCameraAndMic() async {
    // requesting for storage permission
    await [Permission.camera, Permission.microphone, Permission.phone].request();
  }
}
