package com.isdenmois.remotecontrol.ui.playerwheel

import android.util.Log
import android.view.View
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.isdenmois.remotecontrol.R
import com.isdenmois.remotecontrol.data.api.ApiService
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.lang.Exception
import javax.inject.Inject

@HiltViewModel
class PlayerWheelViewModel @Inject constructor(private val apiService: ApiService) : ViewModel(), View.OnClickListener {
    private fun sendKey(key: String) {
        viewModelScope.launch(Dispatchers.IO) {
            try {
                apiService.sendKeyPress(key)
            } catch (e: Exception) {
                Log.d("PlayerWheelViewModel", e.toString())
            }
        }
    }

    override fun onClick(view: View) {
        when (view.id) {
            R.id.buttonTop -> sendKey("audio_vol_up")
            R.id.buttonRight -> sendKey("right")
            R.id.buttonBottom -> sendKey("audio_vol_down")
            R.id.buttonLeft -> sendKey("left")
            R.id.buttonCenter -> sendKey("space")
        }
    }
}
