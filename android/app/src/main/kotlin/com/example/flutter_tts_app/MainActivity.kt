package com.example.flutter_tts_app

import android.content.Context
import android.speech.tts.TextToSpeech
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity : FlutterActivity(), MethodChannel.MethodCallHandler {

    private lateinit var textToSpeechChannel: MethodChannel
    private lateinit var textToSpeechService: TextToSpeech

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        initializeTextToSpeechChannel(flutterEngine.dartExecutor.binaryMessenger)
        initializeTextToSpeechService(applicationContext)
    }

    private fun initializeTextToSpeechChannel(binaryMessenger: BinaryMessenger) {
        textToSpeechChannel = MethodChannel(
            binaryMessenger, "flutter_text_to_speech_channel"
        )
        textToSpeechChannel.setMethodCallHandler(this)
    }

    private fun initializeTextToSpeechService(context: Context) {
        textToSpeechService = TextToSpeech(context) {
            if (it == TextToSpeech.SUCCESS) {
                textToSpeechService.setLanguage(Locale.forLanguageTag("BR"))
            }
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (call.method == "speak") {
            val text = call.arguments<String>()
            if (text.isNullOrBlank()) {
                result.error(
                    "INVALID_ARGUMENT",
                    "O texto passado está vazio ou nulo.",
                    null // detalhes adicionais (pode ser um Map, por exemplo)
                )
                return
            }
            textToSpeechService.speak(text, TextToSpeech.QUEUE_FLUSH, null, null)
            result.success(null)
        } else {
            result.notImplemented()
        }
    }
}
