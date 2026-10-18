import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    guard let registrar = engineBridge.pluginRegistry.registrar(
      forPlugin: "TaskoraStorage"
    ) else {
      return
    }
    let channel = FlutterMethodChannel(
      name: "com.yigitkaan.taskora/storage",
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      guard let arguments = call.arguments as? [String: Any],
            let key = arguments["key"] as? String else {
        result(FlutterError(
          code: "INVALID_KEY",
          message: "Depolama anahtarı eksik.",
          details: nil
        ))
        return
      }

      switch call.method {
      case "read":
        result(UserDefaults.standard.string(forKey: key))
      case "write":
        guard let value = arguments["value"] as? String else {
          result(FlutterError(
            code: "INVALID_VALUE",
            message: "Kaydedilecek JSON eksik.",
            details: nil
          ))
          return
        }
        UserDefaults.standard.set(value, forKey: key)
        result(nil as Any?)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
