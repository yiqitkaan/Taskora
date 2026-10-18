package com.yigitkaan.taskora_mobile

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.yigitkaan.taskora/storage"
        ).setMethodCallHandler { call, result ->
            val preferences = getSharedPreferences("taskora_storage", MODE_PRIVATE)
            val key = call.argument<String>("key")
            if (key == null) {
                result.error("INVALID_KEY", "Depolama anahtarı eksik.", null)
                return@setMethodCallHandler
            }

            when (call.method) {
                "read" -> result.success(preferences.getString(key, null))
                "write" -> {
                    val value = call.argument<String>("value")
                    if (value == null) {
                        result.error("INVALID_VALUE", "Kaydedilecek JSON eksik.", null)
                    } else {
                        preferences.edit().putString(key, value).apply()
                        result.success(null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
