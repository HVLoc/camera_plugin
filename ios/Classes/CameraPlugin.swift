import Flutter
import UIKit
import SwiftUI


public class CameraPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "camera_plugin", binaryMessenger: registrar.messenger())
    let instance = CameraPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "openCamera" {
            DispatchQueue.main.async {
                self.presentCameraView()
            }
            result(nil)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func presentCameraView() {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return }

        let cameraView = CameraView() // SwiftUI view bạn đã tạo
        let hostingController = UIHostingController(rootView: cameraView)
        hostingController.modalPresentationStyle = .fullScreen

        rootVC.present(hostingController, animated: true, completion: nil)
    }
}
