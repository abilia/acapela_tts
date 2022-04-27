package com.abilia.acapela_tts

import android.content.Context
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import com.abilia.acapela_tts.AcapelaTtsHandler.AcapelaLicense
import com.abilia.acapela_tts.AcapelaTtsHandler.OnTtsFinishedListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

/**
 * AcapelaTtsPlugin
 */
class AcapelaTtsPlugin : FlutterPlugin, MethodCallHandler {
    private var channel: MethodChannel? = null
    private lateinit var mAcapelaTts: AcapelaTtsHandler
    private var mLicense: AcapelaLicense? = null
    private var context: Context? = null
    private var initialized: Boolean = false

    companion object {
        private val TAG = AcapelaTtsPlugin::class.java.simpleName
        private const val VOICES_PATH = "/voices"
    }

    @RequiresApi(Build.VERSION_CODES.R)
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "acapela_tts")
        channel!!.setMethodCallHandler(this)
    }

    private fun setLicense(call: MethodCall) {
        mLicense = AcapelaLicense(
            userId = call.argument("userId")!!,
            password = call.argument("password")!!,
            license = call.argument("license")!!
        )
    }

    private fun initPlugin() {
        Log.d(javaClass.simpleName, "initialize plugin")
        assert(mLicense != null)

        mAcapelaTts = AcapelaTtsHandler(
            context,
            mLicense!!,
            context!!.filesDir.absolutePath + VOICES_PATH,
        )
        initialized = true
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setLicense" -> {
                setLicense(call)
                initPlugin()
                result.success(initialized)
            }
            "getPlatformVersion" -> result.success("Android " + Build.VERSION.RELEASE)
            "speak" -> mAcapelaTts.speak(call, result)
            "setVoice" -> mAcapelaTts.setVoice(call, result)
            "getAvailableVoices" -> result.success(mAcapelaTts.availableVoices)
            "setSpeechRate" -> mAcapelaTts.setSpeechRate(call, result)
            "getSpeechRate" -> result.success(mAcapelaTts.speechRate)
            "stop" -> mAcapelaTts.stop()
            "resume" -> mAcapelaTts.resume()
            "pause" -> mAcapelaTts.pause()
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel!!.setMethodCallHandler(null)
        mLicense = null
    }
}