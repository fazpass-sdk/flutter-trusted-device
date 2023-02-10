import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trusted_device/flutter_trusted_device.dart';
import 'package:flutter_trusted_device/flutter_trusted_device_platform_interface.dart';
import 'package:flutter_trusted_device/flutter_trusted_device_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterTrustedDevicePlatform
    with MockPlatformInterfaceMixin
    implements FlutterTrustedDevicePlatform {
  @override
  Future<String?> fazpassCdInitialize(bool requirePin) {
    // TODO: implement fazpassCdInitialize
    throw UnimplementedError();
  }

  @override
  Stream fazpassCdListen() {
    // TODO: implement fazpassCdListen
    throw UnimplementedError();
  }

  @override
  Future<void> fazpassCdOnConfirm() {
    // TODO: implement fazpassCdOnConfirm
    throw UnimplementedError();
  }

  @override
  Future<bool> fazpassCdOnConfirmRequirePin(String pin) {
    // TODO: implement fazpassCdOnConfirmRequirePin
    throw UnimplementedError();
  }

  @override
  Future<void> fazpassCdOnDecline() {
    // TODO: implement fazpassCdOnDecline
    throw UnimplementedError();
  }

  @override
  Future<FazpassTd> fazpassCheck(String email, String phone) {
    // TODO: implement fazpassCheck
    throw UnimplementedError();
  }

  @override
  Stream fazpassGenerateOtpByEmail(String email, String gateway) {
    // TODO: implement fazpassGenerateOtpByEmail
    throw UnimplementedError();
  }

  @override
  Stream fazpassGenerateOtpByPhone(String phone, String gateway) {
    // TODO: implement fazpassGenerateOtpByPhone
    throw UnimplementedError();
  }

  @override
  Future<bool> fazpassHEValidation(String phone, String gateway) {
    // TODO: implement fazpassHEValidation
    throw UnimplementedError();
  }

  @override
  Future<void> fazpassInitialize(String merchantKey, MODE mode) {
    // TODO: implement fazpassInitialize
    throw UnimplementedError();
  }

  @override
  Future<bool> fazpassRemoveDevice(String pin) {
    // TODO: implement fazpassRemoveDevice
    throw UnimplementedError();
  }

  @override
  Stream fazpassRequestOtpByEmail(String email, String gateway) {
    // TODO: implement fazpassRequestOtpByEmail
    throw UnimplementedError();
  }

  @override
  Stream fazpassRequestOtpByPhone(String phone, String gateway) {
    // TODO: implement fazpassRequestOtpByPhone
    throw UnimplementedError();
  }

  @override
  Future<void> fazpassRequestPermission() {
    // TODO: implement fazpassRequestPermission
    throw UnimplementedError();
  }

  @override
  Future<bool> fazpassTdEnrollByFinger(String pin) {
    // TODO: implement fazpassTdEnrollByFinger
    throw UnimplementedError();
  }

  @override
  Future<Result> fazpassTdEnrollByPin(String pin) {
    // TODO: implement fazpassTdEnrollByPin
    throw UnimplementedError();
  }

  @override
  Future<ValidateCrossDeviceResult> fazpassTdValidateCrossDevice(int timeout) {
    // TODO: implement fazpassTdValidateCrossDevice
    throw UnimplementedError();
  }

  @override
  Future<ValidateUserResult> fazpassTdValidateUser(String pin) {
    // TODO: implement fazpassTdValidateUser
    throw UnimplementedError();
  }

  @override
  Future<bool> fazpassValidateOtp(String otpId, String otp) {
    // TODO: implement fazpassValidateOtp
    throw UnimplementedError();
  }
}

void main() {
  final FlutterTrustedDevicePlatform initialPlatform = FlutterTrustedDevicePlatform.instance;

  test('$MethodChannelFlutterTrustedDevice is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterTrustedDevice>());
  });
}
