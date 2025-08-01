import Flutter
import UIKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate {
  let synthesizer = AVSpeechSynthesizer()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let textToSpeechChannel = FlutterMethodChannel(name: "flutter_tts_native", binaryMessenger: controller.binaryMessenger)
    textToSpeechChannel.setMethodCallHandler(handler);

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "speak" {
      let text = call.arguments as? String
      let isTextNotEmpty = text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
      if let validText = text, isTextNotEmpty {
        let utterance = AVSpeechUtterance(string: validText)
        utterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        synthesizer.speak(utterance)
        result(nil)
      } else {
        result(FlutterError(code: "INVALID_ARGS", message: "Expected text", details: nil))
      }
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
}
