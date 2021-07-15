package com.isdenmois.remotecontrol.ui.files

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.isdenmois.remotecontrol.data.api.ApiService
import com.isdenmois.remotecontrol.data.model.RemoteFile
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.launch
import javax.inject.Inject

@HiltViewModel
class FilesViewModel @Inject constructor(
    private val apiService: ApiService
) : ViewModel() {
    private val _loading = MutableStateFlow<Boolean>(true)
    val loading: StateFlow<Boolean> get() = _loading

    private val _fileList = MutableStateFlow<List<RemoteFile>>(emptyList())
    val fileList: StateFlow<List<RemoteFile>> get() = _fileList

    private val _path = MutableStateFlow<List<String>>(emptyList())
    val path = _path.map {
        if (it.isEmpty()) return@map null

        it.joinToString("/")
    }

    init {
        fetchData()
    }

    fun fetchDirectory(name: String) {
        _path.value = _path.value + name

        fetchData()
    }

    fun openFile(file: RemoteFile) {
        viewModelScope.launch {
            apiService.openFile(file.path)
        }
    }

    fun up() {
        if (_path.value.isNotEmpty()) {
            _path.value = _path.value.dropLast(1)
            fetchData()
        }
    }

    private fun fetchData() {
        _loading.value = true
        _fileList.value = emptyList()

        viewModelScope.launch {
            try {
                val directory = path.first()
                val response = apiService.getFiles(directory)

                if (response.isSuccessful) {
                    _fileList.value = response.body()!!
                }
            } finally {
                _loading.value = false
            }
        }
    }
}
