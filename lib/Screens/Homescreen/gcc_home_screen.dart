import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcc/Models_nServices/Notification_count/count_svc.dart';
import 'package:gcc/Navbar/navbar.dart';
import 'package:gcc/Screens/Homescreen/Redeem_screen.dart';
import 'package:gcc/Screens/Homescreen/notification_screen.dart';
import 'package:gcc/Screens/Homescreen/resell_&_exchange.dart';
import 'package:gcc/Screens/Homescreen/buy_gcc_units_screen.dart';
import 'package:gcc/Models_nServices/home_screen/home_screen_model.dart';
import 'package:gcc/Models_nServices/home_screen/home_screen_svc.dart';
import 'package:gcc/Models_nServices/notification/notification_svc.dart';
import 'package:gcc/Screens/profile/help_n_support.dart';
import 'package:gcc/Screens/profile/my_impacts.dart';
import 'package:gcc/Screens/profile/referral_screen.dart';
import 'package:gcc/Screens/reward/rewards_store_screen.dart';
import 'package:gcc/exception/daily_streak_card.dart';
import 'package:gcc/Screens/earn/earn_rewards_screen.dart';
import 'package:gcc/main.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/prefs/PreferencesKey.dart';

// ---------- Import your DioClient ----------
// If you have a DioClient class, use this:
import 'package:gcc/api/dio_client.dart';
// OR if you don't, use direct Dio with base URL:
// import 'package:dio/dio.dart';
// import 'package:gcc/api/api_endpoints.dart';
// -------------------------------------------

class GCCHomeScreen extends StatefulWidget {
  const GCCHomeScreen({super.key});

  @override
  State<GCCHomeScreen> createState() => _GCCHomeScreenState();
}

class _GCCHomeScreenState extends State<GCCHomeScreen> with RouteAware {
  static const Color primaryGreen = Color(0xFF1B6B2F);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color bgColor = Color(0xFFF5F5F5);
  static const Color purpleColor = Color(0xFF6B3FA0);

  bool _isLoading = true;
  String? _errorMessage;
  HomeScreenData? _homeScreenData;
  HomeScreenUser? _homeScreenUser;
  String _userName = '';
  double? _walletInrBalance;

  // ─── Notification count ──────────────────────────────────────────
  int _notificationCount = 0;

  // ✅ Instantiate service with required dependencies (like in RedeemScreen)
  final UnreadNotificationService _notificationService = UnreadNotificationService(
    DioClient.dio,      // <-- use your static Dio instance
    AppPreference(),
  );

  // 🔄 Alternative if you don't have DioClient:
  // final NotificationService _notificationService = NotificationService(
  //   Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl)),
  //   AppPreference(),
  // );

  @override
  void initState() {
    super.initState();
    _loadHomeScreen();
    _fetchNotificationCount(); // fetch count on load
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // ─── Refresh notification count when we come back ──────────────────
  @override
  void didPopNext() {
    _fetchNotificationCount();
  }

  // ─── Load home screen data ────────────────────────────────────────────
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
          _homeScreenUser = response.data!.user;
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

  // ─── Fetch unread notification count ────────────────────────────────
  Future<void> _fetchNotificationCount() async {
    try {
      final response = await _notificationService.fetchUnreadCount();
      if (mounted) {
        setState(() {
          _notificationCount = response.data.unreadCount;
        });
      }
    } catch (e) {
      // Silently fail – keep existing count or set to 0
      print('Notification count error: $e');
      if (mounted) {
        setState(() => _notificationCount = 0);
      }
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
                    _buildQuickActionsSection(),
                    const SizedBox(height: 12),
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
        false;
  }

  // ─── TOP BAR WITH NOTIFICATION COUNT ─────────────────────────────────────
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

            /// Notification Icon with dynamic badge
            Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
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
                    // ─── Dynamic Badge ────────────────────────────────
                    if (_notificationCount > 0)
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
                          child: Center(
                            child: Text(
                              _notificationCount > 9
                                  ? '9+'
                                  : _notificationCount.toString(),
                              style: const TextStyle(
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
  
  // ─── HERO FOREST CARD (unchanged) ──────────────────────────────────────
 Widget _buildHeroForestCard() {
  // ─── Dynamic Progress Calculation ────────────────────
  final treeValue = _homeScreenData?.treeValue ?? 0;
  final nextTree = _homeScreenData?.nextTree ?? 0;
  double progress = 0.0;
  String percentText = '0%';

  if (nextTree > 0) {
    progress = (treeValue / nextTree).clamp(0.0, 1.0);
    percentText = '${(progress * 100).toInt()}%';
  }

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
            /// ─── HERO IMAGE SECTION ──────────────────────
            SizedBox(
              height: 220,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/Images/hero_screen.png',
                      fit: BoxFit.cover,
                    ),
                  ),
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
                  Positioned(
                    top: 75,
                    right: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

            /// ─── BOTTOM STATS SECTION ────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                        value: '${_homeScreenUser?.co2 ?? 0}',
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

                  /// ─── DYNAMIC PROGRESS BAR ──────────────
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white24,
                      color: lightGreen,
                      minHeight: 8,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// ─── DYNAMIC PERCENTAGE TEXT ────────────
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 11, color: Colors.white70),
                      children: [
                        const TextSpan(text: 'You are '),
                        TextSpan(
                          text: percentText,
                          style: const TextStyle(
                            color: Color(0xFF76FF03),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(text: ' closer to your next milestone!'),
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
  // ─── GCC UNITS CARD (unchanged) ────────────────────────────────────────
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
}

// ─── HELPER WIDGETS (unchanged) ──────────────────────────────────────────

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