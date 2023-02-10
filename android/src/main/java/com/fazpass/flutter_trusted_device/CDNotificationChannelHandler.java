package com.fazpass.flutter_trusted_device;

import android.app.Activity;

import com.fazpass.trusted_device.FazpassCd;

import io.flutter.plugin.common.EventChannel;

class CDNotificationChannelHandler implements EventChannel.StreamHandler {

    private Activity activeActivity;

    public void setActiveActivity(Activity activeActivity) {
        this.activeActivity = activeActivity;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        FazpassCd.startNotificationListener(activeActivity, device->{
            events.success(device);
            return null;
        });
    }

    @Override
    public void onCancel(Object arguments) {
        FazpassCd.stopNotificationListener(activeActivity);
    }
}
