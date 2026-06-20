// lib/Models_nServices/buy_coin/buy_coin_model.dart

class BuyCoinResponse {
  final bool success;
  final String message;
  final BuyCoinData? data;

  BuyCoinResponse({required this.success, required this.message, this.data});

  factory BuyCoinResponse.fromJson(Map<String, dynamic> json) {
    return BuyCoinResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? BuyCoinData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
      };
}

class BuyCoinData {
  final Transaction? transaction;
  final Charges? charges;
  final Portfolio? portfolio;

  BuyCoinData({this.transaction, this.charges, this.portfolio});

  factory BuyCoinData.fromJson(Map<String, dynamic> json) {
    return BuyCoinData(
      transaction: json['transaction'] != null
          ? Transaction.fromJson(json['transaction'])
          : null,
      charges: json['charges'] != null
          ? Charges.fromJson(json['charges'])
          : null,
      portfolio: json['portfolio'] != null
          ? Portfolio.fromJson(json['portfolio'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'transaction': transaction?.toJson(),
        'charges': charges?.toJson(),
        'portfolio': portfolio?.toJson(),
      };
}

class Transaction {
  final int id;
  final Coin coin;
  final double amountCoin;
  final double amountInr;
  final double priceAtTransaction;
  final double serviceCharge;
  final String status;
  final String createdAt;

  Transaction({
    required this.id,
    required this.coin,
    required this.amountCoin,
    required this.amountInr,
    required this.priceAtTransaction,
    required this.serviceCharge,
    required this.status,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int? ?? 0,
      coin: Coin.fromJson(json['coin'] as Map<String, dynamic>? ?? {}),
      amountCoin: double.tryParse(json['amount_coin']?.toString() ?? '0') ?? 0.0,
      amountInr: double.tryParse(json['amount_inr']?.toString() ?? '0') ?? 0.0,
      priceAtTransaction:
          double.tryParse(json['price_at_transaction']?.toString() ?? '0') ??
              0.0,
      serviceCharge:
          double.tryParse(json['service_charge']?.toString() ?? '0') ?? 0.0,
      status: json['status'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'coin': coin.toJson(),
        'amount_coin': amountCoin,
        'amount_inr': amountInr,
        'price_at_transaction': priceAtTransaction,
        'service_charge': serviceCharge,
        'status': status,
        'created_at': createdAt,
      };
}

class Coin {
  final int id;
  final String name;
  final String symbol;

  Coin({required this.id, required this.name, required this.symbol});

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      symbol: json['symbol'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'symbol': symbol,
      };
}

class Charges {
  final double serviceCharge;
  final double gstCharge;
  final double totalCharge;

  Charges({
    required this.serviceCharge,
    required this.gstCharge,
    required this.totalCharge,
  });

  factory Charges.fromJson(Map<String, dynamic> json) {
    return Charges(
      serviceCharge:
          double.tryParse(json['service_charge']?.toString() ?? '0') ?? 0.0,
      gstCharge: double.tryParse(json['gst_charge']?.toString() ?? '0') ?? 0.0,
      totalCharge: double.tryParse(json['total_charge']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'service_charge': serviceCharge,
        'gst_charge': gstCharge,
        'total_charge': totalCharge,
      };
}

class Portfolio {
  final double totalUnits;
  final double currentUnitPrice;
  final double portfolioValue;
  final double totalInvested;
  final double currentValue;
  final double profitLoss;
  final int totalReferrals;

  Portfolio({
    required this.totalUnits,
    required this.currentUnitPrice,
    required this.portfolioValue,
    required this.totalInvested,
    required this.currentValue,
    required this.profitLoss,
    required this.totalReferrals,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) {
    return Portfolio(
      totalUnits: double.tryParse(json['total_units']?.toString() ?? '0') ?? 0.0,
      currentUnitPrice:
          double.tryParse(json['current_unit_price']?.toString() ?? '0') ?? 0.0,
      portfolioValue:
          double.tryParse(json['portfolio_value']?.toString() ?? '0') ?? 0.0,
      totalInvested:
          double.tryParse(json['total_invested']?.toString() ?? '0') ?? 0.0,
      currentValue:
          double.tryParse(json['current_value']?.toString() ?? '0') ?? 0.0,
      profitLoss: double.tryParse(json['profit_loss']?.toString() ?? '0') ?? 0.0,
      totalReferrals: json['total_referrals'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'total_units': totalUnits,
        'current_unit_price': currentUnitPrice,
        'portfolio_value': portfolioValue,
        'total_invested': totalInvested,
        'current_value': currentValue,
        'profit_loss': profitLoss,
        'total_referrals': totalReferrals,
      };
}