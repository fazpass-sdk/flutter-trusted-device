
import 'package:flutter/foundation.dart';

class ValidateUserResult {
  final bool status;
  final double confidenceRate;

  @protected
  ValidateUserResult(this.status, this.confidenceRate);
}