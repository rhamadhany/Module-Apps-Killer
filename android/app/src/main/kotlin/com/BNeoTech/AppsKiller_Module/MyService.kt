package com.BNeoTech.AppsKiller_Module

import android.app.Service
import android.content.Intent
import android.os.IBinder
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel

class MyService : Service() {
    companion object {
        private const val channel = "com.BNeoTech.AppsKiller_Module.channelService"
        private const val TAG = "MyService"
    }

    private var flutterEngine: FlutterEngine? = null
    private var methodChannel: MethodChannel? = null
    override fun onCreate() {
        super.onCreate()
        flutterEngine =
                FlutterEngine(this).apply {
                    dartExecutor.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
                }
        methodChannel = MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, channel)
    }

    override fun onBind(p0: Intent): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        sendToDart()
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        flutterEngine?.destroy()
        flutterEngine = null
        methodChannel = null
    }

    private fun sendToDart() {
        methodChannel?.invokeMethod(
                "fromService",
                null,
        )
    }
}
