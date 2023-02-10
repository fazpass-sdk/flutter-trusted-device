import 'package:flutter/material.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_trusted_device.dart';
import 'flutter_trusted_device_method_channel.dart';

@protected
abstract class FlutterTrustedDevicePlatform extends PlatformInterface {
  /// Constructs a FlutterTrustedDevicePlatform.
  FlutterTrustedDevicePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTrustedDevicePlatform _instance = MethodChannelFlutterTrustedDevice();

  /// The default instance of [FlutterTrustedDevicePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterTrustedDevice].
  static FlutterTrustedDevicePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterTrustedDevicePlatform] when
  /// they register themselves.
  static set instance(FlutterTrustedDevicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> fazpassInitialize(String merchantKey, MODE mode);
  Future<FazpassTd> fazpassCheck(String email, String phone);
  Stream fazpassRequestOtpByPhone(String phone, String gateway);
  Stream fazpassRequestOtpByEmail(String email, String gateway);
  Stream fazpassGenerateOtpByPhone(String phone, String gateway);
  Stream fazpassGenerateOtpByEmail(String email, String gateway);
  Future<bool> fazpassValidateOtp(String otpId, String otp);
  Future<bool> fazpassHEValidation(String phone, String gateway);
  Future<bool> fazpassRemoveDevice(String pin);
  Future<Result> fazpassTdEnrollByPin(String pin);
  Future<bool> fazpassTdEnrollByFinger(String pin);
  Future<ValidateUserResult> fazpassTdValidateUser(String pin);
  Future<ValidateCrossDeviceResult> fazpassTdValidateCrossDevice(int timeout);
  Future<void> fazpassRequestPermission();
  Future<String?> fazpassCdInitialize(bool requirePin);
  Future<void> fazpassCdOnConfirm();
  Future<bool> fazpassCdOnConfirmRequirePin(String pin);
  Future<void> fazpassCdOnDecline();
  Stream fazpassCdListen();
}
