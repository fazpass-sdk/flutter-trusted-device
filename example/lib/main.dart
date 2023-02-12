
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_trusted_device/flutter_trusted_device.dart';

import 'future_widget.dart';
import 'listenable_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with MyAppViewModel {

  @override
  void initState() {
    super.initState();
    fInit();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fazpass Flutter Plugin'),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: userController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Phone / Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            FutureWidget<FazpassTd>(
              functionName: 'Check',
              future: fCheck,
              successMessage: (fazpassTd) => 'cd: ${fazpassTd.cd_status} | td: ${fazpassTd.td_status}',
            ),
            ListenableWidget(
              functionName: 'Request Miscall',
              function: fReqMiscall,
              notifier: reqMiscallNotifier,
            ),
            ListenableWidget(
              functionName: 'Generate Miscall',
              function: fGenMiscall,
              notifier: genMiscallNotifier,
            ),
            ListenableWidget(
              functionName: 'Request SMS',
              function: fReqSms,
              notifier: reqSmsNotifier,
            ),
            ListenableWidget(
              functionName: 'Generate SMS',
              function: fGenSms,
              notifier: genSmsNotifier,
            ),
            ListenableWidget(
              functionName: 'Request Email',
              function: fReqEmail,
              notifier: reqEmailNotifier,
            ),
            ListenableWidget(
              functionName: 'Generate Email',
              function: fGenEmail,
              notifier: genEmailNotifier,
            ),
            ListenableWidget(
              functionName: 'Request WA',
              function: fReqWa,
              notifier: reqWaNotifier,
            ),
            ListenableWidget(
              functionName: 'Generate WA',
              function: fGenWa,
              notifier: genWaNotifier,
            ),
            ListenableWidget(
              functionName: 'Request WA Long',
              function: fReqWaLong,
              notifier: reqWaLongNotifier,
            ),
            ListenableWidget(
              functionName: 'Generate WA Long',
              function: fGenWaLong,
              notifier: genWaLongNotifier,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: otpController,
                decoration: const InputDecoration.collapsed(
                  hintText: 'OTP',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            FutureWidget<bool>(
              functionName: 'Validate Otp',
              future: fValidateOtp,
              successMessage: (result) => 'validate otp ${result ? 'success' : 'failed'}.',
            ),
            FutureWidget<bool>(
              functionName: 'Header Enrichment',
              future: fHe,
              successMessage: (result) => 'he request ${result ? 'success' : 'failed'}.',
            ),
            FutureWidget<Result>(
              functionName: 'Enroll by Pin',
              future: fTdEnrollByPin,
              successMessage: (result) => 'enroll by pin ${result.status ? 'success' : 'failed'}.',
            ),
            FutureWidget<bool>(
              functionName: 'Enroll by Finger',
              future: fTdEnrollByFinger,
              successMessage: (result) => 'enroll by finger ${result ? 'success' : 'failed'}.',
            ),
            FutureWidget<ValidateUserResult>(
              functionName: 'Validate User',
              future: fTdValidateUser,
              successMessage: (result) => 'confidence rate: ${result.confidenceRate*100}%',
              importantNote: '*Device must be enrolled first!',
            ),
            FutureWidget<ValidateCrossDeviceResult>(
              functionName: 'Validate Cross Device',
              future: fTdValidateCrossDevice,
              successMessage: (result) => 'request validate cross device to device ${result.device} ${result.status ? 'accepted' : 'rejected'}.',
            ),
            FutureWidget<bool>(
              functionName: 'Remove Device',
              future: fRemoveDevice,
              successMessage: (result) => 'remove device ${result ? 'success' : 'failed'}.',
            ),
          ],
        ),
      ),
    );
  }
}

mixin MyAppViewModel {
  static const merchantKey = 'MERCHANT_KEY';
  static const miscallGatewayKey = 'MISCALL_GATEWAY_KEY';
  static const smsGatewayKey = 'SMS_GATEWAY_KEY';
  static const emailGatewayKey = 'EMAIL_GATEWAY_KEY';
  static const waGatewayKey = 'WHATSAPP_GATEWAY_KEY';
  static const waLongGatewayKey = 'WHATSAPP_LONG_GATEWAY_KEY';
  static const heGatewayKey = 'HEADER_ENRICHMENT_GATEWAY_KEY';
  static const mode = MODE.STAGING;
  static const pin = 'pin';

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