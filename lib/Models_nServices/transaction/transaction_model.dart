// lib/Models_nServices/transaction/transaction_model.dart

class TransactionResponseModel {
  final bool success;
  final TransactionDataModel data;
  final String message;

  TransactionResponseModel({
    required this.success,
    required this.data,
    required this.message,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionResponseModel(
      success: json['success'] ?? false,
      data: TransactionDataModel.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class TransactionDataModel {
  final WalletModel wallet;
  final List<TransactionItemModel> transactions;
  final FiltersModel filters;
  final PaginationModel pagination;

  TransactionDataModel({
    required this.wallet,
    required this.transactions,
    required this.filters,
    required this.pagination,
  });

  factory TransactionDataModel.fromJson(Map<String, dynamic> json) {
    return TransactionDataModel(
      wallet: WalletModel.fromJson(json['wallet'] ?? {}),
      transactions:
          (json['transactions'] as List?)
              ?.map((e) => TransactionItemModel.fromJson(e))
              .toList() ??
          [],
      filters: FiltersModel.fromJson(json['filters'] ?? {}),
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

// ---------- Helper to parse int from dynamic ----------
int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return value.toInt();
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

// ---------- Wallet & Balance ----------
class WalletModel {
  final WalletBalanceModel walletBalance;
  final ReferralEarningsModel referralEarnings;
  final UserInfoModel userInfo;

  WalletModel({
    required this.walletBalance,
    required this.referralEarnings,
    required this.userInfo,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      walletBalance: WalletBalanceModel.fromJson(json['wallet_balance'] ?? {}),
      referralEarnings: ReferralEarningsModel.fromJson(
        json['referral_earnings'] ?? {},
      ),
      userInfo: UserInfoModel.fromJson(json['user_info'] ?? {}),
    );
  }
}

class WalletBalanceModel {
  final int totalAmountHeld;
  final int utilizedBalance;
  final int unutilizedBalance;
  final int inrBalance;

  WalletBalanceModel({
    required this.totalAmountHeld,
    required this.utilizedBalance,
    required this.unutilizedBalance,
    required this.inrBalance,
  });

  factory WalletBalanceModel.fromJson(Map<String, dynamic> json) {
    return WalletBalanceModel(
      totalAmountHeld: _parseInt(json['total_amount_held']),
      utilizedBalance: _parseInt(json['utilized_balance']),
      unutilizedBalance: _parseInt(json['unutilized_balance']),
      inrBalance: _parseInt(json['inr_balance']),
    );
  }
}

class ReferralEarningsModel {
  final int totalReferralEarned;
  final int pendingReferralEarned;
  final int totalReferrals;
  final int activeReferrals;

  ReferralEarningsModel({
    required this.totalReferralEarned,
    required this.pendingReferralEarned,
    required this.totalReferrals,
    required this.activeReferrals,
  });

  factory ReferralEarningsModel.fromJson(Map<String, dynamic> json) {
    return ReferralEarningsModel(
      totalReferralEarned: _parseInt(json['total_referral_earned']),
      pendingReferralEarned: _parseInt(json['pending_referral_earned']),
      totalReferrals: _parseInt(json['total_referrals']),
      activeReferrals: _parseInt(json['active_referrals']),
    );
  }
}

class UserInfoModel {
  final int userId;
  final String username;
  final String email;
  final String referralCode;

  UserInfoModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.referralCode,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      userId: _parseInt(json['user_id']),
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      referralCode: json['referral_code'] ?? '',
    );
  }
}

// ---------- Transaction Item ----------
class TransactionItemModel {
  final int id;
  final String type;
  final CoinModel? coin;
  final double amountCoin;
  final int amountInr;
  final int actualAmount;
  final double priceAtTransaction;
  final int serviceCharge;
  final int gstCharges;
  final String status;
  final String? utrNumber;
  final String? verificationStatus;
  final String? rejectionReason;
  final String? scImage;
  final String createdAt;
  final String updatedAt;

  TransactionItemModel({
    required this.id,
    required this.type,
    this.coin,
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

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) {
    return TransactionItemModel(
      id: _parseInt(json['id']),
      type: json['type'] ?? '',
      coin: json['coin'] != null ? CoinModel.fromJson(json['coin']) : null,
      amountCoin: _parseDouble(json['amount_coin']),
      amountInr: _parseInt(json['amount_inr']),
      actualAmount: _parseInt(json['actual_amount']),
      priceAtTransaction: _parseDouble(json['price_at_transaction']),
      serviceCharge: _parseInt(json['service_charge']),
      gstCharges: _parseInt(json['gst_charges']),
      status: json['status'] ?? '',
      utrNumber: json['utr_number'],
      verificationStatus: json['verification_status'],
      rejectionReason: json['rejection_reason'],
      scImage: json['sc_image'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class CoinModel {
  final int id;
  final String name;
  final String symbol;

  CoinModel({required this.id, required this.name, required this.symbol});

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: _parseInt(json['id']),
      name: json['name'] ?? '',
      symbol: json['symbol'] ?? '',
    );
  }
}

// ---------- Filters & Pagination ----------
class FiltersModel {
  final String? type;
  final String? status;
  final int? coinId;
  final String? startDate;
  final String? endDate;
  final String? search;
  final String sort;
  final int perPage;

  FiltersModel({
    this.type,
    this.status,
    this.coinId,
    this.startDate,
    this.endDate,
    this.search,
    required this.sort,
    required this.perPage,
  });

  factory FiltersModel.fromJson(Map<String, dynamic> json) {
    return FiltersModel(
      type: json['type'],
      status: json['status'],
      coinId: json['coin_id'] != null ? _parseInt(json['coin_id']) : null,
      startDate: json['start_date'],
      endDate: json['end_date'],
      search: json['search'],
      sort: json['sort'] ?? 'desc',
      perPage: _parseInt(json['per_page']),
    );
  }
}

class PaginationModel {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;

  PaginationModel({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: _parseInt(json['current_page']),
      lastPage: _parseInt(json['last_page']),
      perPage: _parseInt(json['per_page']),
      total: _parseInt(json['total']),
      from: _parseInt(json['from']),
      to: _parseInt(json['to']),
    );
  }
}
