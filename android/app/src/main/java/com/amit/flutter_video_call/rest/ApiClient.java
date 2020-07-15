package com.amit.flutter_video_call.rest;

import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import retrofit2.converter.scalars.ScalarsConverterFactory;

/**
 * Created by AMIT JANGID on 15/07/20.
 **/
public class ApiClient
{
    private static final String CONTENT_TYPE = "application/json";
    private static final String FCM_API_PATH = "https://fcm.googleapis.com/fcm/";
    private static final String SERVER_KEY = "key=AAAAETZEGIU:APA91bF4RqF0cXvh3lsVFAJCZT39PQuIcTkrcbgaMj5kfdrJoavaxa3HJElBkWv423WC5Wjo0hojm3JHi7eMlcANYaEjesSuNFFTrgwQofc5_dN2u8bQsS25WLIxGtiRud-4edCkDtde";

    private static Retrofit retrofit = null;

    public static Retrofit getClient()
    {
        if (retrofit == null)
        {
            OkHttpClient client = new OkHttpClient.Builder()
                    .connectTimeout(40, TimeUnit.SECONDS)
                    .readTimeout(40, TimeUnit.SECONDS)
                    .retryOnConnectionFailure(true)
                    .build();

            retrofit = new Retrofit.Builder()
                    .baseUrl(FCM_API_PATH)
                    .addConverterFactory(ScalarsConverterFactory.create())
                    .addConverterFactory(GsonConverterFactory.create())
                    .client(client)
                    .build();
        }

        return retrofit;
    }
}
