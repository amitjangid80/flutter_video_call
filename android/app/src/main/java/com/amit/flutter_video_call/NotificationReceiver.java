package com.amit.flutter_video_call;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

/**
 * Created by AMIT JANGID on 16/07/20.
 **/
public class NotificationReceiver extends BroadcastReceiver
{
    private static final String TAG = NotificationReceiver.class.getSimpleName();

    @Override
    public void onReceive(Context context, Intent intent)
    {
        try
        {
            String callAction = intent.getStringExtra("callAction");
            Log.e(TAG, "onReceive: call action value is: " + callAction);

            if (callAction.equalsIgnoreCase("AcceptCall"))
            {
                Log.e(TAG, "onReceive: accept button was pressed");

                if (MyFireBaseMessagingService.ringtone.isPlaying())
                {
                    MyFireBaseMessagingService.ringtone.stop();
                }
            }

            if (callAction.equalsIgnoreCase("DeclineCall"))
            {
                Log.e(TAG, "onReceive: decline button was pressed");

                if (MyFireBaseMessagingService.ringtone.isPlaying())
                {
                    MyFireBaseMessagingService.ringtone.stop();
                }
            }
        }
        catch (Exception e)
        {
            Log.e(TAG, "onReceive: exception while playing ringtone:\n");
            e.printStackTrace();
        }
    }
}
