
import 'flutter_trusted_device_platform_interface.dart';

class FazpassCd {
  static Future<String?> initialize(bool requirePin) {
    return FlutterTrustedDevicePlatform.instance.fazpassCdInitialize(requirePin);
  }

  static Future<void> onConfirm() {
    return FlutterTrustedDevicePlatform.instance.fazpassCdOnConfirm();
  }

  static Future<bool> onConfirmRequirePin(String pin) {
    return FlutterTrustedDevicePlatform.instance.fazpassCdOnConfirmRequirePin(pin);
  }

  static Future<void> onDecline() {
    return FlutterTrustedDevicePlatform.instance.fazpassCdOnDecline();
  }

  static Stream notificationListener() {
    return FlutterTrustedDevicePlatform.instance.fazpassCdListen();
  }
}