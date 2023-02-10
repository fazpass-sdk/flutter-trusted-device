import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_trusted_device_method_channel.dart';

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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
