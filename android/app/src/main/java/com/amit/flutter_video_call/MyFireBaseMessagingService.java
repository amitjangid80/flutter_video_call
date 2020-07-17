package com.amit.flutter_video_call;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.media.Ringtone;
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

public class MyFireBaseMessagingService extends FirebaseMessagingService
{
    private static final String TAG = MyFireBaseMessagingService.class.getSimpleName();

    public static Ringtone ringtone;
    public static int notificationId;
    private static String ADMIN_CHANNEL_ID = "flutterActionNotification";

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
        intent.setAction("openCallPage");
        intent.putExtra("receiveCall", "doctorCalling");

        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(this);
        notificationId = new Random().nextInt(3000);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
        {
            createNotificationChannel(notificationManagerCompat);
        }

        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_ONE_SHOT);

        Intent acceptBtnBroadCastIntent = new Intent(this, NotificationReceiver.class);
        acceptBtnBroadCastIntent.putExtra("callAction", "AcceptCall");

        PendingIntent acceptBtnActionIntent = PendingIntent.getBroadcast(this,
                1, acceptBtnBroadCastIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        Intent declineBtnBroadCastIntent = new Intent(this, NotificationReceiver.class);
        declineBtnBroadCastIntent.putExtra("callAction", "DeclineCall");

        PendingIntent declineBtnActionIntent = PendingIntent.getBroadcast(this,
                2, declineBtnBroadCastIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        Bitmap largeIcon = BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher);

        Uri defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE);
        ringtone = RingtoneManager.getRingtone(this, defaultSoundUri);
        ringtone.play();

        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(this, ADMIN_CHANNEL_ID)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setLargeIcon(largeIcon)
                .setContentTitle(remoteMessage.getData().get("title"))
                .setContentText(remoteMessage.getData().get("message"))
                .setContentIntent(pendingIntent)
                .setSound(null)
                .addAction(R.mipmap.ic_launcher, "Accept", acceptBtnActionIntent)
                .addAction(R.mipmap.ic_launcher, "Decline", declineBtnActionIntent)
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
