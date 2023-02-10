
import 'result.dart';

class RequestOtpResult extends Result {
  final String otpId;

  RequestOtpResult(super.status, super.message, this.otpId);
}