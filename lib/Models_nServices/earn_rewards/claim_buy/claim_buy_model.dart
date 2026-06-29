// claim_buy_model.dart
class ClaimBuyRewardResponse {
  final bool status;
  final String message;
  final int rewardPointsBalance;
  final int claimedPoints;
  final ClaimData data;

  ClaimBuyRewardResponse({
    required this.status,
    required this.message,
    required this.rewardPointsBalance,
    required this.claimedPoints,
    required this.data,
  });

  factory ClaimBuyRewardResponse.fromJson(Map<String, dynamic> json) {
    return ClaimBuyRewardResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      rewardPointsBalance: _toInt(json['reward_points_balance']),
      claimedPoints: _toInt(json['claimed_points']),
      data: ClaimData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'reward_points_balance': rewardPointsBalance,
        'claimed_points': claimedPoints,
        'data': data.toJson(),
      };
}

class ClaimData {
  final DateTime claimedAt;

  ClaimData({required this.claimedAt});

  factory ClaimData.fromJson(Map<String, dynamic> json) {
    return ClaimData(
      claimedAt: DateTime.parse(json['claimed_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'claimed_at': claimedAt.toIso8601String(),
      };
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}