package com.isdenmois.remotecontrol.ui.files

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.isdenmois.remotecontrol.R
import com.isdenmois.remotecontrol.data.model.RemoteFile
import com.isdenmois.remotecontrol.databinding.FileItemBinding

typealias OnFileClick = (file: RemoteFile) -> Unit

class FilesAdapter : RecyclerView.Adapter<FilesAdapter.ViewHolder>() {
    private var fileList: List<RemoteFile> = emptyList()
    private var listener: OnFileClick? = null

    fun setList(list: List<RemoteFile>) {
        fileList = list
        notifyDataSetChanged()
    }

    fun setOnClickListener(listener: OnFileClick) {
        this.listener = listener
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val binding = FileItemBinding.inflate(LayoutInflater.from(parent.context), parent, false)

        return ViewHolder(binding)
    }

    override fun onBindViewHolder(holder: ViewHolder, i: Int) {
        holder.bind(fileList[i])
    }

    override fun getItemCount() = fileList.size

    inner class ViewHolder(val binding: FileItemBinding) : RecyclerView.ViewHolder(binding.root) {
        fun bind(file: RemoteFile) {
            binding.icon.setImageResource(getDrawable(file.isDirectory))
            binding.name.text = file.name
            binding.root.setOnClickListener {
                listener?.invoke(file)
            }
        }

        private fun getDrawable(isDirectory: Boolean): Int {
            return if (isDirectory) R.drawable.ic_folder_outline else R.drawable.ic_file_outline
        }
    }
}
