package com.amit.flutter_video_call;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import java.util.Random;

import io.flutter.plugin.common.MethodChannel;

public class MyFireBaseMessagingService extends FirebaseMessagingService
{
    private static final String TAG = MyFireBaseMessagingService.class.getSimpleName();

    private static String ADMIN_CHANNEL_ID = "admin_channel";

    @Override
    public void onNewToken(@NonNull String s)
    {
        super.onNewToken(s);
    }

    @Override
    public void onMessageReceived(@NonNull RemoteMessage remoteMessage)
    {
        super.onMessageReceived(remoteMessage);

        Intent intent = new Intent(this, MainActivity.class);
        intent.putExtra("receiveCall", "doctorCalling");

        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(this);
        int notificationId = new Random().nextInt(3000);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
        {
            createNotificationChannel(notificationManagerCompat);
        }

        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_ONE_SHOT);

        Bitmap largeIcon = BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher);
        Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE);

        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(this, ADMIN_CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setLargeIcon(largeIcon)
                .setContentTitle(remoteMessage.getData().get("title"))
                .setContentText(remoteMessage.getData().get("message"))
                .setSound(defaultSoundUri)
                .setContentIntent(pendingIntent)
                .setAutoCancel(true);

        notificationManagerCompat.notify(notificationId, mBuilder.build());

    }

    /*
     * 2018 October 03 - Wednesday - 09:49 AM
     * create notification channel method
     * <p>
     * this method will create notification channel id for sending notification
     **/
    @RequiresApi(api = Build.VERSION_CODES.O)
    private static void createNotificationChannel(NotificationManagerCompat notificationManagerCompat)
    {
        try
        {
            String channelName = "Call Notification";
            int importance = NotificationManager.IMPORTANCE_DEFAULT;
            String channelDescription = "This notification is for notifying when you get a call.";

            NotificationChannel channel = new NotificationChannel(ADMIN_CHANNEL_ID, channelName, importance);
            channel.enableLights(true);
            channel.enableVibration(true);
            channel.setLightColor(Color.RED);
            channel.setDescription(channelDescription);

            notificationManagerCompat.createNotificationChannel(channel);
        }
        catch (Exception e)
        {
            Log.e(TAG, "createNotificationChannel: exception while creating notification channel:");
            e.printStackTrace();
        }
    }
}
