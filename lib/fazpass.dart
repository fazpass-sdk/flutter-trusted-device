
import 'flutter_trusted_device_platform_interface.dart';
import 'flutter_trusted_device.dart';

class Fazpass {
  static Future<void> initialize(String merchantKey, MODE mode) {
    return FlutterTrustedDevicePlatform.instance.fazpassInitialize(merchantKey, mode);
  }

  static Future<FazpassTd> check(String email, String phone) async {
    return FlutterTrustedDevicePlatform.instance.fazpassCheck(email, phone);
  }

  static void requestOtpByPhone(String phone, String gateway,
      Function(RequestOtpResult) onSuccess, {
      Function(String)? onIncomingMessage,
      Function(dynamic)? onError,
    }) {
    FlutterTrustedDevicePlatform.instance.fazpassRequestOtpByPhone(phone, gateway).listen(
      (result) {
        if (result is String) {
          if (onIncomingMessage != null) {
            onIncomingMessage(result);
          }
        } else {
          onSuccess(RequestOtpResult(result['status'], result['message'], result['otp_id']));
        }
      },
      onError: onError,
      cancelOnError: true,
    );
  }

  static void requestOtpByEmail(String email, String gateway,
      Function(RequestOtpResult) onSuccess, {
      Function(String)? onIncomingMessage,
      Function(dynamic)? onError,
    }) {
    FlutterTrustedDevicePlatform.instance.fazpassRequestOtpByEmail(email, gateway).listen(
      (result) {
        if (result is String) {
          if (onIncomingMessage != null) {
            onIncomingMessage(result);
          }
        } else {
          onSuccess(RequestOtpResult(result['status'], result['message'], result['otp_id']));
        }
      },
      onError: onError,
      cancelOnError: true,
    );
  }

  static void generateOtpByPhone(String phone, String gateway,
      Function(RequestOtpResult) onSuccess, {
      Function(String)? onIncomingMessage,
      Function(dynamic)? onError,
    }) {
    FlutterTrustedDevicePlatform.instance.fazpassGenerateOtpByPhone(phone, gateway).listen(
      (result) {
        if (result is String) {
          if (onIncomingMessage != null) {
            onIncomingMessage(result);
          }
        } else {
          onSuccess(RequestOtpResult(result['status'], result['message'], result['otp_id']));
        }
      },
      onError: onError,
      cancelOnError: true,
    );
  }

  static void generateOtpByEmail(String email, String gateway,
      Function(RequestOtpResult) onSuccess, {
      Function(String)? onIncomingMessage,
      Function(dynamic)? onError,
    }) {
    FlutterTrustedDevicePlatform.instance.fazpassGenerateOtpByEmail(email, gateway).listen(
      (result) {
        if (result is String) {
          if (onIncomingMessage != null) {
            onIncomingMessage(result);
          }
        } else {
          onSuccess(RequestOtpResult(result['status'], result['message'], result['otp_id']));
        }
      },
      onError: onError,
      cancelOnError: true,
    );
  }

  static Future<bool> validateOtp(String otpId, String otp) {
    return FlutterTrustedDevicePlatform.instance.fazpassValidateOtp(otpId, otp);
  }

  static Future<bool> heValidation(String phone, String gateway) {
    return FlutterTrustedDevicePlatform.instance.fazpassHEValidation(phone, gateway);
  }

  static Future<bool> removeDevice(String pin) {
    return FlutterTrustedDevicePlatform.instance.fazpassRemoveDevice(pin);
  }

  static Future<void> requestPermission() {
    return FlutterTrustedDevicePlatform.instance.fazpassRequestPermission();
  }
}