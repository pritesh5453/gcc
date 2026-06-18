class KycSubmitResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  KycSubmitResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory KycSubmitResponse.fromJson(Map<String, dynamic> json) {
    return KycSubmitResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] as Map<String, dynamic>?,
    );
  }
}