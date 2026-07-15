class CreateOrderResponse {
  final bool success;
  final String message;
  final CreateOrderData? data;

  CreateOrderResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? CreateOrderData.fromJson(json['data'])
          : null,
    );
  }
}

class CreateOrderData {
  final String key;
  final String orderId;
  final int amount;
  final String currency;

  CreateOrderData({
    required this.key,
    required this.orderId,
    required this.amount,
    required this.currency,
  });

  factory CreateOrderData.fromJson(Map<String, dynamic> json) {
    return CreateOrderData(
      key: json['key'] ?? '',
      orderId: json['order_id'] ?? '',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? 'INR',
    );
  }
}