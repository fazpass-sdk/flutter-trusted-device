
import 'flutter_trusted_device_platform_interface.dart';

class FlutterTrustedDevice {
  Future<String?> getPlatformVersion() {
    return FlutterTrustedDevicePlatform.instance.getPlatformVersion();
  }
}
