class LoginModel {
  final bool? status;
  final String? message;
  final String? sessionId;
  final String? phone;

  LoginModel({
    this.status,
    this.message,
    this.sessionId,
    this.phone,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      status: json['status'],
      message: json['message'],
      sessionId: json['session_id'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "session_id": sessionId,
      "phone": phone,
    };
  }
}