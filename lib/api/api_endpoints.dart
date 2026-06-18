class ApiEndpoints {
  static const String baseUrl = "https://gccltd.in/api";
  //---------------------------------------------------------------------------

  //Home Screen API
  static const String homeScreen = "$baseUrl/homescreen";
  static const String banners = "$baseUrl/banners";
  static const String tradingCoins = "$baseUrl/trading/coins";
  static const String coinSummary = "$baseUrl/coin/summary";
  static const String sellTrading = "$baseUrl/trading/sell";

  //Buy Screen API
  static const String paymentsDeposits = "$baseUrl/payments/deposits";

  // Auth APIs
  static const String login = "$baseUrl/login";
  static const String verifyLoginOtp = "$baseUrl/login/verify-otp";
  static const String register = "$baseUrl/register";
  static const String verifyOtp = "$baseUrl/verify-otp";

  // Profile API
  static const String dashboardOverview = "$baseUrl/dashboard/overview";
  static const String updateProfile = "$baseUrl/kyc/update-profile";
  // KYC APIs
  static const String kycDetails = "$baseUrl/kyc/details";
  static const String kycSubmit = "$baseUrl/kyc/submit";
  static const String kycAadhaarSave = "$baseUrl/kyc/aadhaar/save";
  static const String kycPanSave = "$baseUrl/kyc/pan/save";
  static const String kycBankVerify = "$baseUrl/kyc/bank/verify";

  // Transaction API
  static const String transactions = "$baseUrl/dashboard/transactions";

  // Earn Rewards API
  static const String earnRewards = "$baseUrl/earn-rewards";
  static const String claimTrackImpact = "$baseUrl/claim-track-your-impact";
  static const String trackImpact = "$baseUrl/track-your-impact";

  // Reward Status Summary (replaces old daily login status)
  static const String rewardStatusSummary = "$baseUrl/reward-status-summary";

  // Claim daily login reward
  static const String claimLoginReward = "$baseUrl/claim-login-reward";

  // Contribute Screen API
  static const String portfolio = "$baseUrl/portfolio";

  // Impact Summary API
  static const String impactSummary = "$baseUrl/impact-summary";

  // Scratch Coupon APIs
  static const String coupons = "$baseUrl/coupons";
  static const String scratchCoupon = "$baseUrl/scratch-coupon";
}
