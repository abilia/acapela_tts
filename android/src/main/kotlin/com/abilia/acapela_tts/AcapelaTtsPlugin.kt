package com.abilia.acapela_tts

import android.content.Context
import android.util.Log
import com.abilia.acapela_tts.AcapelaTtsHandler.AcapelaLicense
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/** AcapelaTtsPlugin */
class AcapelaTtsPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var mAcapelaTts: AcapelaTtsHandler
    private lateinit var context: Context

    companion object {
        private val TAG = AcapelaTtsPlugin::class.java.simpleName
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "acapela_tts")
        channel.setMethodCallHandler(this)
    }

    private fun initPlugin(call: MethodCall) {
        val license =
            AcapelaLicense(
                userId = call.argument("userId")!!,
                password = call.argument("password")!!,
                license = call.argument("license")!!
            )
        val voicesPath = call.argument<String>("voicesPath")!!
        Log.d(javaClass.simpleName, "initialize plugin")
        mAcapelaTts =
            AcapelaTtsHandler(
                context,
                license,
                voicesPath,
            )
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "initialize" -> {
                initPlugin(call)
                result.success(true)
            }
            "speak" -> mAcapelaTts.speak(call, result)
            "setVoice" -> mAcapelaTts.setVoice(call, result)
            "getAvailableVoices" -> result.success(mAcapelaTts.downloadedVoices)
            "setSpeechRate" -> mAcapelaTts.setSpeechRate(call, result)
            "getSpeechRate" -> result.success(mAcapelaTts.speechRate)
            "stop" -> mAcapelaTts.stop()
            "resume" -> mAcapelaTts.resume()
            "pause" -> mAcapelaTts.pause()
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
