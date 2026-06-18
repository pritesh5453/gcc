class ProfileUpdateRequest {
  final String name;
  final String phone;
  final String dateOfBirth; // Format: "1999-04-18"
  final String gender;
  final String address;
  final String city;
  final String state;
  final String postalCode;

  ProfileUpdateRequest({
    required this.name,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'date_of_birth': dateOfBirth,
    'gender': gender,
    'address': address,
    'city': city,
    'state': state,
    'postal_code': postalCode,
  };
}

class ProfileUpdateResponse {
  final bool success;
  final String message;
  final ProfileData? data;

  ProfileUpdateResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory ProfileUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    );
  }
}

class ProfileData {
  final String name;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final bool profileCompleted;

  ProfileData({
    required this.name,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.profileCompleted,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      gender: json['gender'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postal_code'] ?? '',
      profileCompleted: json['profile_completed'] ?? false,
    );
  }
}
