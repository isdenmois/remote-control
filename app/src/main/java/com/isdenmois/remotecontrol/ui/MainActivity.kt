package com.isdenmois.remotecontrol.ui

import android.os.Bundle
import androidx.activity.viewModels
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import com.isdenmois.remotecontrol.data.model.Devices
import com.isdenmois.remotecontrol.databinding.ActivityMainBinding
import com.isdenmois.remotecontrol.ui.selectoutputdialog.SelectOutputDialogFragment
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.flow.collect

@AndroidEntryPoint
class MainActivity : AppCompatActivity() {
    private val vm: MainActivityViewModel by viewModels()
    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        supportActionBar?.hide()

        binding = ActivityMainBinding.inflate(layoutInflater)

        binding.outputList?.setOnClickListener {
            showSelectOutputDialog()
        }

        lifecycleScope.launchWhenCreated {
            vm.devices.collect {
                binding.outputList?.text = getSelectedOutputs(it)
            }
        }

        setContentView(binding.root)
    }

    private fun showSelectOutputDialog() {
        SelectOutputDialogFragment.show(supportFragmentManager)
    }

    private fun getSelectedOutputs(devices: Devices?): String {
        if (devices == null) return "..."
        val display = devices.selectedDisplay()
        val audio = devices.selectedAudio()

        if (display != null && audio != null) {
            return "${display.title} (${audio.title})";
        }

        if (display != null) {
            return  display.title
        }

        return "???"
    }
}
