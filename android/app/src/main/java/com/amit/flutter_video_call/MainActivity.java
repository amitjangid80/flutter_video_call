package com.amit.flutter_video_call;

import android.content.Intent;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationManagerCompat;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity
{
    private static final String TAG = MainActivity.class.getSimpleName();
    // public static final String METHOD_CHANNEL = "com.amit.flutter_video_call/videoCall";

    public static FlutterEngine mFlutterEngine;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine)
    {
        super.configureFlutterEngine(flutterEngine);
        mFlutterEngine = flutterEngine;
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent)
    {
        super.onNewIntent(intent);
        Log.e(TAG, "onNewIntent: on new intent method called");

        String action = intent.getAction();
        FlutterEngine flutterEngine = getFlutterEngine();

        // Log.e(TAG, "onNewIntent: intent action name is: " + action);
        // new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), METHOD_CHANNEL).invokeMethod("receiveCall", action);

        boolean routeIntent = action != null && action.equalsIgnoreCase("openCallScreen");

        if (routeIntent && flutterEngine != null)
        {
            Log.e(TAG, "onNewIntent: navigation to call page started");
            flutterEngine.getNavigationChannel().pushRoute("receivePage");

            NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(this);
            notificationManagerCompat.cancel(MyFireBaseMessagingService.notificationId);

            if (MyFireBaseMessagingService.ringtone.isPlaying())
            {
                MyFireBaseMessagingService.ringtone.stop();
            }
        }
    }

    /*private void makeVideoCall(String callerName, MethodChannel.Result result)
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
                public void onResponse(@NonNull Call<String> call, @NonNull Response<String> response)
                {
                    Log.e(TAG, "onResponse: response from server is: " + response);

                    if (response.body() != null && response.code() == 200)
                    {
                        Log.e(TAG, "onResponse: response body from sever is: " + response.body());
                        result.success("NotificationSent");
                    }
                }

                @Override
                public void onFailure(@NonNull Call<String> call, @NonNull Throwable t)
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
    }*/
}
