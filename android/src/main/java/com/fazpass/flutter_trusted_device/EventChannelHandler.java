package com.fazpass.flutter_trusted_device;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.util.Log;

import com.fazpass.trusted_device.Fazpass;
import com.fazpass.trusted_device.Otp;
import com.fazpass.trusted_device.OtpResponse;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import io.flutter.plugin.common.EventChannel;

class EventChannelHandler implements EventChannel.StreamHandler {
    private static final int TIMEOUT_DURATION = 60000; // in milliseconds
    private final Handler timeoutHandler = new Handler();

    private Context appContext;
    private Activity activeActivity;

    public void setAppContext(Context appContext) {
        this.appContext = appContext;
    }

    public void setActiveActivity(Activity activeActivity) {
        this.activeActivity = activeActivity;
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        String name;
        Map<String, Object> args;
        try {
            name = (String) ((Map<?, ?>) arguments).get("name");
            args = (Map<String, Object>) ((Map<?, ?>) arguments).get("args");
            if (name == null || args == null) throw new Exception();
        } catch (Exception e) {
            Log.e("Event Channel Handler Error", "Bad argument", e.getCause());
            events.endOfStream();
            return;
        }

        // start timeout handler
        Runnable timeoutRunnable = events::endOfStream;
        timeoutHandler.postDelayed(timeoutRunnable, TIMEOUT_DURATION);

        // event router
        switch (name) {
            case "FazpassRequestOtpByPhone":
                fazpassRequestOtpByPhone(args, events, timeoutRunnable);
                break;
            case "FazpassRequestOtpByEmail":
                fazpassRequestOtpByEmail(args, events, timeoutRunnable);
                break;
            case "FazpassGenerateOtpByPhone":
                fazpassGenerateOtpByPhone(args, events, timeoutRunnable);
                break;
            case "FazpassGenerateOtpByEmail":
                fazpassGenerateOtpByEmail(args, events, timeoutRunnable);
                break;
            default:
                events.error("no-impl", "Not Implemented", null);
                endStream(events, timeoutRunnable);
                break;
        }
    }

    @Override
    public void onCancel(Object arguments) {}

    private void endStream(EventChannel.EventSink events, Runnable timeoutRunnable) {
        // stop timeout handler
        timeoutHandler.removeCallbacks(timeoutRunnable);
        events.endOfStream();
    }

    private void fazpassRequestOtpByPhone(Map<String, Object> arguments, EventChannel.EventSink events, Runnable timeoutRunnable) {
        String phone = (String) Objects.requireNonNull(arguments.get("phone"));
        String gateway = (String) Objects.requireNonNull(arguments.get("gateway"));

        Fazpass.requestOtpByPhone(appContext, phone, gateway, new Otp.Request() {
            @Override
            public void onComplete(OtpResponse response) {
                Map<String, Object> map = new HashMap<>();
                map.put("status", response.isStatus());
                map.put("message", response.getMessage());
                map.put("otp_id", response.getOtpId());
                events.success(map);
            }

            @Override
            public void onIncomingMessage(String otp) {
                events.success(otp);
                endStream(events, timeoutRunnable);
            }

            @Override
            public void onError(Throwable err) {
                events.error(ErrorCode.FAZPASS_REQUEST_OTP_BY_PHONE_FAILED, err.getMessage(), err.getCause());
            }
        });
    }

    private void fazpassRequestOtpByEmail(Map<String, Object> arguments, EventChannel.EventSink events, Runnable timeoutRunnable) {
        String email = (String) Objects.requireNonNull(arguments.get("email"));
        String gateway = (String) Objects.requireNonNull(arguments.get("gateway"));

        Fazpass.requestOtpByEmail(appContext, email, gateway, new Otp.Request() {
            @Override
            public void onComplete(OtpResponse response) {
                Map<String, Object> map = new HashMap<>();
                map.put("status", response.isStatus());
                map.put("message", response.getMessage());
                map.put("otp_id", response.getOtpId());
                events.success(map);
            }

            @Override
            public void onIncomingMessage(String otp) {
                events.success(otp);
                endStream(events, timeoutRunnable);
            }

            @Override
            public void onError(Throwable err) {
                events.error(ErrorCode.FAZPASS_REQUEST_OTP_BY_EMAIL_FAILED, err.getMessage(), err.getCause());
            }
        });
    }

    private void fazpassGenerateOtpByPhone(Map<String, Object> arguments, EventChannel.EventSink events, Runnable timeoutRunnable) {
        String phone = (String) Objects.requireNonNull(arguments.get("phone"));
        String gateway = (String) Objects.requireNonNull(arguments.get("gateway"));

        Fazpass.generateOtpByPhone(appContext, phone, gateway, new Otp.Request() {
            @Override
            public void onComplete(OtpResponse response) {
                Map<String, Object> map = new HashMap<>();
                map.put("status", response.isStatus());
                map.put("message", response.getMessage());
                map.put("otp_id", response.getOtpId());
                events.success(map);
            }

            @Override
            public void onIncomingMessage(String otp) {
                events.success(otp);
                endStream(events, timeoutRunnable);
            }

            @Override
            public void onError(Throwable err) {
                events.error(ErrorCode.FAZPASS_GENERATE_OTP_BY_PHONE_FAILED, err.getMessage(), err.getCause());
            }
        });
    }

    private void fazpassGenerateOtpByEmail(Map<String, Object> arguments, EventChannel.EventSink events, Runnable timeoutRunnable) {
        String email = (String) Objects.requireNonNull(arguments.get("email"));
        String gateway = (String) Objects.requireNonNull(arguments.get("gateway"));

        Fazpass.generateOtpByEmail(appContext, email, gateway, new Otp.Request() {
            @Override
            public void onComplete(OtpResponse response) {
                Map<String, Object> map = new HashMap<>();
                map.put("status", response.isStatus());
                map.put("message", response.getMessage());
                map.put("otp_id", response.getOtpId());
                events.success(map);
            }

            @Override
            public void onIncomingMessage(String otp) {
                events.success(otp);
                endStream(events, timeoutRunnable);
            }

            @Override
            public void onError(Throwable err) {
                events.error(ErrorCode.FAZPASS_GENERATE_OTP_BY_EMAIL_FAILED, err.getMessage(), err.getCause());
            }
        });
    }
}
