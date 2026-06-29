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

// ─── Helper functions for safe parsing ──────────────────────────────
int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

// ─── Impact Data ──────────────────────────────────────────────────────
class ImpactData {
  final double totalUnits;
  final double currentUnitPrice;
  final double portfolioValue;
  final int totalReferrals;
  final int treeSupported;
  final double co2Offset;      // ✅ Changed to double
  final int ecoRewardsEarned;
  final TreeDetails tree;
  final double ifCarEmissionsAvoided;      // ✅ Changed to double
  final double hoursOfElectricitySaved;    // ✅ Changed to double
  final double litersOfWaterConserved;     // ✅ Changed to double

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
      totalUnits: _toDouble(json['total_units']),
      currentUnitPrice: _toDouble(json['current_unit_price']),
      portfolioValue: _toDouble(json['portfolio_value']),
      totalReferrals: _toInt(json['total_referrals']),
      treeSupported: _toInt(json['tree_supported']),
      co2Offset: _toDouble(json['co2_offset']),
      ecoRewardsEarned: _toInt(json['eco_rewards_earned']),
      tree: TreeDetails.fromJson(json['tree'] ?? {}),
      ifCarEmissionsAvoided: _toDouble(json['if_car_emissions_avoided']),
      hoursOfElectricitySaved: _toDouble(json['hours_of_electricity_saved']),
      litersOfWaterConserved: _toDouble(json['liters_of_water_conserved']),
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
      totalTree: _toInt(json['total_tree']),
      unitsTree: _toInt(json['units_tree']),
      referralTree: _toInt(json['referral_tree']),
      rewardsTree: _toInt(json['rewards_tree']),
    );
  }
}