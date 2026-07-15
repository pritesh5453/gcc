import 'package:gcc/Models_nServices/deposite/deposite_model.dart';

class VerifyPaymentResponse {
  final bool success;
  final String message;
  final Transaction? transaction;

  VerifyPaymentResponse({
    required this.success,
    required this.message,
    this.transaction,
  });

  factory VerifyPaymentResponse.fromJson(Map<String, dynamic> json) {
    return VerifyPaymentResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      transaction: json['data'] != null &&
              json['data']['transaction'] != null
          ? Transaction.fromJson(json['data']['transaction'])
          : null,
    );
  }
}