class ClaimReferralResponse {
  final bool status;
  final String message;
  final int rewardPointsBalance;
  final int claimedPoints;
  final int treesAwarded;
  final ClaimReferralData? data;

  ClaimReferralResponse({
    required this.status,
    required this.message,
    required this.rewardPointsBalance,
    required this.claimedPoints,
    required this.treesAwarded,
    this.data,
  });

  factory ClaimReferralResponse.fromJson(Map<String, dynamic> json) {
    return ClaimReferralResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      rewardPointsBalance: json['reward_points_balance'] ?? 0,
      claimedPoints: json['claimed_points'] ?? 0,
      treesAwarded: json['trees_awarded'] ?? 0,
      data: json['data'] != null
          ? ClaimReferralData.fromJson(json['data'])
          : null,
    );
  }
}

class ClaimReferralData {
  final String claimedAt;

  ClaimReferralData({required this.claimedAt});

  factory ClaimReferralData.fromJson(Map<String, dynamic> json) {
    return ClaimReferralData(
      claimedAt: json['claimed_at'] ?? '',
    );
  }
}