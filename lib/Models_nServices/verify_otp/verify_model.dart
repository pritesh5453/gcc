class VerifyOtpModel {
  bool? status;
  String? message;
  String? token;
  UserData? user;

  VerifyOtpModel({
    this.status,
    this.message,
    this.token,
    this.user,
  });

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpModel(
      status: json['status'],
      message: json['message'],
      token: json['token'],
      user: json['user'] != null
          ? UserData.fromJson(json['user'])
          : null,
    );
  }
}

class UserData {
  int? id;
  String? name;
  String? email;
  String? phone;

  UserData({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
    );
  }
}