class ImpactSummaryResponse {
  final bool success;
  final String message;
  final ImpactData data;

  ImpactSummaryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ImpactSummaryResponse.fromJson(Map<String, dynamic> json) {
    return ImpactSummaryResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ImpactData.fromJson(json['data'] ?? {}),
    );
  }
}

class ImpactData {
  final double totalUnits;
  final double currentUnitPrice;
  final double portfolioValue;
  final int totalReferrals;
  final int treeSupported;
  final int co2Offset;
  final int ecoRewardsEarned;
  final TreeDetails tree;
  final int ifCarEmissionsAvoided;
  final int hoursOfElectricitySaved;
  final int litersOfWaterConserved;

  ImpactData({
    required this.totalUnits,
    required this.currentUnitPrice,
    required this.portfolioValue,
    required this.totalReferrals,
    required this.treeSupported,
    required this.co2Offset,
    required this.ecoRewardsEarned,
    required this.tree,
    required this.ifCarEmissionsAvoided,
    required this.hoursOfElectricitySaved,
    required this.litersOfWaterConserved,
  });

  factory ImpactData.fromJson(Map<String, dynamic> json) {
    return ImpactData(
      totalUnits: (json['total_units'] ?? 0).toDouble(),
      currentUnitPrice: (json['current_unit_price'] ?? 0).toDouble(),
      portfolioValue: (json['portfolio_value'] ?? 0).toDouble(),
      totalReferrals: json['total_referrals'] ?? 0,
      treeSupported: json['tree_supported'] ?? 0,
      co2Offset: json['co2_offset'] ?? 0,
      ecoRewardsEarned: json['eco_rewards_earned'] ?? 0,
      tree: TreeDetails.fromJson(json['tree'] ?? {}),
      ifCarEmissionsAvoided: json['if_car_emissions_avoided'] ?? 0,
      hoursOfElectricitySaved: json['hours_of_electricity_saved'] ?? 0,
      litersOfWaterConserved: json['liters_of_water_conserved'] ?? 0,
    );
  }
}

class TreeDetails {
  final int totalTree;
  final int unitsTree;
  final int referralTree;
  final int rewardsTree; // kept for completeness, but not used in UI

  TreeDetails({
    required this.totalTree,
    required this.unitsTree,
    required this.referralTree,
    required this.rewardsTree,
  });

  factory TreeDetails.fromJson(Map<String, dynamic> json) {
    return TreeDetails(
      totalTree: json['total_tree'] ?? 0,
      unitsTree: json['units_tree'] ?? 0,
      referralTree: json['referral_tree'] ?? 0,
      rewardsTree: json['rewards_tree'] ?? 0,
    );
  }
}