
import 'package:flutter/foundation.dart';

import 'flutter_trusted_device_platform_interface.dart';
import 'flutter_trusted_device.dart';

class FazpassTd {
  final TRUSTED_DEVICE_STATUS td_status;
  final CROSS_DEVICE_STATUS cd_status;

  @protected
  FazpassTd(String td, String cd)
      : td_status=TRUSTED_DEVICE_STATUS.values.singleWhere((element) => element.name==td),
        cd_status=CROSS_DEVICE_STATUS.values.singleWhere((element) => element.name==cd);

  Future<Result> enrollByPin(String pin) {
    return FlutterTrustedDevicePlatform.instance.fazpassTdEnrollByPin(pin);
  }

  Future<bool> enrollByFinger(String pin) {
    return FlutterTrustedDevicePlatform.instance.fazpassTdEnrollByFinger(pin);
  }

  Future<ValidateUserResult> validateUser(String pin) {
    return FlutterTrustedDevicePlatform.instance.fazpassTdValidateUser(pin);
  }

  Future<ValidateCrossDeviceResult> validateCrossDevice(int timeout) {
    return FlutterTrustedDevicePlatform.instance.fazpassTdValidateCrossDevice(timeout);
  }
}