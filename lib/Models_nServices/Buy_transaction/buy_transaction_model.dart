class BuyTransactionResponse {
  String? message;
  BuyTransactionData? data;

  BuyTransactionResponse({this.message, this.data});

  factory BuyTransactionResponse.fromJson(Map<String, dynamic> json) {
    return BuyTransactionResponse(
      message: json['message'] as String?,
      data:
          json['data'] != null
              ? BuyTransactionData.fromJson(
                json['data'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data?.toJson()};
  }
}

class BuyTransactionData {
  Transaction? transaction;
  Charges? charges;
  UserBalance? userBalance;
  ReferralEarnings? referralEarnings;

  BuyTransactionData({
    this.transaction,
    this.charges,
    this.userBalance,
    this.referralEarnings,
  });

  factory BuyTransactionData.fromJson(Map<String, dynamic> json) {
    return BuyTransactionData(
      transaction:
          json['transaction'] != null
              ? Transaction.fromJson(
                json['transaction'] as Map<String, dynamic>,
              )
              : null,
      charges:
          json['charges'] != null
              ? Charges.fromJson(json['charges'] as Map<String, dynamic>)
              : null,
      userBalance:
          json['user_balance'] != null
              ? UserBalance.fromJson(
                json['user_balance'] as Map<String, dynamic>,
              )
              : null,
      referralEarnings:
          json['referral_earnings'] != null
              ? ReferralEarnings.fromJson(
                json['referral_earnings'] as Map<String, dynamic>,
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transaction': transaction?.toJson(),
      'charges': charges?.toJson(),
      'user_balance': userBalance?.toJson(),
      'referral_earnings': referralEarnings?.toJson(),
    };
  }
}

class Transaction {
  int? id;
  Coin? coin;
  double? amountCoin;
  double? amountInr;
  double? priceAtTransaction;
  double? serviceCharge;
  String? status;
  String? createdAt;

  Transaction({
    this.id,
    this.coin,
    this.amountCoin,
    this.amountInr,
    this.priceAtTransaction,
    this.serviceCharge,
    this.status,
    this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int?,
      coin:
          json['coin'] != null
              ? Coin.fromJson(json['coin'] as Map<String, dynamic>)
              : null,
      amountCoin: (json['amount_coin'] as num?)?.toDouble(),
      amountInr: (json['amount_inr'] as num?)?.toDouble(),
      priceAtTransaction: (json['price_at_transaction'] as num?)?.toDouble(),
      serviceCharge: (json['service_charge'] as num?)?.toDouble(),
      status: json['status'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coin': coin?.toJson(),
      'amount_coin': amountCoin,
      'amount_inr': amountInr,
      'price_at_transaction': priceAtTransaction,
      'service_charge': serviceCharge,
      'status': status,
      'created_at': createdAt,
    };
  }
}

class Coin {
  int? id;
  String? name;
  String? symbol;

  Coin({this.id, this.name, this.symbol});

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] as int?,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'symbol': symbol};
  }
}

class Charges {
  double? serviceCharge;
  double? gstCharge;
  double? totalCharge;

  Charges({this.serviceCharge, this.gstCharge, this.totalCharge});

  factory Charges.fromJson(Map<String, dynamic> json) {
    return Charges(
      serviceCharge: (json['service_charge'] as num?)?.toDouble(),
      gstCharge: (json['gst_charge'] as num?)?.toDouble(),
      totalCharge: (json['total_charge'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_charge': serviceCharge,
      'gst_charge': gstCharge,
      'total_charge': totalCharge,
    };
  }
}

class UserBalance {
  double? unutilizedBalance;
  double? utilizedBalance;
  double? totalBalance;

  UserBalance({
    this.unutilizedBalance,
    this.utilizedBalance,
    this.totalBalance,
  });

  factory UserBalance.fromJson(Map<String, dynamic> json) {
    return UserBalance(
      unutilizedBalance: (json['unutilized_balance'] as num?)?.toDouble(),
      utilizedBalance: (json['utilized_balance'] as num?)?.toDouble(),
      totalBalance: (json['total_balance'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unutilized_balance': unutilizedBalance,
      'utilized_balance': utilizedBalance,
      'total_balance': totalBalance,
    };
  }
}

class ReferralEarnings {
  double? level1;
  double? level2;
  double? totalPotential;

  ReferralEarnings({this.level1, this.level2, this.totalPotential});

  factory ReferralEarnings.fromJson(Map<String, dynamic> json) {
    return ReferralEarnings(
      level1: (json['level_1'] as num?)?.toDouble(),
      level2: (json['level_2'] as num?)?.toDouble(),
      totalPotential: (json['total_potential'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level_1': level1,
      'level_2': level2,
      'total_potential': totalPotential,
    };
  }
}
