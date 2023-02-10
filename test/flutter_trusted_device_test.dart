import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trusted_device/flutter_trusted_device.dart';
import 'package:flutter_trusted_device/flutter_trusted_device_platform_interface.dart';
import 'package:flutter_trusted_device/flutter_trusted_device_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterTrustedDevicePlatform
    with MockPlatformInterfaceMixin
    implements FlutterTrustedDevicePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterTrustedDevicePlatform initialPlatform = FlutterTrustedDevicePlatform.instance;

  test('$MethodChannelFlutterTrustedDevice is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterTrustedDevice>());
  });

  test('getPlatformVersion', () async {
    FlutterTrustedDevice flutterTrustedDevicePlugin = FlutterTrustedDevice();
    MockFlutterTrustedDevicePlatform fakePlatform = MockFlutterTrustedDevicePlatform();
    FlutterTrustedDevicePlatform.instance = fakePlatform;

    expect(await flutterTrustedDevicePlugin.getPlatformVersion(), '42');
  });
}
