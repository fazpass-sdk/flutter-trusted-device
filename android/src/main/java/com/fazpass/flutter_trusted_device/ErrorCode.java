package com.fazpass.flutter_trusted_device;

class ErrorCode {
    static final String FAZPASS_CHECK_FAILED = "fz-001";
    static final String FAZPASS_TD_NOT_INITIALIZED = "fz-002";
    static final String FAZPASS_TD_ENROLL_BY_PIN_FAILED = "fz-003";
    static final String FAZPASS_TD_VALIDATE_USER_FAILED = "fz-004";
    static final String FAZPASS_TD_VALIDATE_CD_EXPIRED = "fz-005";
    static final String FAZPASS_REQUEST_OTP_BY_PHONE_FAILED = "fz-006";
    static final String FAZPASS_REQUEST_OTP_BY_EMAIL_FAILED = "fz-007";
    static final String FAZPASS_GENERATE_OTP_BY_PHONE_FAILED = "fz-008";
    static final String FAZPASS_GENERATE_OTP_BY_EMAIL_FAILED = "fz-009";
    static final String FAZPASS_OTP_VALIDATION_FAILED = "fz-010";
    static final String FAZPASS_HE_VALIDATION_FAILED = "fz-011";
    static final String FAZPASS_REMOVE_DEVICE_FAILED = "fz-012";
    static final String FAZPASS_TD_BIOMETRIC_FAILED = "fz-013";
}
