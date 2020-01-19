import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    //START OF CUSTOM CHANNEL CODE HERE
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let filesApiChannel = FlutterMethodChannel(name: "com.exlyo.pocontacts/files",
                                               binaryMessenger: controller.binaryMessenger)
    filesApiChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "shareFileExternally" {
        self.shareFileExternally(call: call, result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    //END OF CUSTOM CHANNEL CODE HERE
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func shareFileExternally(call: FlutterMethodCall, result: FlutterResult) {
    guard let callArgs = call.arguments else {
      return
    }
    var filePath = ""
    if let callArgsCast = callArgs as? [String: Any] {
      filePath = callArgsCast["filePath"] as? String ?? ""
    } else {
      filePath = ""
    }
    if filePath == "" {
      result(nil)
      return
    }
    let fileURL = NSURL(fileURLWithPath: filePath)
    var fileURLs = [Any]()
    fileURLs.append(fileURL)
    let activityViewController = UIActivityViewController(activityItems: fileURLs, applicationActivities: nil)
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    controller.present(activityViewController, animated: true, completion: nil)
    result(nil)
  }
}
