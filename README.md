# flutter_trusted_device Package

This is the Official flutter package for Fazpass Trusted Device.
If you want to use native sdk version for android, you can find it here: https://github.com/fazpass-sdk/trusted-device <br>
Visit https://fazpass.com for more information about the product and see documentation at http://docs.fazpass.com for more technical details.

## Minimum OS
API 24 / Android 7.0 / Nougat 

## Target SDK
We use newest version of androidx library so make sure you use this configuration
```gradle
 android {
    compileSdk 33

    defaultConfig {
        minSdk 24
        targetSdk 33
        .....
 
```
## Permission
As default this SDK used these permissions
```xml
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.READ_PHONE_NUMBERS" />
    <uses-permission android:name="android.permission.READ_CONTACTS" />
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.USE_BIOMETRIC"/>
    <uses-permission android:name="android.permission.RECEIVE_SMS" />
    <uses-permission android:name="android.permission.READ_CALL_LOG"/>
    <uses-permission android:name="android.permission.CHANGE_NETWORK_STATE"/>
```
So make sure you request all of these permission as a requirement.
#### 
| Permission           |                                              Detail                                              |
|----------------------|:------------------------------------------------------------------------------------------------:|
| Coarse Location      |                  Will be used to read user location for detecting fraud access                   |
| Read Phone State     | Will be used to detect root phone, emulator, or cloning, also will be used for Header Enrichment |
| Read Phone Number    |       Will be used to read SIM serial position. it will affect with confidence rate result       |
| Read Contacts        |          Will be used to read user contact. It will affect with confidence rate result           |
| Use Biometric        |                       Will be used to open biometric dialog in user phone                        |
| Receive SMS          |                        Will be used to auto read sms when OTP come by SMS                        |
| Read Call Log        |                    Will be used to auto read otp when OTP come by missed call                    |
| Change Network State |                 Will be used to autoswitch connection to mobile on HE validation                 |


## Usage

### Initialize
You need to call this function before using any Fazpass feature.
```dart
Fazpass.initialize(MERCHANT_KEY, MODE.STAGING);
```
MERCHANT_KEY is unique string when you registered as a fazpass client.
(You can check your email after registered to get it) <br>
MODE is type of mode, you can choose between staging or production.

### OTP
We have request OTP by email and by phone. Same as like the API we also have generate Otp function if you want to use it.

#### Requesting Method
```dart
// with phone number
Fazpass.requestOtpByPhone(
    "PHONE_NUMBER", 
    "GATEWAY_KEY", 
    (RequestOtpResult result) {
      // Response object will be came here,
    },
    onIncomingMessage: (String otp) {
      // If you use SMS/Missed Call gateway your OTP will come here. as long as the permissions are allowed.
    },
    onError: (err) {
      // It should be always null.
    },
);

// with email
Fazpass.requestOtpByEmail(
    "EMAIL_ADDRESS",
    "GATEWAY_KEY",
    (RequestOtpResult result) {
      // Response object will be came here,
    },
    onError: (err) {
      // It should be always null.
    },
);
```

#### Validating OTP
```dart
bool isSuccess = await Fazpass.validateOtp("OTP_ID", "OTP");
```

### Header Enrichment
Header enrichment will make you more confidence, because it will match between data roaming and sim that registered in that phone.<br>
The result, your app can't validate phone number that is not inside that phone.
```dart
bool isSuccess = await Fazpass.heValidation("PHONE_NUMBER", "GATEWAY_KEY");
```

### Trusted Device
First of all you need to call this method in the main class of your application
```dart
Fazpass.initialize(MERCHANT_KEY, MODE.STAGING);
```
you can get merchant key from email when you registered as our client.
#### General Flow (Check & Enroll)
![alt text](https://firebasestorage.googleapis.com/v0/b/anvarisy-tech.appspot.com/o/TD%20General%20Flow.drawio.png?alt=media&token=d3b59ce0-c326-496c-867b-b0561b595677) <br>
as you can see, trusted device need to always call check method that will return trusted status from that device.<br>
After status already trusted you can directly call method enroll. In our system enroll will update the newest information from that device & user.<br>
NB: never call enroll method if result of check is untrusted

##### Implementation
```dart
FazpassTd fazpassTd = await Fazpass.check("EMAIL", "PHONE");
if (fazpassTd.td_status == TRUSTED_DEVICE_STATUS.TRUSTED) {
  Result result = await fazpassTd.enrollByPin("PIN");
  if (result.status) {
    //enroll success
  } else {
    // enroll failed
  }
}
```

#### Validate  User & Device
It will calculate your confidence rate for current user, app and device.
```dart
FazpassTd fazpassTd = await Fazpass.check("EMAIL", "PHONE");
if (fazpassTd.td_status == TRUSTED_DEVICE_STATUS.TRUSTED) {
    ValidateUserResult result = await fazpassTd.validateUser("PIN");
    if (result.confidenceRate >= 80) {
      // This user is trusted enough to do something
    }
}
```
NB: If you use transaction inside your app, we recommended to use this method before your transaction begin.

#### Cross Device Validation
> IMPORTANT <br>
> You have to call ``` FazpassCd.initialize(REQUIRE_PIN); ``` before using any Cross Device Validation 
> feature. This will be explained more later on.

![alt text](https://firebasestorage.googleapis.com/v0/b/anvarisy-tech.appspot.com/o/TD%20Cross%20Device%20Flow.drawio.png?alt=media&token=6cc7f01a-d33a-4ec3-b6fb-674ba818ff7f) <br>
You can use this feature when your client already enrolled with a phone number or email in one device, 
and want to enroll again with that phone number or email in another device.
```dart
FazpassTd fazpassTd = await Fazpass.check("EMAIL", "PHONE");
if (fazpassTd.cd_status == CROSS_DEVICE_STATUS.AVAILABLE) {
    ValidateCrossDeviceResult result = await fazpassTd.validateCrossDevice(TIMEOUT_IN_SECONDS);
    // result.status will be true if other device accepted the cross device validation. false otherwise.
    // result.device will return information of the device which give response to the cross device validation.
}
```

On the other side, the device which have to give response to the incoming cross device validation 
should handle it based on the application state: foreground and background.

##### Handle incoming cross device validation (background)
When application is not running, incoming cross device validation will enter your system 
notification tray. Pressing said notification will launch the application with cross 
device validation data as an argument. to process this data, this important function will do it for you:
```dart
String? device = await FazpassCd.initialize(REQUIRE_PIN);
```
FazpassCd.initialize is required to setup Cross Device Validation feature, but it also process the 
data from cross device notification and return information of device which request 
a cross device validation. This function will return null if application is not launched 
from cross device notification.

##### Handle incoming cross device validation (foreground)
When application is running, you have to handle incoming cross device validation by listening to 
this stream:
```dart
Stream stream = FazpassCd.notificationListener();
stream.listen((device) {
  // called for every incoming cross device validation request
});
```

##### Respond to incoming cross device validation
>You can only respond to the latest incoming cross device validation request.

To accept incoming cross device validation request
```dart
// if pin is not required
FazpassCd.onConfirm();
// if pin is required
bool pinIsValid = await FazpassCd.onConfirmRequirePin(pin);
```
To decline incoming cross device validation request
```dart
FazpassCd.onDecline();
```

#### Remove Device
Remove current device enrolled status.
```dart
bool isSuccess = await Fazpass.removeDevice("PIN");
```
