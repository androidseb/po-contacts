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
      if call.method == "getInboxFileId" {
      } else if call.method == "getInboxFileId" {
        result(nil)
      } else if call.method == "discardInboxFileId" {
        result(nil)
      } else if call.method == "getCopiedInboxFilePath" {
        result(nil)
      } else if call.method == "shareFileExternally" {
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })
    //END OF CUSTOM CHANNEL CODE HERE
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
