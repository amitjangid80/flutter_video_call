// Created by AMIT JANGID on 17/07/20.

import 'package:flutter/material.dart';
import 'package:flutter_video_call/src/pages/index.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register App')),
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                elevation: 4,
                color: Colors.blueAccent,
                child: Text("Patient App", style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => IndexPage(isDoctorApp: false)),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: MaterialButton(
                  elevation: 4,
                  color: Colors.blueAccent,
                  child: Text("Doctor App", style: Theme.of(context).textTheme.title.copyWith(color: Colors.white)),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => IndexPage(isDoctorApp: true)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
