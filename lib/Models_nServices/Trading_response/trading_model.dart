class TradingCoinsResponse {
  final bool? success;
  final TradingCoinsData? data;
  final String? message;

  TradingCoinsResponse({
    this.success,
    this.data,
    this.message,
  });

  factory TradingCoinsResponse.fromJson(Map<String, dynamic> json) {
    return TradingCoinsResponse(
      success: json['success'],
      data: json['data'] != null
          ? TradingCoinsData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      message: json['message'],
    );
  }
}

class TradingCoinsData {
  final double? currentUnitPrice;
  final List<PackModel>? packs;
  final List<CoinModel>? coins;

  TradingCoinsData({
    this.currentUnitPrice,
    this.packs,
    this.coins,
  });

  factory TradingCoinsData.fromJson(Map<String, dynamic> json) {
    return TradingCoinsData(
      currentUnitPrice: _parseDouble(json['current_unit_price']),
      packs: json['packs'] != null
          ? (json['packs'] as List)
              .map((e) => PackModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      coins: json['coins'] != null
          ? (json['coins'] as List)
              .map((e) => CoinModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

class PackModel {
  final int? id;
  final String? packName;
  final String? image;
  final int? units;
  final double? amount;

  PackModel({
    this.id,
    this.packName,
    this.image,
    this.units,
    this.amount,
  });

  factory PackModel.fromJson(Map<String, dynamic> json) {
    return PackModel(
      id: json['id'],
      packName: json['pack_name'],
      image: json['image'],
      units: json['units'],
      amount: _parseDouble(json['amount']),
    );
  }
}

class CoinModel {
  final int? id;
  final String? name;
  final String? symbol;
  final String? image;
  final double? price;
  final int? marketCap;
  final int? totalNumberOfCoins;
  final int? serviceCharge;
  final int? gstCharges;
  final String? createdAt;
  final String? updatedAt;

  CoinModel({
    this.id,
    this.name,
    this.symbol,
    this.image,
    this.price,
    this.marketCap,
    this.totalNumberOfCoins,
    this.serviceCharge,
    this.gstCharges,
    this.createdAt,
    this.updatedAt,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      image: json['image'],
      price: _parseDouble(json['price']),
      marketCap: json['market_cap'],
      totalNumberOfCoins: json['total_number_of_coins'],
      serviceCharge: json['service_charge'],
      gstCharges: json['gst_charges'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}