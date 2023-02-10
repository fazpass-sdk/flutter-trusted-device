package com.fazpass.flutter_trusted_device;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;

/** TrustedDeviceFlutterPlugin */
public class FlutterTrustedDevicePlugin implements FlutterPlugin, ActivityAware {
  private static final String METHOD_CHANNEL = "flutter_trusted_device";
  private static final String EVENT_CHANNEL = "flutter_trusted_device_event";
  private static final String CD_NOTIFICATION_CHANNEL = "flutter_trusted_device_cd_notification";

  private final MethodChannelHandler methodChannelHandler = new MethodChannelHandler();
  private final EventChannelHandler eventChannelHandler = new EventChannelHandler();
  private final CDNotificationChannelHandler cdNotificationChannelHandler = new CDNotificationChannelHandler();

  private MethodChannel methodChannel;
  private EventChannel eventChannel;
  private EventChannel cdNotificationChannel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), METHOD_CHANNEL);
    methodChannel.setMethodCallHandler(methodChannelHandler);
    methodChannelHandler.setAppContext(flutterPluginBinding.getApplicationContext());

    eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), EVENT_CHANNEL);
    eventChannel.setStreamHandler(eventChannelHandler);
    eventChannelHandler.setAppContext(flutterPluginBinding.getApplicationContext());

    cdNotificationChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), CD_NOTIFICATION_CHANNEL);
    cdNotificationChannel.setStreamHandler(cdNotificationChannelHandler);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    methodChannel.setMethodCallHandler(null);
    methodChannelHandler.setAppContext(null);
    eventChannel.setStreamHandler(null);
    eventChannelHandler.setAppContext(null);
    cdNotificationChannel.setStreamHandler(null);
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    methodChannelHandler.setActiveActivity(binding.getActivity());
    eventChannelHandler.setActiveActivity(binding.getActivity());
    cdNotificationChannelHandler.setActiveActivity(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivity() {
    methodChannelHandler.setActiveActivity(null);
    eventChannelHandler.setActiveActivity(null);
    cdNotificationChannelHandler.setActiveActivity(null);
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {}

  @Override
  public void onDetachedFromActivityForConfigChanges() {}
}
