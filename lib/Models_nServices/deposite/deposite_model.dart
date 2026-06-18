class DepositResponse {
  bool? success;
  String? message;
  DepositData? data;

  DepositResponse({this.success, this.message, this.data});

  factory DepositResponse.fromJson(Map<String, dynamic> json) {
    return DepositResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? DepositData.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class DepositData {
  int? id;
  int? userId;
  double? amount;
  String? utrNumber;
  String? status;
  String? paymentScreenshot;
  String? createdAt;

  DepositData({
    this.id,
    this.userId,
    this.amount,
    this.utrNumber,
    this.status,
    this.paymentScreenshot,
    this.createdAt,
  });

  factory DepositData.fromJson(Map<String, dynamic> json) {
    return DepositData(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      amount: double.tryParse(json['amount']?.toString() ?? '0'),
      utrNumber: json['utr_number'] as String?,
      status: json['status'] as String?,
      paymentScreenshot: json['payment_screenshot'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'amount': amount,
      'utr_number': utrNumber,
      'status': status,
      'payment_screenshot': paymentScreenshot,
      'created_at': createdAt,
    };
  }
}