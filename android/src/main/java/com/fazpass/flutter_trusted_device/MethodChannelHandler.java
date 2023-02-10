package com.fazpass.flutter_trusted_device;

import android.app.Activity;
import android.content.Context;

import androidx.annotation.NonNull;

import com.fazpass.trusted_device.CrossDeviceListener;
import com.fazpass.trusted_device.EnrollStatus;
import com.fazpass.trusted_device.Fazpass;
import com.fazpass.trusted_device.FazpassCd;
import com.fazpass.trusted_device.FazpassTd;
import com.fazpass.trusted_device.HeaderEnrichment;
import com.fazpass.trusted_device.MODE;
import com.fazpass.trusted_device.Otp;
import com.fazpass.trusted_device.TrustedDeviceListener;
import com.fazpass.trusted_device.User;
import com.fazpass.trusted_device.ValidateStatus;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

class MethodChannelHandler implements MethodChannel.MethodCallHandler {
    private Context appContext;
    private Activity activeActivity;

    public void setAppContext(Context appContext) {
        this.appContext = appContext;
    }

    public void setActiveActivity(Activity activeActivity) {
        this.activeActivity = activeActivity;
    }

    private FazpassTd latestFazpassTd;
    private User latestUser;

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "FazpassInitialize":
                fazpassInitialize(call, result);
                break;
            case "FazpassCheck":
                fazpassCheck(call, result);
                break;
            case "FazpassRequestPermission":
                fazpassRequestPermission(call, result);
                break;
            case "FazpassValidateOtp":
                fazpassValidateOtp(call, result);
                break;
            case "FazpassHEValidation":
                fazpassHEValidation(call, result);
                break;
            case "FazpassRemoveDevice":
                fazpassRemoveDevice(call, result);
                break;
            case "FazpassTdEnrollByPin":
                fazpassTdEnrollByPin(call, result);
                break;
            case "FazpassTdEnrollByFinger":
                fazpassTdEnrollByFinger(call, result);
                break;
            case "FazpassTdValidateUser":
                fazpassTdValidateUser(call, result);
                break;
            case "FazpassTdValidateCrossDevice":
                fazpassTdValidateCrossDevice(call, result);
                break;
            case "FazpassCdInitialize":
                fazpassCdInitialize(call, result);
                break;
            case "FazpassCdOnConfirm":
                fazpassCdOnConfirm(call, result);
                break;
            case "FazpassCdOnConfirmRequirePin":
                fazpassCdOnConfirmRequirePin(call, result);
                break;
            case "FazpassCdOnDecline":
                fazpassCdOnDecline(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void fazpassCdOnDecline(MethodCall call, MethodChannel.Result result) {
        FazpassCd.onDecline(activeActivity);
        result.success(null);
    }

    private void fazpassCdOnConfirmRequirePin(MethodCall call, MethodChannel.Result result) {
        String pin = Objects.requireNonNull(call.argument("pin"));

        FazpassCd.onConfirmRequirePin(activeActivity, pin, isValid->{
            result.success(isValid);
            return null;
        });
    }

    private void fazpassCdOnConfirm(MethodCall call, MethodChannel.Result result) {
        FazpassCd.onConfirm(activeActivity);
        result.success(null);
    }

    private void fazpassCdInitialize(MethodCall call, MethodChannel.Result result) {
        boolean requirePin = Objects.requireNonNull(call.argument("require_pin"));

        String requesterDevice = FazpassCd.initialize(activeActivity, requirePin);
        result.success(requesterDevice);
    }

    private void fazpassRequestPermission(MethodCall call, MethodChannel.Result result) {
        Fazpass.requestPermission(activeActivity);
        result.success(null);
    }

    private void fazpassInitialize(MethodCall call, MethodChannel.Result result) {
        String merchantKey = Objects.requireNonNull(call.argument("merchant_key"));
        MODE mode = MODE.valueOf(call.argument("MODE"));

        Fazpass.initialize(appContext, merchantKey, mode);
        result.success(null);
    }

    private void fazpassCheck(MethodCall call, MethodChannel.Result result) {
        String email = Objects.requireNonNull(call.argument("email"));
        String phone = Objects.requireNonNull(call.argument("phone"));

        Fazpass.check(appContext, email, phone, new TrustedDeviceListener<FazpassTd>() {
            @Override
            public void onSuccess(FazpassTd fazpassTd) {
                latestFazpassTd = fazpassTd;
                latestUser = new User(email, phone, "", "", "");
                Map<String, String> maps = new HashMap<>();
                maps.put("td_status", fazpassTd.td_status.toString());
                maps.put("cd_status", fazpassTd.cd_status.toString());
                result.success(maps);
            }

            @Override
            public void onFailure(Throwable throwable) {
                result.error(ErrorCode.FAZPASS_CHECK_FAILED, throwable.getMessage(), throwable);
            }
        });
    }

    private void fazpassTdEnrollByPin(MethodCall call, MethodChannel.Result result) {
        String pin = Objects.requireNonNull(call.argument("pin"));

        if (latestFazpassTd != null) {
            latestFazpassTd.enrollDeviceByPin(appContext, latestUser, pin, new TrustedDeviceListener<EnrollStatus>() {
                @Override
                public void onSuccess(EnrollStatus enrollStatus) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("status", enrollStatus.getStatus());
                    map.put("message", enrollStatus.getMessage());
                    result.success(map);
                }

                @Override
                public void onFailure(Throwable throwable) {
                    result.error(ErrorCode.FAZPASS_TD_ENROLL_BY_PIN_FAILED, throwable.getMessage(), throwable);
                }
            });
        } else {
            result.error(ErrorCode.FAZPASS_TD_NOT_INITIALIZED, ErrorMessage.FAZPASS_TD_NOT_INITIALIZED, null);
        }
    }



    private void fazpassTdEnrollByFinger(MethodCall call, MethodChannel.Result result) {
        String pin = Objects.requireNonNull(call.argument("pin"));

        if (latestFazpassTd != null) {
            latestFazpassTd.enrollDeviceByFinger(activeActivity, latestUser, pin, new TrustedDeviceListener<EnrollStatus>() {
                @Override
                public void onSuccess(EnrollStatus o) {
                    result.success(o.getStatus());
                }

                @Override
                public void onFailure(Throwable err) {
                    result.error(ErrorCode.FAZPASS_TD_BIOMETRIC_FAILED, ErrorMessage.FAZPASS_TD_BIOMETRIC_FAILED, err);
                }
            });
        } else {
            result.error(ErrorCode.FAZPASS_TD_NOT_INITIALIZED, ErrorMessage.FAZPASS_TD_NOT_INITIALIZED, null);
        }
    }

    private void fazpassTdValidateUser(MethodCall call, MethodChannel.Result result) {
        String pin = Objects.requireNonNull(call.argument("pin"));

        if (latestFazpassTd != null) {
            latestFazpassTd.validateUser(activeActivity, pin, new TrustedDeviceListener<ValidateStatus>() {
                @Override
                public void onSuccess(ValidateStatus validateStatus) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("status", validateStatus.isStatus());
                    map.put("confidence_summary", validateStatus.getConfidenceRate().getSummary());
                    result.success(map);
                }

                @Override
                public void onFailure(Throwable throwable) {
                    result.error(ErrorCode.FAZPASS_TD_VALIDATE_USER_FAILED, throwable.getMessage(), throwable);
                }
            });
        } else {
            result.error(ErrorCode.FAZPASS_TD_NOT_INITIALIZED, ErrorMessage.FAZPASS_TD_NOT_INITIALIZED, null);
        }
    }

    private void fazpassTdValidateCrossDevice(MethodCall call, MethodChannel.Result result) {
        long timeout = Long.parseLong(""+Objects.requireNonNull(call.argument("timeout")));

        if (latestFazpassTd != null) {
            latestFazpassTd.validateCrossDevice(appContext, timeout, new CrossDeviceListener() {
                @Override
                public void onResponse(String s, boolean b) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("status", b);
                    map.put("device", s);
                    result.success(map);
                }

                @Override
                public void onExpired() {
                    result.error(ErrorCode.FAZPASS_TD_VALIDATE_CD_EXPIRED, ErrorMessage.FAZPASS_TD_VALIDATE_CD_EXPIRED, null);
                }
            });
        } else {
            result.error(ErrorCode.FAZPASS_TD_NOT_INITIALIZED, ErrorMessage.FAZPASS_TD_NOT_INITIALIZED, null);
        }
    }

    private void fazpassValidateOtp(MethodCall call, MethodChannel.Result result) {
        String otpId = Objects.requireNonNull(call.argument("otp_id"));
        String otp = Objects.requireNonNull(call.argument("otp"));

        Fazpass.validateOtp(appContext, otpId, otp, new Otp.Validate() {
            @Override
            public void onComplete(boolean status) {
                result.success(status);
            }

            @Override
            public void onError(Throwable err) {
                result.error(ErrorCode.FAZPASS_OTP_VALIDATION_FAILED, err.getMessage(), err);
            }
        });
    }

    private void fazpassHEValidation(MethodCall call, MethodChannel.Result result) {
        String phone = Objects.requireNonNull(call.argument("phone"));
        String gateway = Objects.requireNonNull(call.argument("gateway"));

        Fazpass.heValidation(appContext, phone, gateway, new HeaderEnrichment.Request() {
            @Override
            public void onComplete(boolean status) {
                result.success(status);
            }

            @Override
            public void onError(Throwable err) {
                result.error(ErrorCode.FAZPASS_HE_VALIDATION_FAILED, err.getMessage(), err);
            }
        });
    }

    private void fazpassRemoveDevice(MethodCall call, MethodChannel.Result result) {
        String pin = Objects.requireNonNull(call.argument("pin"));

        Fazpass.removeDevice(appContext, pin, new TrustedDeviceListener<Boolean>() {
            @Override
            public void onSuccess(Boolean o) {
                result.success(o);
            }

            @Override
            public void onFailure(Throwable err) {
                result.error(ErrorCode.FAZPASS_REMOVE_DEVICE_FAILED, err.getMessage(), err);
            }
        });
    }
}
