package com.isdenmois.remotecontrol.data.model

import com.squareup.moshi.Json

data class RemoteFile(
    val name: String,
    val path: String,
    @Json(name = "dir") val isDirectory: Boolean,
)
