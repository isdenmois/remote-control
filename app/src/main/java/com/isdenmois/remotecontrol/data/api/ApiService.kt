package com.isdenmois.remotecontrol.data.api

import com.isdenmois.remotecontrol.data.model.Devices
import com.isdenmois.remotecontrol.data.model.RemoteFile
import retrofit2.Response
import retrofit2.http.*

interface ApiService {
    @POST("/keypress")
    suspend fun sendKeyPress(
        @Query("key") key: String,
        @Query("modifier") modifier: String? = null
    ): Response<String>

    @POST("/{event}")
    suspend fun sendEvent(
        @Path("event") event: String,
        @QueryMap() params: Map<String, String>
    )

    @GET("/files/list")
    suspend fun getFiles(
        @Query("dir") directory: String? = null
    ): Response<List<RemoteFile>>

    @POST("/files/open")
    suspend fun openFile(
        @Query("path") path: String
    )

    @GET("/devices")
    suspend fun getDevices(): Response<Devices>

    @POST("/set-audio")
    suspend fun setAudio(
        @Query("id") id: String
    ): Response<Devices>

    @POST("/set-display")
    suspend fun setDisplay(
        @Query("id") id: String
    ): Response<Devices>
}
