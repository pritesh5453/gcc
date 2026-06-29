// transaction_model.dart

class TransactionResponse {
  final bool success;
  final PortfolioSummary portfolio;
  final List<Transaction> transactions;
  final TransactionData data;
  final String message;

  TransactionResponse({
    required this.success,
    required this.portfolio,
    required this.transactions,
    required this.data,
    required this.message,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      success: json['success'] as bool,
      portfolio: PortfolioSummary.fromJson(json['portfolio'] as Map<String, dynamic>),
      transactions: (json['transactions'] as List)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      data: TransactionData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'portfolio': portfolio.toJson(),
        'transactions': transactions.map((e) => e.toJson()).toList(),
        'data': data.toJson(),
        'message': message,
      };
}

// ─── Helper to safely convert dynamic to int ──────────────────────────
int _safeInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

double _safeDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

// ─── Portfolio Summary ──────────────────────────────────────────────
class PortfolioSummary {
  final double totalHoldingUnits;
  final double currentUnitPrice;
  final double portfolioValue;

  PortfolioSummary({
    required this.totalHoldingUnits,
    required this.currentUnitPrice,
    required this.portfolioValue,
  });

  factory PortfolioSummary.fromJson(Map<String, dynamic> json) {
    return PortfolioSummary(
      totalHoldingUnits: _safeDouble(json['total_holding_units']),
      currentUnitPrice: _safeDouble(json['current_unit_price']),
      portfolioValue: _safeDouble(json['portfolio_value']),
    );
  }

  Map<String, dynamic> toJson() => {
        'total_holding_units': totalHoldingUnits,
        'current_unit_price': currentUnitPrice,
        'portfolio_value': portfolioValue,
      };
}

// ─── Transaction ─────────────────────────────────────────────────────
class Transaction {
  final int id;
  final String type;
  final Coin coin;
  final double amountCoin;
  final double amountInr;
  final double actualAmount;
  final double priceAtTransaction;
  final double serviceCharge;
  final double gstCharges;
  final String status;
  final String? utrNumber;
  final String? verificationStatus;
  final String? rejectionReason;
  final String? scImage;
  final String createdAt;
  final String updatedAt;

  Transaction({
    required this.id,
    required this.type,
    required this.coin,
    required this.amountCoin,
    required this.amountInr,
    required this.actualAmount,
    required this.priceAtTransaction,
    required this.serviceCharge,
    required this.gstCharges,
    required this.status,
    this.utrNumber,
    this.verificationStatus,
    this.rejectionReason,
    this.scImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: _safeInt(json['id']),
      type: json['type'] as String,
      coin: Coin.fromJson(json['coin'] as Map<String, dynamic>),
      amountCoin: _safeDouble(json['amount_coin']),
      amountInr: _safeDouble(json['amount_inr']),
      actualAmount: _safeDouble(json['actual_amount']),
      priceAtTransaction: _safeDouble(json['price_at_transaction']),
      serviceCharge: _safeDouble(json['service_charge']),
      gstCharges: _safeDouble(json['gst_charges']),
      status: json['status'] as String,
      utrNumber: json['utr_number'] as String?,
      verificationStatus: json['verification_status'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      scImage: json['sc_image'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'coin': coin.toJson(),
        'amount_coin': amountCoin,
        'amount_inr': amountInr,
        'actual_amount': actualAmount,
        'price_at_transaction': priceAtTransaction,
        'service_charge': serviceCharge,
        'gst_charges': gstCharges,
        'status': status,
        'utr_number': utrNumber,
        'verification_status': verificationStatus,
        'rejection_reason': rejectionReason,
        'sc_image': scImage,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

// ─── Coin ──────────────────────────────────────────────────────────────
class Coin {
  final int id;
  final String name;
  final String symbol;

  Coin({
    required this.id,
    required this.name,
    required this.symbol,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: _safeInt(json['id']),
      name: json['name'] as String,
      symbol: json['symbol'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'symbol': symbol,
      };
}

// ─── Transaction Data ────────────────────────────────────────────────
class TransactionData {
  final List<Transaction> transactions;
  final Filters filters;
  final Pagination pagination;

  TransactionData({
    required this.transactions,
    required this.filters,
    required this.pagination,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      transactions: (json['transactions'] as List)
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      filters: Filters.fromJson(json['filters'] as Map<String, dynamic>),
      pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'transactions': transactions.map((e) => e.toJson()).toList(),
        'filters': filters.toJson(),
        'pagination': pagination.toJson(),
      };
}

// ─── Filters ──────────────────────────────────────────────────────────
class Filters {
  final String? type;
  final String? status;
  final int? coinId;
  final String? startDate;
  final String? endDate;
  final String? search;
  final String sort;
  final int perPage;

  Filters({
    this.type,
    this.status,
    this.coinId,
    this.startDate,
    this.endDate,
    this.search,
    required this.sort,
    required this.perPage,
  });

  factory Filters.fromJson(Map<String, dynamic> json) {
    return Filters(
      type: json['type'] as String?,
      status: json['status'] as String?,
      coinId: json['coin_id'] != null ? _safeInt(json['coin_id']) : null,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      search: json['search'] as String?,
      sort: json['sort'] as String? ?? 'desc',
      perPage: _safeInt(json['per_page']),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'status': status,
        'coin_id': coinId,
        'start_date': startDate,
        'end_date': endDate,
        'search': search,
        'sort': sort,
        'per_page': perPage,
      };
}

// ─── Pagination ───────────────────────────────────────────────────────
class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: _safeInt(json['current_page']),
      lastPage: _safeInt(json['last_page']),
      perPage: _safeInt(json['per_page']),
      total: _safeInt(json['total']),
      from: _safeInt(json['from']),
      to: _safeInt(json['to']),
    );
  }

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'last_page': lastPage,
        'per_page': perPage,
        'total': total,
        'from': from,
        'to': to,
      };
}