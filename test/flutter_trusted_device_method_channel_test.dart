import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trusted_device/flutter_trusted_device_method_channel.dart';

void main() {
  MethodChannelFlutterTrustedDevice platform = MethodChannelFlutterTrustedDevice();
  const MethodChannel channel = MethodChannel('flutter_trusted_device');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
