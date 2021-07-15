package com.isdenmois.remotecontrol.ui.files

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.Menu
import android.view.MenuInflater
import android.view.MenuItem
import android.view.View
import androidx.activity.viewModels
import androidx.lifecycle.lifecycleScope
import com.isdenmois.remotecontrol.R
import com.isdenmois.remotecontrol.databinding.ActivityFilesListBinding
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.filterNotNull
import kotlinx.coroutines.flow.firstOrNull

@AndroidEntryPoint
class FilesListActivity : AppCompatActivity() {
    private val vm: FilesViewModel by viewModels()
    private lateinit var binding: ActivityFilesListBinding

    private var fileMenu: Menu? = null
    private val adapter = FilesAdapter()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityFilesListBinding.inflate(layoutInflater)
        val view = binding.root
        setContentView(view)

        binding.list.adapter = adapter

        adapter.setOnClickListener {
            if (it.isDirectory) {
                vm.fetchDirectory(it.name)
            } else {
                vm.openFile(it)
            }
        }

        lifecycleScope.launchWhenResumed {
            vm.loading.collect {
                binding.progressBar.visibility = when(it) {
                    true -> View.VISIBLE
                    else -> View.GONE
                }
            }
        }

        lifecycleScope.launchWhenResumed {
            vm.fileList.collect {
                adapter.setList(it)
                Log.d("LIST", it.toString())
            }
        }

        lifecycleScope.launchWhenCreated {
            vm.path.collect {
                setButtonUpVisibility(it?.isNotEmpty() ?: false)
            }
        }
    }

    private fun setButtonUpVisibility(isVisible: Boolean) {
        if (fileMenu != null) {
            val itemUp = fileMenu!!.findItem(R.id.up)

            itemUp.isVisible = isVisible
        }
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        val inflater: MenuInflater = menuInflater
        inflater.inflate(R.menu.menu_files, menu)

        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle item selection
        return when (item.itemId) {
            R.id.up -> {
                vm.up()
                true
            }
            else -> super.onOptionsItemSelected(item)
        }
    }

    override fun onPrepareOptionsMenu(menu: Menu?): Boolean {
        fileMenu = menu
        return super.onPrepareOptionsMenu(menu)
    }
}
