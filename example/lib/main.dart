
import 'package:flutter/material.dart';
import 'package:flutter_trusted_device/flutter_trusted_device.dart';

import 'future_widget.dart';
import 'main_state.dart';
import 'listenable_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends MyAppState {

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
