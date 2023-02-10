
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'flutter_trusted_device.dart';
import 'flutter_trusted_device_platform_interface.dart';

@protected
/// An implementation of [FlutterTrustedDevicePlatform] that uses method channels.
class MethodChannelFlutterTrustedDevice extends FlutterTrustedDevicePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_trusted_device');

  @visibleForTesting
  final eventChannel = const EventChannel('flutter_trusted_device_event');

  @visibleForTesting
  final cdNotifChannel = const EventChannel('flutter_trusted_device_cd_notification');

  @override
  Future<void> fazpassInitialize(String merchantKey, MODE mode) async {
    await methodChannel.invokeMethod('FazpassInitialize', {
      'merchant_key': merchantKey,
      'MODE': mode.name,
    });
  }

  @override
  Future<FazpassTd> fazpassCheck(String email, String phone) async {
    final result = await methodChannel.invokeMapMethod<String, String>('FazpassCheck', {
      'email': email,
      'phone': phone,
    });

    if (result != null) return FazpassTd(result['td_status']!, result['cd_status']!);
    throw PlatformException(code: 'fazzpass-err');
  }

  @override
  Future<Result> fazpassTdEnrollByPin(String pin) async {
    final result = await methodChannel.invokeMapMethod('FazpassTdEnrollByPin', {
      'pin': pin,
    });

    if (result != null) return Result(result['status'], result['message']);
    throw PlatformException(code: 'fazzpass-err');
  }

  @override
  Future<bool> fazpassTdEnrollByFinger(String pin) async {
    final result = await methodChannel.invokeMethod('FazpassTdEnrollByFinger', {
      'pin': pin,
    });

    if (result != null) return result;
    throw PlatformException(code: 'fazzpass-err');
  }

  @override
  Future<ValidateUserResult> fazpassTdValidateUser(String pin) async {
    final result = await methodChannel.invokeMapMethod('FazpassTdValidateUser', {
      'pin': pin,
    });

    if (result != null) return ValidateUserResult(result['status'], result['confidence_summary']);
    throw PlatformException(code: 'fazzpass-err');
  }

  @override
  Future<ValidateCrossDeviceResult> fazpassTdValidateCrossDevice(int timeout) async {
    final result = await methodChannel.invokeMapMethod('FazpassTdValidateCrossDevice', {
      'timeout': timeout,
    });

    if (result != null) return ValidateCrossDeviceResult(result['status'], result['device']);
    throw PlatformException(code: 'fazzpass-err');
  }

  @override
  Stream fazpassRequestOtpByPhone(String phone, String gateway) {
    return eventChannel.receiveBroadcastStream({
      'name': 'FazpassRequestOtpByPhone',
      'args': {
        'phone': phone,
        'gateway': gateway,
      },
    });
  }

  @override
  Stream fazpassRequestOtpByEmail(String email, String gateway) {
    return eventChannel.receiveBroadcastStream({
      'name': 'FazpassRequestOtpByEmail',
      'args': {
        'email': email,
        'gateway': gateway,
      },
    });
  }

  @override
  Stream fazpassGenerateOtpByPhone(String phone, String gateway) {
    return eventChannel.receiveBroadcastStream({
      'name': 'FazpassGenerateOtpByPhone',
      'args': {
        'phone': phone,
        'gateway': gateway,
      },
    });
  }

  @override
  Stream fazpassGenerateOtpByEmail(String email, String gateway) {
    return eventChannel.receiveBroadcastStream({
      'name': 'FazpassGenerateOtpByEmail',
      'args': {
        'email': email,
        'gateway': gateway,
      },
    });
  }

  @override
  Future<bool> fazpassHEValidation(String phone, String gateway) async {
    final result = await methodChannel.invokeMethod('FazpassHEValidation', {
      'phone': phone,
      'gateway': gateway,
    });

    if (result != null) return result;
    throw PlatformException(code: 'fazzpass-err');
  }

  @override
  Future<bool> fazpassValidateOtp(String otpId, String otp) async {
    final result = await methodChannel.invokeMethod('FazpassValidateOtp', {
      'otp_id': otpId,
      'otp': otp,
    });

    if (result != null) return result;
    throw PlatformException(code: 'fazzpass-err');
  }

  @override
  Future<bool> fazpassRemoveDevice(String pin) async {
    final result = await methodChannel.invokeMethod('FazpassRemoveDevice', {
      'pin': pin,
    });

    if (result != null) return result;
    throw PlatformException(code: 'fazzpass-err');
  }

  @override
  Future<void> fazpassRequestPermission() async {
    await methodChannel.invokeMethod('FazpassRequestPermission');
  }

  @override
  Stream fazpassCdListen() {
    return cdNotifChannel.receiveBroadcastStream();
  }

  @override
  Future<String?> fazpassCdInitialize(bool requirePin) async {
    final result = await methodChannel.invokeMethod('FazpassCdInitialize', {
      'require_pin': requirePin,
    });

    return result;
  }

  @override
  Future<void> fazpassCdOnConfirm() async {
    await methodChannel.invokeMethod('FazpassCdOnConfirm');
  }

  @override
  Future<bool> fazpassCdOnConfirmRequirePin(String pin) async {
    final result = await methodChannel.invokeMethod('FazpassCdOnConfirmRequirePin', {
      'pin': pin,
    });

    if (result != null) return result;
    throw PlatformException(code: 'fazzpass-err');
  }

  @override
  Future<void> fazpassCdOnDecline() async {
    await methodChannel.invokeMethod('FazpassCdOnDecline');
  }
}
