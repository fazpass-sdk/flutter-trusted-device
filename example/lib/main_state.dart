
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trusted_device/flutter_trusted_device.dart';

import 'main.dart';

abstract class MyAppState extends State<MyApp> {
  static const merchantKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZGVudGlmaWVyIjo0fQ.WEV3bCizw9U_hxRC6DxHOzZthuJXRE8ziI3b6bHUpEI';
  static const miscallGatewayKey = '595ea55e-95d2-4ec4-969e-910de41585a0';
  static const smsGatewayKey = '1e1de010-71b2-47d6-a037-254182ff3696';
  static const emailGatewayKey = '26cb8e5f-5332-46ba-a43e-ed2fc5a51d7c';
  static const waGatewayKey = 'c73fbaac-cce8-4cad-af0e-afd040a8f7e2';
  static const waLongGatewayKey = 'c73fbaac-cce8-4cad-af0e-afd040a8f7e2';
  static const heGatewayKey = '6cb0b024-9721-4243-9010-fd9e386157ec';
  static const mode = MODE.STAGING;
  static const pin = '1234p';

  final scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final userController = TextEditingController();
  final otpController = TextEditingController();

  String get phone => userController.text;
  String get email => userController.text;

  final reqMiscallNotifier = ValueNotifier<String?>(null);
  final genMiscallNotifier = ValueNotifier<String?>(null);
  final reqSmsNotifier = ValueNotifier<String?>(null);
  final genSmsNotifier = ValueNotifier<String?>(null);
  final reqEmailNotifier = ValueNotifier<String?>(null);
  final genEmailNotifier = ValueNotifier<String?>(null);
  final reqWaNotifier = ValueNotifier<String?>(null);
  final genWaNotifier = ValueNotifier<String?>(null);
  final reqWaLongNotifier = ValueNotifier<String?>(null);
  final genWaLongNotifier = ValueNotifier<String?>(null);

  FazpassTd? _fazpassTd;
  String? _lastOtpId;

  Future<void> fInit() async {
    await Fazpass.requestPermission();
    await Fazpass.initialize(merchantKey, mode);
    await fCdInit();
  }

  Future<FazpassTd> fCheck() async {
    if (userController.text.contains('@')) {
      _fazpassTd = await Fazpass.check(email, '');
      return _fazpassTd!;
    } else {
      _fazpassTd = await Fazpass.check('', phone);
      return _fazpassTd!;
    }
  }

  void fReqMiscall() {
    reqMiscallNotifier.value = '';
    Fazpass.requestOtpByPhone(phone, miscallGatewayKey,
      (result) {
        _lastOtpId = result.otpId;
        reqMiscallNotifier.value = 'otpId: ${result.otpId} | message: ${result.message} | status: ${result.status}';
      },
      onIncomingMessage: (otp) {
        reqMiscallNotifier.value = '${reqMiscallNotifier.value}\notp: $otp';
      },
      onError: (err) {
        reqMiscallNotifier.value = '${reqMiscallNotifier.value}\n${err.toString()}';
      },
    );
  }

  void fGenMiscall() {
    genMiscallNotifier.value = '';
    Fazpass.generateOtpByPhone(phone, miscallGatewayKey,
      (result) {
        _lastOtpId = result.otpId;
        genMiscallNotifier.value = 'otpId: ${result.otpId} | message: ${result.message} | status: ${result.status}';
      },
      onIncomingMessage: (otp) {
        genMiscallNotifier.value = '${genMiscallNotifier.value}\notp: $otp';
      },
      onError: (err) {
        genMiscallNotifier.value = '${genMiscallNotifier.value}\n${err.toString()}';
      },
    );
  }

  void fReqSms() {
    reqSmsNotifier.value = '';
    Fazpass.requestOtpByPhone(phone, smsGatewayKey,
      (result) {
        _lastOtpId = result.otpId;
        reqSmsNotifier.value = 'otpId: ${result.otpId} | message: ${result.message} | status: ${result.status}';
      },
      onIncomingMessage: (otp) {
        reqSmsNotifier.value = '${reqSmsNotifier.value}\notp: $otp';
      },
      onError: (err) {
        reqSmsNotifier.value = '${reqSmsNotifier.value}\n${err.toString()}';
      },
    );
  }

  void fGenSms() {
    genSmsNotifier.value = '';
    Fazpass.generateOtpByPhone(phone, smsGatewayKey,
      (result) {
        _lastOtpId = result.otpId;
        genSmsNotifier.value = 'otpId: ${result.otpId} | message: ${result.message} | status: ${result.status}';
      },
      onIncomingMessage: (otp) {
        genSmsNotifier.value = '${genSmsNotifier.value}\notp: $otp';
      },
      onError: (err) {
        genSmsNotifier.value = '${genSmsNotifier.value}\n${err.toString()}';
      },
    );
  }

  void fReqEmail() {
    reqEmailNotifier.value = '';
    Fazpass.requestOtpByEmail(email, emailGatewayKey,
      (result) {
        _lastOtpId = result.otpId;
        reqEmailNotifier.value = 'otpId: ${result.otpId} | message: ${result.message} | status: ${result.status}';
      },
      onError: (err) {
        reqEmailNotifier.value = '${reqEmailNotifier.value}\n${err.toString()}';
      },
    );
  }

  void fGenEmail() {
    genEmailNotifier.value = '';
    Fazpass.generateOtpByEmail(email, emailGatewayKey,
      (result) {
        _lastOtpId = result.otpId;
        genEmailNotifier.value = 'otpId: ${result.otpId} | message: ${result.message} | status: ${result.status}';
      },
      onError: (err) {
        genEmailNotifier.value = '${genEmailNotifier.value}\n${err.toString()}';
      },
    );
  }

  void fReqWa() {
    reqWaNotifier.value = '';
    Fazpass.requestOtpByPhone(phone, waGatewayKey,
      (result) {
        _lastOtpId = result.otpId;
        reqWaNotifier.value = 'otpId: ${result.otpId} | message: ${result.message} | status: ${result.status}';
      },
      onError: (err) {
        reqWaNotifier.value = '${reqWaNotifier.value}\n${err.toString()}';
      },
    );
  }

  void fGenWa() {
    genWaNotifier.value = '';
    Fazpass.generateOtpByPhone(phone, waGatewayKey,
      (result) {
        _lastOtpId = result.otpId;
        genWaNotifier.value = 'otpId: ${result.otpId} | message: ${result.message} | status: ${result.status}';
      },
      onError: (err) {
        genWaNotifier.value = '${genWaNotifier.value}\n${err.toString()}';
      },
    );
  }

  void fReqWaLong() {
    reqWaLongNotifier.value = '';
    Fazpass.requestOtpByPhone(phone, waLongGatewayKey,
      (result) {
        _lastOtpId = result.otpId;
        reqWaLongNotifier.value = 'otpId: ${result.otpId} | message: ${result.message} | status: ${result.status}';
      },
      onError: (err) {
        reqWaLongNotifier.value = '${reqWaLongNotifier.value}\n${err.toString()}';
      },
    );
  }

  void fGenWaLong() {
    genWaLongNotifier.value = '';
    Fazpass.generateOtpByPhone(phone, waLongGatewayKey,
      (result) {
        _lastOtpId = result.otpId;
        genWaLongNotifier.value = 'otpId: ${result.otpId} | message: ${result.message} | status: ${result.status}';
      },
      onError: (err) {
        genWaLongNotifier.value = '${genWaLongNotifier.value}\n${err.toString()}';
      },
    );
  }

  Future<bool> fValidateOtp() async {
    final otp = otpController.text;
    if (_lastOtpId!=null&& otp.isNotEmpty) {
      return await Fazpass.validateOtp(_lastOtpId!, otp);
    }
    return false;
  }

  Future<bool> fHe() async {
    return Fazpass.heValidation(phone, heGatewayKey);
  }

  Future<Result> fTdEnrollByPin() async {
    if (_fazpassTd==null) {
      throw PlatformException(
        code: 'error',
        message: 'Call Fazpass.check() first!',
      );
    }
    return _fazpassTd!.enrollByPin(pin);
  }

  Future<bool> fTdEnrollByFinger() async {
    if (_fazpassTd==null) {
      throw PlatformException(
        code: 'error',
        message: 'Call Fazpass.check() first!',
      );
    }
    return _fazpassTd!.enrollByFinger(pin);
  }

  Future<ValidateUserResult> fTdValidateUser() async {
    if (_fazpassTd==null) {
      throw PlatformException(
        code: 'error',
        message: 'Call Fazpass.check() first!',
      );
    } else if (_fazpassTd!.td_status == TRUSTED_DEVICE_STATUS.UNTRUSTED) {
      throw PlatformException(
        code: 'error',
        message: 'Enroll this device first. Then redo the "check" function until td_status says "TRUSTED".',
      );
    }
    return _fazpassTd!.validateUser(pin);
  }

  Future<ValidateCrossDeviceResult> fTdValidateCrossDevice() async {
    if (_fazpassTd==null) {
      throw PlatformException(
        code: 'error',
        message: 'Call Fazpass.check() first!',
      );
    }
    return _fazpassTd!.validateCrossDevice(60);
  }

  Future<bool> fRemoveDevice() async {
    return Fazpass.removeDevice(pin);
  }

  Future<void> fCdInit() async {
    final device = await FazpassCd.initialize(false);
    if (device != null) _showNotificationBanner(device);
    fCdListen();
  }

  void fCdListen() {
    FazpassCd.notificationListener().listen((event) {
      _showNotificationBanner(event);
    });
  }

  void _fCdOnConfirm() {
    FazpassCd.onConfirm();
    scaffoldKey.currentState?.clearMaterialBanners();
  }

  void _fCdOnDecline() {
    FazpassCd.onDecline();
    scaffoldKey.currentState?.clearMaterialBanners();
  }

  void _showNotificationBanner(String device) {
    scaffoldKey.currentState?.showMaterialBanner(MaterialBanner(
      leading: const Icon(Icons.notifications),
      content: Text('Someone is trying to sign in with your account using device $device, is this you?'), 
      actions: [
        TextButton(onPressed: _fCdOnConfirm, child: const Text('YES')),
        TextButton(onPressed: _fCdOnDecline, child: const Text('NO')),
      ],
    ));
  }
}