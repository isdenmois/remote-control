package com.isdenmois.remotecontrol.ui.buttongrid

import com.isdenmois.remotecontrol.R

open class ButtonModel (
    val icon: Int
)

class KeyButton (
    icon: Int,
    val key: String,
    val modifier: String? = null
) : ButtonModel(icon)

open class EventButton(icon: Int, val event: String, val params: Map<String, String>) : ButtonModel(icon)

class ConfirmButton(icon: Int, val message: String, event: String, params: Map<String, String>): EventButton(icon, event, params)

class FileButton() : ButtonModel(R.drawable.ic_folder_outline)
