package com.amit.flutter_video_call;

import com.google.firebase.FirebaseApp;

import io.flutter.app.FlutterApplication;

/**
 * Created by AMIT JANGID on 15/07/20.
 **/
public class VideoCallApplication extends FlutterApplication
{
    @Override
    public void onCreate()
    {
        super.onCreate();

        FirebaseApp.initializeApp(this);
    }
}
