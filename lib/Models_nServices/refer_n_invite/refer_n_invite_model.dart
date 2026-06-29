// refer_n_invite_model.dart

class InviteScreenResponse {
  final bool success;
  final String message;
  final InviteScreenData data;

  InviteScreenResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory InviteScreenResponse.fromJson(Map<String, dynamic> json) {
    return InviteScreenResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: InviteScreenData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.toJson(),
      };
}

class InviteScreenData {
  final String referralCode;
  final int totalInvites;
  final int contributionVolume;
  final RewardBoost rewardBoost;
  final Network network;
  final MonthlyAverage monthlyAverage;

  InviteScreenData({
    required this.referralCode,
    required this.totalInvites,
    required this.contributionVolume,
    required this.rewardBoost,
    required this.network,
    required this.monthlyAverage,
  });

  factory InviteScreenData.fromJson(Map<String, dynamic> json) {
    return InviteScreenData(
      referralCode: json['referral_code'] as String,
      // Convert double to int safely using num
      totalInvites: (json['total_invites'] as num).toInt(),
      contributionVolume: (json['contribution_volume'] as num).toInt(),
      rewardBoost: RewardBoost.fromJson(json['reward_boost'] as Map<String, dynamic>),
      network: Network.fromJson(json['network'] as Map<String, dynamic>),
      monthlyAverage: MonthlyAverage.fromJson(json['monthly_average'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'referral_code': referralCode,
        'total_invites': totalInvites,
        'contribution_volume': contributionVolume,
        'reward_boost': rewardBoost.toJson(),
        'network': network.toJson(),
        'monthly_average': monthlyAverage.toJson(),
      };
}

class RewardBoost {
  final String multiplier;

  RewardBoost({required this.multiplier});

  factory RewardBoost.fromJson(Map<String, dynamic> json) {
    return RewardBoost(multiplier: json['multiplier'] as String);
  }

  Map<String, dynamic> toJson() => {'multiplier': multiplier};
}

class Network {
  final int totalReferrals;
  final int activeContributors;

  Network({
    required this.totalReferrals,
    required this.activeContributors,
  });

  factory Network.fromJson(Map<String, dynamic> json) {
    return Network(
      totalReferrals: (json['total_referrals'] as num).toInt(),
      activeContributors: (json['active_contributors'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'total_referrals': totalReferrals,
        'active_contributors': activeContributors,
      };
}

class MonthlyAverage {
  final int currentMonthAvgAmount;

  MonthlyAverage({required this.currentMonthAvgAmount});

  factory MonthlyAverage.fromJson(Map<String, dynamic> json) {
    return MonthlyAverage(
      currentMonthAvgAmount: (json['current_month_avg_amount'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {'current_month_avg_amount': currentMonthAvgAmount};
}


// ─── Invite Introduction Model ──────────────────────────────────────────

class InviteIntroduction {
  final int id;
  final int sequence;
  final String introduction;

  InviteIntroduction({
    required this.id,
    required this.sequence,
    required this.introduction,
  });

  factory InviteIntroduction.fromJson(Map<String, dynamic> json) {
    return InviteIntroduction(
      id: json['id'] as int,
      sequence: json['sequence'] as int,
      introduction: json['introduction'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'sequence': sequence,
        'introduction': introduction,
      };
}

// Optional: Response wrapper if needed (but the API returns a direct list)
class InviteIntroductionResponse {
  final bool success;
  final String message;
  final List<InviteIntroduction> data;

  InviteIntroductionResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory InviteIntroductionResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List)
        .map((e) => InviteIntroduction.fromJson(e as Map<String, dynamic>))
        .toList();
    return InviteIntroductionResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: list,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}