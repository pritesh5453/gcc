class CoinSummaryResponse {
  final bool success;
  final String message;
  final CoinSummaryData data;

  CoinSummaryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CoinSummaryResponse.fromJson(Map<String, dynamic> json) {
    return CoinSummaryResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: CoinSummaryData.fromJson(json['data'] ?? {}),
    );
  }
}

class CoinSummaryData {
  final int userId;
  final double currentUnitsBalance;
  final double gccCurrentPrice;
  final double portfolioValue;
  final int serviceChargePercentage;
  final int gstPercentage;

  CoinSummaryData({
    required this.userId,
    required this.currentUnitsBalance,
    required this.gccCurrentPrice,
    required this.portfolioValue,
    required this.serviceChargePercentage,
    required this.gstPercentage,
  });

  factory CoinSummaryData.fromJson(Map<String, dynamic> json) {
    return CoinSummaryData(
      userId:
          json['user_id'] is int
              ? json['user_id']
              : int.tryParse('${json['user_id']}') ?? 0,
      currentUnitsBalance:
          json['current_units_balance'] is num
              ? (json['current_units_balance'] as num).toDouble()
              : double.tryParse('${json['current_units_balance']}') ?? 0.0,
      gccCurrentPrice:
          json['gcc_current_price'] is num
              ? (json['gcc_current_price'] as num).toDouble()
              : double.tryParse('${json['gcc_current_price']}') ?? 0.0,
      portfolioValue:
          json['portfolio_value'] is num
              ? (json['portfolio_value'] as num).toDouble()
              : double.tryParse('${json['portfolio_value']}') ?? 0.0,
      serviceChargePercentage:
          json['service_charge_percentage'] is int
              ? json['service_charge_percentage']
              : int.tryParse('${json['service_charge_percentage']}') ?? 0,
      gstPercentage:
          json['gst_percentage'] is int
              ? json['gst_percentage']
              : int.tryParse('${json['gst_percentage']}') ?? 0,
    );
  }
}