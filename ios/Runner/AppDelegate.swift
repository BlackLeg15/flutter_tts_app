import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var synthesizer: AVSpeechSynthesizer?
  private var textToSpeechChannel: FlutterMethodChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    initializeTextToSpeechService()
    initializeTextToSpeechChannel()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func initializeTextToSpeechService() {
    synthesizer = AVSpeechSynthesizer()
  }

  private func initializeTextToSpeechChannel() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      print("Erro: não foi possível acessar o FlutterViewController")
      return
    }

    textToSpeechChannel = FlutterMethodChannel(
      name: "flutter_text_to_speech_channel",
      binaryMessenger: controller.binaryMessenger
    )

    textToSpeechChannel?.setMethodCallHandler(handleMethodCall)
  }

  private func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "speak" {
      let text = call.arguments as? String
      let isTextNotEmpty = text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
      if let validText = text, isTextNotEmpty {
        let utterance = AVSpeechUtterance(string: validText)
        utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        synthesizer?.speak(utterance)
        result(nil)
      } else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "O texto passado está vazio ou nulo.", details: nil))
      }
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}
