package com.isdenmois.remotecontrol.ui.selectoutputdialog

import android.app.AlertDialog
import android.app.Dialog
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.activityViewModels
import androidx.lifecycle.lifecycleScope
import com.isdenmois.remotecontrol.databinding.FragmentSelectOutputBinding
import com.isdenmois.remotecontrol.ui.MainActivityViewModel
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.flow.collect

@AndroidEntryPoint
class SelectOutputDialogFragment : DialogFragment() {
    private val vm: MainActivityViewModel by activityViewModels()
    private lateinit var binding: FragmentSelectOutputBinding
    private val displayAdapter = OutputAdapter()
    private val audioAdapter = OutputAdapter()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = FragmentSelectOutputBinding.inflate(inflater, container, false)
        binding.displayList.adapter = displayAdapter
        binding.audioList.adapter = audioAdapter

        vm.fetchDevices()

        lifecycleScope.launchWhenCreated {
            vm.devices.collect {
                displayAdapter.setList(it?.displays ?: emptyList())
                audioAdapter.setList(it?.audio ?: emptyList())
            }
        }

        displayAdapter.setOnClickListener {
            vm.setDisplay(it.id)
        }

        audioAdapter.setOnClickListener {
            vm.setAudio(it.id)
        }

        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
    }

    companion object {
        fun show(manager: FragmentManager) {
            SelectOutputDialogFragment().show(manager, "SelectOutputDialogFragment")
        }
    }
}
