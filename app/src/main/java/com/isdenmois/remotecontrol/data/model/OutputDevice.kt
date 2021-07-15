package com.isdenmois.remotecontrol.data.model

data class OutputDevice(
    val id: String,
    val title: String,
    val selected: Boolean,
)

data class Devices(
    val audio: List<OutputDevice>?,
    val displays: List<OutputDevice>?,
) {
    fun selectedAudio(): OutputDevice? = audio?.find { it.selected }
    fun selectedDisplay(): OutputDevice? = displays?.find { it.selected }
}
