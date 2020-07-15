package com.amit.flutter_video_call.rest;

import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.Header;
import retrofit2.http.Headers;
import retrofit2.http.POST;

/**
 * Created by AMIT JANGID on 15/07/20.
 **/
public interface ApiInterface
{
    @Headers({"Accept: application/json", "Content-Type: application/json"})
    @POST("send")
    Call<String> sendNotification(@Header("Authorization") String serverKey, @Body String jsonObject);
}
