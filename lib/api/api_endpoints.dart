class ApiEndpoints {
  static const String baseUrl = "https://gccltd.in/api";
  //---------------------------------------------------------------------------

  //Home Screen API
  static const String homeScreen = "$baseUrl/homescreen";
  static const String banners = "$baseUrl/banners";
  static const String tradingCoins = "$baseUrl/trading/coins";
  static const String coinSummary = "$baseUrl/coin/summary";
  static const String sellTrading = "$baseUrl/trading/sell";


  //Notifications 
  static const String notifications = "$baseUrl/notifications?type=unread";
  static const String notificationsUnreadCount = '/notifications/unread-count';

  static const String buyCoin = "$baseUrl/trading/buy";

  // Auth APIs
  static const String login = "$baseUrl/login";
  static const String verifyLoginOtp = "$baseUrl/login/verify-otp";
  static const String resendOtp = "$baseUrl/login/resend-otp";
  static const String register = "$baseUrl/register";
  static const String verifyOtp = "$baseUrl/verify-otp";
  static const String resendOtpSignup = "$baseUrl/resend-otp";

  // Profile API
  static const String dashboardOverview = "$baseUrl/dashboard/overview";
  static const String updateProfile = "$baseUrl/kyc/update-profile";
  // KYC APIs
  static const String kycDetails = "$baseUrl/kyc/details";
  static const String kycSubmit = "$baseUrl/kyc/submit";
  static const String kycAadhaarSave = "$baseUrl/kyc/aadhaar/save";
  static const String kycPanSave = "$baseUrl/kyc/pan/save";
  static const String kycBankVerify = "$baseUrl/kyc/bank/verify";

  //Invite Screen API
  static const String inviteScreen = "$baseUrl/invite-screen";
  static const String inviteIntroduction = "$baseUrl/invite-introduction";

  // Transaction API
  static const String transactions = "$baseUrl/dashboard/transactions";

  // Earn Rewards API
  static const String earnRewards = "$baseUrl/earn-rewards";
  static const String claimTrackImpact = "$baseUrl/claim-track-your-impact";
  static const String trackImpact = "$baseUrl/track-your-impact";
  static const String claimBuyReward = "$baseUrl/claim-buy-reward";
  static const String claimReferral = "$baseUrl/claim-referral";

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


  // Payment APIs
  static const String createOrder = "$baseUrl/payment/create-order";
  static const String verifyPayment = "$baseUrl/payment/verify";
}
