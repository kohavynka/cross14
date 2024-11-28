package com.example.lab14

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method.equals("getNativeMessage")) {
                    result.success("Hi, Mom!")
                } else {
                    result.notImplemented()
                }
            }
    }

    companion object {
        private const val CHANNEL = "com.example.lab14/message"
    }
}
