package com.isdenmois.remotecontrol.ui

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.isdenmois.remotecontrol.data.api.ApiService
import com.isdenmois.remotecontrol.data.model.Devices
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class MainActivityViewModel @Inject constructor(
    private val apiService: ApiService
) : ViewModel() {
    val _devices = MutableStateFlow<Devices?>(null)
    val devices: StateFlow<Devices?> get() = _devices

    init {
        fetchDevices()
    }

    fun fetchDevices() {
        viewModelScope.launch {
            val response = apiService.getDevices()

            _devices.value = response.body()
        }
    }

    fun setDisplay(id: String) {
        val old = devices.value!!

        _devices.value = old.copy(
            displays = old.displays!!.map { it.copy(selected = it.id == id ) }
        )

        viewModelScope.launch {
            val response = apiService.setDisplay(id)

            _devices.value = response.body()
        }
    }

    fun setAudio(id: String) {
        val old = devices.value!!

        _devices.value = old.copy(
            audio = old.audio!!.map { it.copy(selected = it.id == id ) }
        )

        viewModelScope.launch {
            val response = apiService.setAudio(id)

            _devices.value = response.body()
        }
    }
}
