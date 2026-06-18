class PortfolioResponse {
  final bool success;
  final String message;
  final PortfolioData data;

  PortfolioResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PortfolioResponse.fromJson(Map<String, dynamic> json) {
    return PortfolioResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: PortfolioData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class PortfolioData {
  final Portfolio portfolio;
  final HoldingsSummary holdingsSummary;
  final QuickStats quickStats;

  PortfolioData({
    required this.portfolio,
    required this.holdingsSummary,
    required this.quickStats,
  });

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    return PortfolioData(
      portfolio: Portfolio.fromJson(json['portfolio'] as Map<String, dynamic>),
      holdingsSummary: HoldingsSummary.fromJson(
        json['holdings_summary'] as Map<String, dynamic>,
      ),
      quickStats: QuickStats.fromJson(
        json['quick_stats'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'portfolio': portfolio.toJson(),
      'holdings_summary': holdingsSummary.toJson(),
      'quick_stats': quickStats.toJson(),
    };
  }
}

class Portfolio {
  final double totalUnits;
  final double unitPrice;
  final double totalValue;

  Portfolio({
    required this.totalUnits,
    required this.unitPrice,
    required this.totalValue,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      totalUnits: (json['total_units'] as num).toDouble(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalValue: (json['total_value'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_units': totalUnits,
      'unit_price': unitPrice,
      'total_value': totalValue,
    };
  }
}

class HoldingsSummary {
  final double totalUnits;
  final double totalInvestment;
  final double currentValue;
  final PriceStability priceStability;

  HoldingsSummary({
    required this.totalUnits,
    required this.totalInvestment,
    required this.currentValue,
    required this.priceStability,
  });

  factory HoldingsSummary.fromJson(Map<String, dynamic> json) {
    return HoldingsSummary(
      totalUnits: (json['total_units'] as num?)?.toDouble() ?? 0.0,
      totalInvestment: (json['total_investment'] as num?)?.toDouble() ?? 0.0,
      currentValue: (json['current_value'] as num?)?.toDouble() ?? 0.0,
      priceStability: PriceStability.fromJson(
        json['price_stability'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_units': totalUnits,
      'total_investment': totalInvestment,
      'current_value': currentValue,
      'price_stability': priceStability.toJson(),
    };
  }
}

class PriceStability {
  final String status;
  final String message;

  PriceStability({required this.status, required this.message});

  factory PriceStability.fromJson(Map<String, dynamic> json) {
    return PriceStability(
      status: json['status'] as String,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message};
  }
}

class QuickStats {
  final String co2Offset;
  final String waterSaved;
  final String energySaved;
  final int treesPlanted;

  QuickStats({
    required this.co2Offset,
    required this.waterSaved,
    required this.energySaved,
    required this.treesPlanted,
  });

  factory QuickStats.fromJson(Map<String, dynamic> json) {
    return QuickStats(
      co2Offset: json['co2_offset']?.toString() ?? '0 kg',
      waterSaved: json['liters_of_water_conserved']?.toString() ?? '0 L',
      energySaved: json['hours_of_electricity_saved']?.toString() ?? '0 kWh',
      treesPlanted: (json['trees_planted'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'co2_offset': co2Offset,
      'liters_of_water_conserved': waterSaved,
      'hours_of_electricity_saved': energySaved,
      'trees_planted': treesPlanted,
    };
  }
}
