package com.isdenmois.remotecontrol.ui.selectoutputdialog

import android.graphics.Typeface
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.isdenmois.remotecontrol.R
import com.isdenmois.remotecontrol.data.model.OutputDevice
import com.isdenmois.remotecontrol.databinding.OutputDeviceItemBinding

typealias OnOutputClick = (output: OutputDevice) -> Unit

class OutputAdapter: RecyclerView.Adapter<OutputAdapter.ViewHolder>() {
    private var deviceList: List<OutputDevice> = emptyList()
    private var listener: OnOutputClick? = null

    fun setList(list: List<OutputDevice>) {
        deviceList = list
        notifyDataSetChanged()
    }

    fun setOnClickListener(listener: OnOutputClick) {
        this.listener = listener
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = OutputDeviceItemBinding.inflate(LayoutInflater.from(parent.context), parent, false)

        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, i: Int) {
        holder.bind(deviceList[i])
    }

    override fun getItemCount() = deviceList.size

    inner class ViewHolder(val binding: OutputDeviceItemBinding) : RecyclerView.ViewHolder(binding.root) {
        fun bind(device: OutputDevice) {
            binding.title.text = device.title
            binding.title.setTypeface(null, if (device.selected) Typeface.BOLD else Typeface.NORMAL)
            binding.check.visibility = if (device.selected) View.VISIBLE else View.GONE
            binding.root.setOnClickListener {
                listener?.invoke(device)
            }
        }

        private fun getDrawable(isDirectory: Boolean): Int {
            return if (isDirectory) R.drawable.ic_folder_outline else R.drawable.ic_file_outline
        }
    }
}