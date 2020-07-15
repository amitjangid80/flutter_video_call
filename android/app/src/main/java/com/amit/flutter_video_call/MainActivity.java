package com.amit.flutter_video_call;

import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import com.amit.flutter_video_call.rest.ApiClient;
import com.amit.flutter_video_call.rest.ApiInterface;
import com.google.firebase.FirebaseApp;
import com.google.firebase.messaging.FirebaseMessaging;

import org.json.JSONObject;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class MainActivity extends FlutterActivity
{
    private static final String TAG = MainActivity.class.getSimpleName();
    private static final String METHOD_CHANNEL = "com.amit.flutter_video_call/videoCall";

    private static final String SERVER_KEY = "key=AAAAETZEGIU:APA91bF4RqF0cXvh3lsVFAJCZT39PQuIcTkrcbgaMj5kfdrJoavaxa3HJElBkWv423WC5Wjo0hojm3JHi7eMlcANYaEjesSuNFFTrgwQofc5_dN2u8bQsS25WLIxGtiRud-4edCkDtde";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine)
    {
        super.configureFlutterEngine(flutterEngine);

        Bundle myExtras = getIntent().getExtras();

        if (myExtras != null)
        {
            String receiveCall = myExtras.getString("receiveCall");

            if (receiveCall != null && receiveCall.equalsIgnoreCase("doctorCalling"))
            {
                new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL).invokeMethod("receiveCall", receiveCall);
            }
        }

        // FirebaseMessaging.getInstance().subscribeToTopic("/topics/videoCall");

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL).setMethodCallHandler((call, result) ->
        {
            if (call.method.equalsIgnoreCase("makeVideoCall"))
            {
                String callerName = call.argument("callerName").toString();
                makeVideoCall(callerName, result);
            }
        });
    }

    private void makeVideoCall(String callerName, MethodChannel.Result result)
    {
        try
        {
            String topic = "/topics/videoCall";

            JSONObject notification = new JSONObject();
            JSONObject notificationBody = new JSONObject();

            notificationBody.put("title", callerName);
            notificationBody.put("message", "Call from " + callerName);

            notification.put("to", topic);
            notification.put("data", notificationBody);

            Log.e(TAG, "makeVideoCall: notification json is: \n" + notification.toString());
            sendNotification(notification, result);
        }
        catch (Exception e)
        {
            Log.e(TAG, "makeVideoCall: exception while making video call and sending notification:\n");
            e.printStackTrace();
        }
    }

    private void sendNotification(JSONObject notification, MethodChannel.Result result)
    {
        try
        {
            ApiInterface apiService = ApiClient.getClient().create(ApiInterface.class);
            Call<String> sendNotification = apiService.sendNotification(SERVER_KEY, notification.toString());

            sendNotification.enqueue(new Callback<String>()
            {
                @Override
                public void onResponse(Call<String> call, Response<String> response)
                {
                    Log.e(TAG, "onResponse: response from server is: " + response);

                    if (response.body() != null && response.code() == 200)
                    {
                        Log.e(TAG, "onResponse: response body from sever is: " + response.body());
                        result.success("NotificationSent");
                    }
                }

                @Override
                public void onFailure(Call<String> call, Throwable t)
                {
                    Log.e(TAG, "onFailure: response error:");
                    t.printStackTrace();

                    result.error("400", "Notification not sent", t);
                }
            });
        }
        catch (Exception e)
        {
            Log.e(TAG, "sendNotification: exception while sending notification:\n");
            e.printStackTrace();
        }
    }
}
