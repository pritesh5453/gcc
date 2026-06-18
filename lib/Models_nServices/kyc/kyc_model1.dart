class KycDetailsResponse {
  final bool success;
  final String message;
  final KycDetailsData data;

  KycDetailsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory KycDetailsResponse.fromJson(Map<String, dynamic> json) {
    return KycDetailsResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: KycDetailsData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class KycDetailsData {
  final String? phone;
  final String? dateOfBirth;
  final String? gender;
  final String? address;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? image;
  final String? aadhaarNumber;
  final String? aadhaarFrontImage;
  final String? aadhaarBackImage;
  final String aadhaarVerified;
  final String? panNumber;
  final String? panCardImage;
  final String panVerified;
  final String? bankName;
  final String? accountHolderName;
  final String? accountNumber;
  final String? ifscCode;
  final String? bankBranch;
  final String bankVerified;
  final String kycRequestStatus;
  final int kycCompleted;
  final int isKycDetailsSubmitted;
  final int profileCompleted;
  final String? profileCompletedAt;

  KycDetailsData({
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.city,
    this.state,
    this.postalCode,
    this.image,
    this.aadhaarNumber,
    this.aadhaarFrontImage,
    this.aadhaarBackImage,
    required this.aadhaarVerified,
    this.panNumber,
    this.panCardImage,
    required this.panVerified,
    this.bankName,
    this.accountHolderName,
    this.accountNumber,
    this.ifscCode,
    this.bankBranch,
    required this.bankVerified,
    required this.kycRequestStatus,
    required this.kycCompleted,
    required this.isKycDetailsSubmitted,
    required this.profileCompleted,
    this.profileCompletedAt,
  });

  factory KycDetailsData.fromJson(Map<String, dynamic> json) {
    return KycDetailsData(
      phone: json['phone'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      gender: json['gender'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postalCode: json['postal_code'] as String?,
      image: json['image'] as String?,
      aadhaarNumber: json['aadhaar_number'] as String?,
      aadhaarFrontImage: json['aadhaar_front_image'] as String?,
      aadhaarBackImage: json['aadhaar_back_image'] as String?,
      aadhaarVerified: json['aadhaar_verified'] as String? ?? 'pending',
      panNumber: json['pan_number'] as String?,
      panCardImage: json['pan_card_image'] as String?,
      panVerified: json['pan_verified'] as String? ?? 'pending',
      bankName: json['bank_name'] as String?,
      accountHolderName: json['account_holder_name'] as String?,
      accountNumber: json['account_number'] as String?,
      ifscCode: json['ifsc_code'] as String?,
      bankBranch: json['bank_branch'] as String?,
      bankVerified: json['bank_verified'] as String? ?? 'pending',
      kycRequestStatus: json['kyc_request_status'] as String? ?? 'none',
      kycCompleted: json['kyc_completed'] as int? ?? 0,
      isKycDetailsSubmitted: json['is_kyc_details_submitted'] as int? ?? 0,
      profileCompleted: json['profile_completed'] as int? ?? 0,
      profileCompletedAt: json['profile_completed_at'] as String?,
    );
  }
}