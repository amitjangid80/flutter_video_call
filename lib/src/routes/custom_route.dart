// Created by AMIT JANGID on 06/07/20.

import 'package:flutter/material.dart';
import 'package:flutter_video_call/src/pages/call.dart';
import 'package:flutter_video_call/src/pages/index.dart';
import 'package:flutter_video_call/src/pages/main_page.dart';
import 'package:flutter_video_call/src/pages/receive.dart';
import 'package:flutter_video_call/src/routes/routes.dart';

class CustomRoute {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    final _arguments = settings.arguments;

    switch (settings.name) {
      case homeRoute:
        return NavigateTo(screenToNavigate: MainPage());

      case indexRoute:
        return NavigateTo(screenToNavigate: IndexPage());

      case callRoute:
        return NavigateTo(screenToNavigate: CallPage());

      case receiveRoute:
        return NavigateTo(screenToNavigate: ReceivePage());
    }

    return NavigateTo(screenToNavigate: MainPage());
  }
}

class NavigateTo<T> extends PageRouteBuilder<T> {
  BuildContext context;
  bool fullScreenDialog;
  Widget screenToNavigate;

  NavigateTo({this.fullScreenDialog: false, @required this.screenToNavigate})
      : super(
          fullscreenDialog: fullScreenDialog,
          transitionDuration: Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) => screenToNavigate,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // right to left screen transition
            return SlideTransition(
              transformHitTests: false,
              position: Tween<Offset>(end: Offset.zero, begin: Offset(1.0, 0.0)).animate(animation),
              child: SlideTransition(
                child: child,
                position: Tween<Offset>(begin: Offset.zero, end: Offset(-1.0, 0.0)).animate(secondaryAnimation),
              ),
            );
          },
        );
}
