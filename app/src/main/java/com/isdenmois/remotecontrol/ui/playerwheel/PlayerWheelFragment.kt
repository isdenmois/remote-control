package com.isdenmois.remotecontrol.ui.playerwheel

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import com.isdenmois.remotecontrol.databinding.PlayerWheelFragmentBinding
import dagger.hilt.android.AndroidEntryPoint

@AndroidEntryPoint
class PlayerWheelFragment : Fragment() {
    private lateinit var binding: PlayerWheelFragmentBinding
    private val vm: PlayerWheelViewModel by viewModels()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,savedInstanceState: Bundle?): View {
        binding = PlayerWheelFragmentBinding.inflate(inflater, container, false)

        binding.buttonTop.setOnClickListener(vm)
        binding.buttonRight.setOnClickListener(vm)
        binding.buttonBottom.setOnClickListener(vm)
        binding.buttonLeft.setOnClickListener(vm)
        binding.buttonCenter.setOnClickListener(vm)

        return binding.root
    }
}
