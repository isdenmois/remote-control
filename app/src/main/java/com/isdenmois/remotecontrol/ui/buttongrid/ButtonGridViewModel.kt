package com.isdenmois.remotecontrol.ui.buttongrid

import android.util.Log
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.isdenmois.remotecontrol.R
import com.isdenmois.remotecontrol.data.api.ApiService
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject


@HiltViewModel
class ButtonGridViewModel @Inject constructor(
    private val apiService: ApiService
) : ViewModel() {
    private val _buttons = MutableStateFlow<List<List<ButtonModel>>>(emptyList())
    val buttons: StateFlow<List<List<ButtonModel>>> = _buttons

    private val _filesOpenFlow = MutableSharedFlow<Unit>(replay = 0)
    val filesOpenFlow: SharedFlow<Unit> = _filesOpenFlow

    private val _confirmFlow = MutableSharedFlow<ConfirmButton>(replay = 0)
    val confirm: SharedFlow<ConfirmButton> = _confirmFlow

    init {
        _buttons.value = listOf(
            listOf(
                ConfirmButton(R.drawable.ic_power_outline, "Shutdown?", "shutdown", emptyMap()),
                EventButton(R.drawable.ic_tv_outline, "displayswitch", mapOf("type" to "external")),
                EventButton(R.drawable.ic_desktop_outline, "displayswitch", mapOf("type" to "internal")),
            ),
            listOf(
                KeyButton(R.drawable.ic_sync_down_outline, ","),
                KeyButton(R.drawable.ic_sync_up_outline, "."),
                KeyButton(R.drawable.ic_logo_closed_captioning, "l", "alt"),
            ),
            listOf(
                KeyButton(R.drawable.ic_play_skip_back_outline, "pageup"),
                KeyButton(R.drawable.ic_expand_outline, "enter"),
                KeyButton(R.drawable.ic_play_skip_forward_outline, "pagedown"),
            ),
            listOf(
                FileButton()
            ),
        )
    }

    fun onClick(model: ButtonModel) {
        viewModelScope.launch {
            when (model) {
                is KeyButton -> sendKey(model)
                is ConfirmButton -> _confirmFlow.emit(model)
                is EventButton -> sendEvent(model)
                is FileButton -> _filesOpenFlow.emit(Unit)
            }
        }
    }

    fun dispatchEvent(event: EventButton) {
        viewModelScope.launch {
            sendEvent(event)
        }
    }

    private suspend fun sendKey(params: KeyButton) {
        try {
            apiService.sendKeyPress(params.key, params.modifier)
        } catch (e: Exception) {
            Log.d("ButtonGridViewModel", e.toString())
        }
    }

    private suspend fun sendEvent(params: EventButton) {
        try {
            apiService.sendEvent(params.event, params.params)
        } catch (e: Exception) {
            Log.d("ButtonGridViewModel", e.toString())
        }
    }
}
