package com.isden.remote_control

import android.graphics.Color
import android.os.Build
import android.view.View
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    val CHANNEL = "flutter.native/helper";

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, _ ->
            if (call.method == "changeNavigationBarColor") {
                val color = call.argument<String>("color");
                val dark = call.argument<Boolean>("dark") ?: false;

                if (color != null) {
                    changeNavigationBarColor(color, dark)
                }
            }
        }
    }

    private fun changeNavigationBarColor(color: String, dark: Boolean) {
        var flags = window.decorView.systemUiVisibility

        flags = if (dark) {
            flags and View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR.inv()
        } else {
            flags or View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            window.navigationBarColor = Color.parseColor(color)
        }
        window.decorView.systemUiVisibility = flags
    }
}
