// Created by AMIT JANGID on 16/07/20.

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_video_call/main.dart';

_getApiClient() {
  Dio _dio = Dio();

  _dio.options
    ..baseUrl = fcmPath
    ..connectTimeout = 40000 /* 40 seconds */
    ..receiveTimeout = 40000;

  _dio.interceptors.add(HeaderInterceptor());
  _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  return _dio;
}

// header interceptor class for applying headers to all api calls
class HeaderInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    options.contentType = "application/json";
    options.headers.addAll({'Authorization': serverKey});

    return options;
  }
}

class ApiService {
  static final Dio _dio = _getApiClient();

  static Future<void> sendNotification() async {
    try {
      var _notificationBody = {'title': 'Doctor', 'message': 'Call from Doctor'};
      var _notification = {'to': patientTopic, 'data': _notificationBody};
      var _response = await _dio.post('send', data: _notification);

      debugPrint('response from server is: $_response');
    } catch (e) {
      debugPrint('exception while sending notification: $e');
    }
  }
}
