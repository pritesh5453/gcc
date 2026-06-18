class EarnRewardsResponse {
  final bool success;
  final EarnRewardsData data;
  final String message;

  EarnRewardsResponse({
    required this.success,
    required this.data,
    required this.message,
  });

  factory EarnRewardsResponse.fromJson(Map<String, dynamic> json) {
    return EarnRewardsResponse(
      success: json['success'] ?? false,
      data: EarnRewardsData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class EarnRewardsData {
  final int rewardPointsBalance;
  final List<EarnRewardsActivity> activities;

  EarnRewardsData({
    required this.rewardPointsBalance,
    required this.activities,
  });

  factory EarnRewardsData.fromJson(Map<String, dynamic> json) {
    return EarnRewardsData(
      rewardPointsBalance: json['reward_points_balance'] ?? 0,
      activities:
          (json['activities'] as List?)
              ?.map((e) => EarnRewardsActivity.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class EarnRewardsActivity {
  final String activityName;
  final int points;

  EarnRewardsActivity({required this.activityName, required this.points});

  factory EarnRewardsActivity.fromJson(Map<String, dynamic> json) {
    return EarnRewardsActivity(
      activityName: json['activity_name'] ?? '',
      points: json['points'] ?? 0,
    );
  }
}

// ---------- Reward Status Summary ----------
class RewardStatusSummaryResponse {
  final bool status;
  final RewardStatusData data;

  RewardStatusSummaryResponse({required this.status, required this.data});

  factory RewardStatusSummaryResponse.fromJson(Map<String, dynamic> json) {
    return RewardStatusSummaryResponse(
      status: json['status'] ?? false,
      data: RewardStatusData.fromJson(json['data'] ?? {}),
    );
  }
}

class RewardStatusData {
  final int dailyLoginStatus;
  final int buyRewardStatus;
  final int referralRewardStatus;
  final int trackYourImpactStatus;
  final int totalRewardPoints;

  RewardStatusData({
    required this.dailyLoginStatus,
    required this.buyRewardStatus,
    required this.referralRewardStatus,
    required this.trackYourImpactStatus,
    required this.totalRewardPoints,
  });

  factory RewardStatusData.fromJson(Map<String, dynamic> json) {
    return RewardStatusData(
      dailyLoginStatus: json['daily_login_status'] ?? 0,
      buyRewardStatus: json['buy_reward_status'] ?? 0,
      referralRewardStatus: json['referral_reward_status'] ?? 0,
      trackYourImpactStatus: json['track_your_impact_status'] ?? 0,
      totalRewardPoints: json['total_reward_points'] ?? 0,
    );
  }
}

// ---------- Claim Responses ----------
class ClaimLoginRewardResponse {
  final bool success;
  final int claimStatus;
  final int rewardPointsBalance;
  final int claimedPoints;
  final String message;
  final ClaimRewardData data;

  ClaimLoginRewardResponse({
    required this.success,
    required this.claimStatus,
    required this.rewardPointsBalance,
    required this.claimedPoints,
    required this.message,
    required this.data,
  });

  factory ClaimLoginRewardResponse.fromJson(Map<String, dynamic> json) {
    return ClaimLoginRewardResponse(
      success: json['success'] ?? false,
      claimStatus: json['claim_status'] ?? 0,
      rewardPointsBalance: json['reward_points_balance'] ?? 0,
      claimedPoints: json['claimed_points'] ?? 0,
      message: json['message'] ?? '',
      data: ClaimRewardData.fromJson(json['data'] ?? {}),
    );
  }
}

class ClaimRewardData {
  final String activityName;
  final String activityKey;
  final String claimedDate;

  ClaimRewardData({
    required this.activityName,
    required this.activityKey,
    required this.claimedDate,
  });

  factory ClaimRewardData.fromJson(Map<String, dynamic> json) {
    return ClaimRewardData(
      activityName: json['activity_name'] ?? '',
      activityKey: json['activity_key'] ?? '',
      claimedDate: json['claimed_date'] ?? '',
    );
  }
}

// ---------- Response for the "track-your-impact" API (first step) ----------
class TrackYourImpactResponse {
  final bool status;
  final bool success;
  final String message;

  TrackYourImpactResponse({
    required this.status,
    required this.success,
    required this.message,
  });

  factory TrackYourImpactResponse.fromJson(Map<String, dynamic> json) {
    return TrackYourImpactResponse(
      status: json['status'] ?? false,
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

// ---------- Response for the "claim-track-your-impact" API (second step) ----------
// (This was previously named TrackImpactResponse – kept as is.)
class TrackImpactResponse {
  final bool success;
  final int claimStatus;
  final int rewardPointsBalance;
  final int updatedBalance;
  final int claimedPoints;
  final String message;
  final TrackImpactData data;

  TrackImpactResponse({
    required this.success,
    required this.claimStatus,
    required this.rewardPointsBalance,
    required this.updatedBalance,
    required this.claimedPoints,
    required this.message,
    required this.data,
  });

  factory TrackImpactResponse.fromJson(Map<String, dynamic> json) {
    return TrackImpactResponse(
      success: json['success'] ?? false,
      claimStatus: json['claim_status'] ?? 0,
      rewardPointsBalance: json['reward_points_balance'] ?? 0,
      updatedBalance: json['updated_balance'] ?? 0,
      claimedPoints: json['claimed_points'] ?? 0,
      message: json['message'] ?? '',
      data: TrackImpactData.fromJson(json['data'] ?? {}),
    );
  }
}

class TrackImpactData {
  final String activityName;
  final String activityKey;
  final String claimedDate;

  TrackImpactData({
    required this.activityName,
    required this.activityKey,
    required this.claimedDate,
  });

  factory TrackImpactData.fromJson(Map<String, dynamic> json) {
    return TrackImpactData(
      activityName: json['activity_name'] ?? '',
      activityKey: json['activity_key'] ?? '',
      claimedDate: json['claimed_date'] ?? '',
    );
  }
}
