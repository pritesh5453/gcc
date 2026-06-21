import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- ADDED for SystemNavigator
import 'package:gcc/Navbar/navbar.dart';
import 'package:gcc/Screens/Homescreen/Redeem_screen.dart';
import 'package:gcc/Screens/Homescreen/resell_&_exchange.dart';
import 'package:gcc/Screens/Homescreen/buy_gcc_units_screen.dart';
import 'package:gcc/Models_nServices/home_screen/home_screen_model.dart';
import 'package:gcc/Models_nServices/home_screen/home_screen_svc.dart';
import 'package:gcc/Screens/profile/help_n_support.dart';
import 'package:gcc/Screens/profile/my_impacts.dart';
import 'package:gcc/Screens/profile/referral_screen.dart';
import 'package:gcc/Screens/reward/rewards_store_screen.dart';
import 'package:gcc/exception/daily_streak_card.dart';
import 'package:gcc/Screens/earn/earn_rewards_screen.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/prefs/PreferencesKey.dart';

class GCCHomeScreen extends StatefulWidget {
  const GCCHomeScreen({super.key});

  @override
  State<GCCHomeScreen> createState() => _GCCHomeScreenState();
}

class _GCCHomeScreenState extends State<GCCHomeScreen> {
  static const Color primaryGreen = Color(0xFF1B6B2F);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color bgColor = Color(0xFFF5F5F5);
  static const Color purpleColor = Color(0xFF6B3FA0);

  bool _isLoading = true;
  String? _errorMessage;
  HomeScreenData? _homeScreenData;
  String _userName = '';
  double? _walletInrBalance;

  @override
  void initState() {
    super.initState();
    _loadHomeScreen();
  }

  // Future<void> _loadWalletDetails() async {
  //   try {
  //     final resp = await fetchWalletDetails();
  //     if (resp.success == true && resp.data?.walletBalance != null) {
  //       setState(() {
  //         _walletInrBalance = resp.data!.walletBalance!.inrBalance ?? 0.0;
  //       });
  //     }
  //   } catch (e) {
  //     // silently ignore wallet fetch errors; top bar will show placeholder
  //     debugPrint('Wallet fetch error: $e');
  //   }
  // }

  Future<void> _loadHomeScreen() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await fetchHomeScreen();
      if (response.success == true && response.data != null) {
        setState(() {
          _homeScreenData = response.data!.homeScreen;
          _userName =
              response.data!.user?.name ??
              AppPreference().getString(PreferencesKey.userName);
        });
      } else {
        setState(() {
          _errorMessage = response.message ?? 'Failed to load home data';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Auth Token: ${AppPreference().getString(PreferencesKey.authToken)}');
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(minHeight: 3),
              ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 12),
                  ),
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    _buildHeroForestCard(),
                    const SizedBox(height: 12),
                    _buildGCCUnitsCard(),
                    const SizedBox(height: 12),
                    // _buildDailyActionCard(),
                    const SizedBox(height: 12),
                    _buildQuickActionsSection(),
                    const SizedBox(height: 12),
                    // _buildLeaderboardBanner(),
                    // const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── EXIT CONFIRMATION DIALOG ─────────────────────────────────────────────
  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Exit App?'),
                content: const Text('Are you sure you want to exit the app?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false; // if dialog dismissed (tap outside), treat as "No"
  }

  // ─── TOP BAR WITH WALLET AMOUNT ───────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// Center Logo + Text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.eco, color: lightGreen, size: 20),
                    SizedBox(width: 4),
                    Text(
                      'GCC',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: primaryGreen,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Green Contribution Certificate',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),

            /// Wallet Section (commented out)
            // Positioned(
            //   left: 0,
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (_) => const WalletScreen()),
            //       );
            //     },
            //     child: Container(
            //       width: 100,
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 8,
            //         vertical: 6,
            //       ),
            //       decoration: BoxDecoration(
            //         color: primaryGreen.withOpacity(0.1),
            //         borderRadius: BorderRadius.circular(14),
            //         border: Border.all(color: primaryGreen.withOpacity(0.3)),
            //       ),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           Row(
            //             children: const [
            //               Icon(
            //                 Icons.account_balance_wallet_outlined,
            //                 size: 12,
            //                 color: primaryGreen,
            //               ),
            //               SizedBox(width: 4),
            //               Text(
            //                 'Wallet',
            //                 style: TextStyle(
            //                   fontSize: 8,
            //                   color: Colors.grey,
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               ),
            //             ],
            //           ),
            //           const SizedBox(height: 2),
            //           Text(
            //             _walletInrBalance != null
            //                 ? '₹${_walletInrBalance!.toStringAsFixed(2)}'
            //                 : '₹--',
            //             maxLines: 1,
            //             overflow: TextOverflow.ellipsis,
            //             style: const TextStyle(
            //               fontSize: 15,
            //               fontWeight: FontWeight.bold,
            //               color: primaryGreen,
            //             ),
            //           ),
            //           const SizedBox(height: 1),
            //           // Text(
            //           //   '${_homeScreenData?.totalGccUnitsOwned ?? 0} GCC',
            //           //   maxLines: 1,
            //           //   overflow: TextOverflow.ellipsis,
            //           //   style: const TextStyle(
            //           //     fontSize: 8,
            //           //     fontWeight: FontWeight.w600,
            //           //     color: primaryGreen,
            //           //   ),
            //           // ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            /// Notification Icon
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notifications coming soon!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        size: 22,
                        color: Colors.black87,
                      ),
                    ),
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── HERO FOREST CARD ──────────────────────────────────────────────────────
  Widget _buildHeroForestCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withOpacity(0.25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
          child: Column(
            children: [
              /// HERO IMAGE SECTION
              SizedBox(
                height: 220,
                child: Stack(
                  children: [
                    /// Background Image
                    Positioned.fill(
                      child: Image.asset(
                        'assets/Images/hero_screen.png',
                        fit: BoxFit.cover,
                      ),
                    ),

                    /// Dark Overlay for better text visibility
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.black.withOpacity(0.45),
                              Colors.black.withOpacity(0.15),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// Hello Text
                    Positioned(
                      top: 18,
                      left: 18,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.eco,
                            color: Color(0xFFB2FF59),
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Hello, ${_userName.isNotEmpty ? _userName : 'Friend'}!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Main Heading
                    const Positioned(
                      top: 45,
                      left: 18,
                      child: Text(
                        'Grow Your\nDigital Forest',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                    ),

                    /// Subtitle
                    const Positioned(
                      top: 125,
                      left: 18,
                      child: Text(
                        'Your small steps create\na big impact.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    /// You're Doing Great Badge
                    Positioned(
                      top: 75,
                      right: 18,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: primaryGreen.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            Text(
                              "You're doing\nGreat! 🌿",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// BOTTOM STATS SECTION
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: const BoxDecoration(color: Color(0xFF1B5E20)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _ForestStatNew(
                          icon: Icons.park,
                          label: 'Trees Supported',
                          value: '${_homeScreenData?.treeValue ?? 0}',
                          unit: 'Trees',
                        ),
                        Container(width: 1, height: 50, color: Colors.white24),
                        _ForestStatNew(
                          icon: Icons.cloud_outlined,
                          label: 'CO₂ Offset',
                          value: '${_homeScreenData?.totalCo2Impact ?? 0}',
                          unit: 'kg',
                        ),
                        Container(width: 1, height: 50, color: Colors.white24),
                        _ForestStatNew(
                          icon: Icons.flag_outlined,
                          label: 'Next Milestone',
                          value: '${_homeScreenData?.nextTree ?? 0}',
                          unit: 'Trees',
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: 0.85,
                        backgroundColor: Colors.white24,
                        color: lightGreen,
                        minHeight: 8,
                      ),
                    ),

                    const SizedBox(height: 8),

                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 11, color: Colors.white70),
                        children: [
                          TextSpan(text: 'You are '),
                          TextSpan(
                            text: '85%',
                            style: TextStyle(
                              color: Color(0xFF76FF03),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(text: ' closer to your next milestone!'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── GCC UNITS CARD ────────────────────────────────────────────────────────
  Widget _buildGCCUnitsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // GCC Units
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'GCC Units',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.info_outline,
                          size: 14,
                          color: Colors.grey.shade400,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryGreen.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.eco,
                            color: primaryGreen,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_homeScreenData?.totalGccUnitsOwned?.toStringAsFixed(2) ?? "0.00"}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const Text(
                              'Units',
                              style: TextStyle(
                                fontSize: 12,
                                color: primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: primaryGreen.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Current Price : ',
                            style: TextStyle(
                              fontSize: 11,
                              color: primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              '₹${(_homeScreenData?.currentGccUnitPrice ?? 0).toStringAsFixed(2)} / Unit',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Divider
              Container(width: 1, height: 90, color: Colors.grey[200]),
              // Eco Rewards
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Eco Rewards',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: purpleColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.card_giftcard,
                              color: purpleColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '${_homeScreenData?.rewardPoints?.toStringAsFixed(0) ?? "0"}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const Text(
                                'Points',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: purpleColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BuyGCCUnitsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Buy GCC Units',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainScreen(initialIndex: 3),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.card_giftcard_outlined,
                    size: 17,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Redeem Rewards',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purpleColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Disclaimer
          Row(
            children: [
              const Icon(
                Icons.verified_user_outlined,
                color: primaryGreen,
                size: 14,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'GCC Units are digital eco-vouchers. Not an investment.',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Show learn more dialog
                  _showLearnMoreDialog(context);
                },
                child: const Row(
                  children: [
                    Text(
                      'Learn more',
                      style: TextStyle(
                        color: primaryGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.chevron_right, color: primaryGreen, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLearnMoreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('About GCC Units'),
            content: const Text(
              'Green Contribution Certificate (GCC) Units are digital eco-vouchers that represent your contribution to environmental sustainability. '
              'Each unit you purchase helps plant trees and offset carbon emissions. '
              'This is not a financial investment and does not guarantee any returns.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it'),
              ),
            ],
          ),
    );
  }

  // ─── DAILY ACTION CARD ─────────────────────────────────────────────────────
  Widget _buildDailyActionCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text('🔥', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8),
                    Text(
                      'Daily Action',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    children: [
                      Text('🔥', style: TextStyle(fontSize: 12)),
                      SizedBox(width: 4),
                      Text(
                        '5 Day Streak',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Action card inside
          Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FAF0),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: lightGreen.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: lightGreen.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('🪴', style: TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Water your tree today!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const Text(
                        'Small actions. Big difference.',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text(
                            '1/1 Completed',
                            style: TextStyle(
                              fontSize: 11,
                              color: primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: const LinearProgressIndicator(
                                value: 1.0,
                                backgroundColor: Color(0xFFDCEDC8),
                                color: primaryGreen,
                                minHeight: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    // Show completion dialog
                    _showCompletionDialog(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryGreen,
                    side: const BorderSide(color: primaryGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'Complete',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Row(
              children: [
                Text('🎉', style: TextStyle(fontSize: 24)),
                SizedBox(width: 8),
                Text('Task Completed!'),
              ],
            ),
            content: const Text(
              'Great job! You earned 10 Eco Points for completing your daily action. Keep up the momentum!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Awesome!'),
              ),
            ],
          ),
    );
  }

  // ─── QUICK ACTIONS ─────────────────────────────────────────────────────────
  Widget _buildQuickActionsSection() {
    final actions = [
      {
        'emoji': '🌍',
        'title': 'My Impact',
        'subtitle': 'View your impact',
        'screen': const MyImpactScreen(),
      },
      {
        'emoji': '♻️',
        'title': 'Exchange GCC',
        'subtitle': 'Resell units',
        'screen': const ExchangeGCCScreen(),
      },
      {
        'emoji': '👥',
        'title': 'Invite Friends',
        'subtitle': 'Earn rewards',
        'screen': const ReferralGrowthScreen(),
      },
      {
        'emoji': '🎧',
        'title': 'Help Center',
        'subtitle': 'Get support',
        'screen': const HelpSupportScreen(),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children:
              actions.map((a) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => a['screen'] as Widget,
                        ),
                      );
                    },
                    child: Container(
                      height: 140,
                      margin: EdgeInsets.only(
                        right: a == actions.last ? 0 : 12,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            a['emoji'] as String,
                            style: const TextStyle(fontSize: 28),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            a['title'] as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            a['subtitle'] as String,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  // ─── LEADERBOARD BANNER ────────────────────────────────────────────────────
  Widget _buildLeaderboardBanner() {
    return GestureDetector(
      onTap: () {
        // Navigate to leaderboard
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Leaderboard coming soon!'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Text('🏆', style: TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                  children: [
                    TextSpan(
                      text: 'You are ahead of 82% of users this week! 🎉\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: 'Keep going and lead the green movement.',
                      style: TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.orange,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── HELPER WIDGETS ──────────────────────────────────────────────────────────

class _BirdIcon extends StatelessWidget {
  const _BirdIcon();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '~',
      style: TextStyle(color: Colors.black45, fontSize: 12),
    );
  }
}

class _TreeWidget extends StatelessWidget {
  final double height;
  final Color color;
  const _TreeWidget({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(height * 0.6, height),
      painter: _TreePainter(color: color),
    );
  }
}

class _TreePainter extends CustomPainter {
  final Color color;
  const _TreePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height * 0.65);
    path.lineTo(size.width, size.height * 0.65);
    path.close();
    canvas.drawPath(path, paint);
    final trunkPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.4,
        size.height * 0.65,
        size.width * 0.2,
        size.height * 0.35,
      ),
      trunkPaint,
    );
  }

  @override
  bool shouldRepaint(_TreePainter old) => old.color != color;
}

// Hills background painter
class _HillsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF388E3C).withOpacity(0.5);
    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.25,
      0,
      size.width * 0.5,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width,
      size.height * 0.3,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    final paint2 = Paint()..color = const Color(0xFF2E7D32).withOpacity(0.4);
    final path2 = Path();
    path2.moveTo(0, size.height * 0.8);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.7,
    );
    path2.quadraticBezierTo(
      size.width * 0.8,
      size.height,
      size.width,
      size.height * 0.6,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(_HillsPainter old) => false;
}

class _ForestStatNew extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;

  const _ForestStatNew({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(unit, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }
}
