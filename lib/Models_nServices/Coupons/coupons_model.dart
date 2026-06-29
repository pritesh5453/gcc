class CouponsResponse {
  final bool status;
  final int rewardPoints;
  final List<CouponData> data;
  final int total_cashback_earned;

  CouponsResponse({
    required this.status,
    required this.rewardPoints,
    required this.data,
    required this.total_cashback_earned,
  });

  factory CouponsResponse.fromJson(Map<String, dynamic> json) {
    return CouponsResponse(
      status: json['status'] ?? false,
      rewardPoints: json['reward_points'] ?? 0,
      data:
          (json['data'] as List?)
              ?.map((e) => CouponData.fromJson(e))
              .toList() ??
          [],
          total_cashback_earned: json['total_cashback_earned'] ?? 0,
    );
  }
}

class CouponData {
  final int id;
  final String couponName;
  final String couponImage;
  final int requiredRewardPoints;
  final int minRewardAmount;
  final int maxRewardAmount;
  final bool isEligible;
  final bool isScratch; // 👈 NEW field

  CouponData({
    required this.id,
    required this.couponName,
    required this.couponImage,
    required this.requiredRewardPoints,
    required this.minRewardAmount,
    required this.maxRewardAmount,
    required this.isEligible,
    required this.isScratch,
    
  });

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      id: json['id'] ?? 0,
      couponName: json['coupon_name'] ?? '',
      couponImage: json['coupon_image'] ?? '',
      requiredRewardPoints: json['required_reward_points'] ?? 0,
      minRewardAmount: json['min_reward_amount'] ?? 0,
      maxRewardAmount: json['max_reward_amount'] ?? 0,
      isEligible: json['is_eligible'] ?? false,
      isScratch: json['is_scratch'] ?? false, // key must match API
    
    );
  }
}

// ==============================
// SCRATCH COUPON RESPONSE
// ==============================

class ScratchCouponResponse {
  final bool status;
  final String message;
  final ScratchCouponData data;

  ScratchCouponResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ScratchCouponResponse.fromJson(Map<String, dynamic> json) {
    return ScratchCouponResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: ScratchCouponData.fromJson(json['data'] ?? {}),
    );
  }
}

class ScratchCouponData {
  final int couponId;
  final String couponName;
  final int rewardPointsUsed;
  final int rewardAmountWon;
  final int remainingRewardPoints;
  final int updatedPortfolioBalance;

  ScratchCouponData({
    required this.couponId,
    required this.couponName,
    required this.rewardPointsUsed,
    required this.rewardAmountWon,
    required this.remainingRewardPoints,
    required this.updatedPortfolioBalance,
  });

  factory ScratchCouponData.fromJson(Map<String, dynamic> json) {
    return ScratchCouponData(
      couponId: json['coupon_id'] ?? 0,
      couponName: json['coupon_name'] ?? '',
      rewardPointsUsed: json['reward_points_used'] ?? 0,
      rewardAmountWon: json['reward_amount_won'] ?? 0,
      remainingRewardPoints: json['remaining_reward_points'] ?? 0,
      updatedPortfolioBalance: json['updated_portfolio_balance'] ?? 0,
    );
  }
}
