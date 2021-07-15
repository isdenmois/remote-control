package com.isdenmois.remotecontrol.ui.buttongrid

import android.content.DialogInterface
import android.content.Intent
import android.os.Bundle
import android.util.TypedValue
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import android.widget.LinearLayout
import android.widget.LinearLayout.LayoutParams
import androidx.appcompat.app.AlertDialog
import androidx.core.content.res.ResourcesCompat
import androidx.fragment.app.Fragment
import androidx.fragment.app.viewModels
import androidx.lifecycle.lifecycleScope
import com.isdenmois.remotecontrol.R
import com.isdenmois.remotecontrol.databinding.ButtonGridFragmentBinding
import com.isdenmois.remotecontrol.ui.files.FilesListActivity
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.flow.collect


@AndroidEntryPoint
class ButtonGridFragment : Fragment() {
    private val vm: ButtonGridViewModel by viewModels()
    private lateinit var binding: ButtonGridFragmentBinding

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        binding = ButtonGridFragmentBinding.inflate(inflater, container, false)

        lifecycleScope.launchWhenStarted {
            vm.buttons.collect {
                setButtons(it)
            }
        }

        lifecycleScope.launchWhenStarted {
            vm.filesOpenFlow.collect {
                openFiles()
            }
        }

        lifecycleScope.launchWhenStarted {
            vm.confirm.collect {
                confirm(it)
            }
        }

        return binding.root
    }

    private fun openFiles() {
        val intent = Intent(context, FilesListActivity::class.java)

        startActivity(intent)
    }

    private fun setButtons(grid: List<List<ButtonModel>>) {
        binding.root.removeAllViews()
        val ctx = requireContext()
        val theme = ctx.theme
        val res = resources
        val width = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 80f, resources.displayMetrics).toInt()
        val height = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 50f, resources.displayMetrics).toInt()

        val buttonParams = LayoutParams(width, height)
        val spacerParams = LayoutParams(0, 0).apply {
            weight = 1f
        }

        grid.forEach { list ->
            val layout = LinearLayout(ctx)
            layout.orientation = LinearLayout.HORIZONTAL

            list.forEach { model ->
                val button = ImageButton(ctx).apply {
                    setOnClickListener {
                        vm.onClick(model)
                    }

                    setImageDrawable(ResourcesCompat.getDrawable(res, model.icon, theme))
                    layoutParams = buttonParams
                }

                layout.addView(View(ctx).apply {
                    layoutParams = spacerParams
                })
                layout.addView(button)
                layout.addView(View(ctx).apply {
                    layoutParams = spacerParams
                })
            }

            binding.root.addView(layout)
        }
    }

    private fun confirm(params: ConfirmButton) {
        val listener = DialogInterface.OnClickListener { _, which ->
            when (which) {
                DialogInterface.BUTTON_POSITIVE -> vm.dispatchEvent(params)
            }
        }

        AlertDialog.Builder(requireContext())
            .setMessage(params.message)
            .setPositiveButton(R.string.yes, listener)
            .setNegativeButton(R.string.no, listener)
            .show()
    }
}
