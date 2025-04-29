import 'camera_plugin_platform_interface.dart';

class CameraPlugin {
  Future<String?> getPlatformVersion() {
    return CameraPluginPlatform.instance.getPlatformVersion();
  }

  static Future<void> openCamera() async {
    await CameraPluginPlatform.instance.openCamera();
  }
}
