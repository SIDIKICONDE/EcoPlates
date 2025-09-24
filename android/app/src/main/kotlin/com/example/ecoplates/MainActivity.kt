package com.example.ecoplates

import android.app.PictureInPictureParams
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "app.ecoplates/pip").setMethodCallHandler { call, result ->
            when (call.method) {
                "enterPictureInPicture" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        val width = (call.argument<Int>("width") ?: 16).coerceAtLeast(1)
                        val height = (call.argument<Int>("height") ?: 9).coerceAtLeast(1)
                        val params = PictureInPictureParams.Builder()
                            .setAspectRatio(Rational(width, height))
                            .build()
                        enterPictureInPictureMode(params)
                        result.success(true)
                    } else {
                        result.error("UNSUPPORTED", "PiP requires Android O+", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
