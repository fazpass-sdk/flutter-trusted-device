import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_trusted_device_platform_interface.dart';

/// An implementation of [FlutterTrustedDevicePlatform] that uses method channels.
class MethodChannelFlutterTrustedDevice extends FlutterTrustedDevicePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_trusted_device');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
