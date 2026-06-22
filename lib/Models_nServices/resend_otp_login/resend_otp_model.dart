class ResendOtpRequest {
  final String sessionId;

  ResendOtpRequest({required this.sessionId});

  Map<String, dynamic> toJson() => {'session_id': sessionId};
}

class ResendOtpResponse {
  final bool status;
  final String message;
  final String sessionId;
  final String phone;

  ResendOtpResponse({
    required this.status,
    required this.message,
    required this.sessionId,
    required this.phone,
  });

  factory ResendOtpResponse.fromJson(Map<String, dynamic> json) {
    return ResendOtpResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      sessionId: json['session_id'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
