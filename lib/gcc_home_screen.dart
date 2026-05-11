import 'package:flutter/material.dart';
import 'package:gcc/Homescreen/Redeem_screen.dart';
import 'package:gcc/Homescreen/resell_exchange_screen.dart';
import 'package:gcc/buy_gcc_units_screen.dart';
import 'package:gcc/daily_streak_card.dart';
import 'package:gcc/earn_rewards_screen.dart';

class GCCHomeScreen extends StatefulWidget {
  const GCCHomeScreen({super.key});

  @override
  State<GCCHomeScreen> createState() => _GCCHomeScreenState();
}

class _GCCHomeScreenState extends State<GCCHomeScreen> {
  int _selectedIndex = 0;

  static const Color primaryGreen = Color(0xFF1B6B2F);
  static const Color lightGreen = Color(0xFF4CAF50);
  static const Color bgColor = Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildWelcomeBanner(),
                    const SizedBox(height: 12),
                    _buildGetStartedCard(),
                    const SizedBox(height: 12),
                    _buildDigitalForestCard(),
                    const SizedBox(height: 12),
                    _buildGCCUnitsCard(),
                    const SizedBox(height: 12),
                    DailyStreakCard(),
                    const SizedBox(height: 16),
                    _buildHowItWorksSection(),
                    const SizedBox(height: 16),
                    _buildQuickActionsSection(),
                    const SizedBox(height: 12),
                    _buildDisclaimerCard(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            //  _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  // ─── TOP BAR ───────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const Icon(Icons.menu, color: Colors.black87, size: 26),
          Column(
            children: [
              Row(
                children: [
                  const Text(
                    'GCC',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: primaryGreen,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 2),
                  // Leaf icon next to GCC
                  Transform.rotate(
                    angle: -0.3,
                    child: const Icon(Icons.eco, color: lightGreen, size: 18),
                  ),
                ],
              ),
              const Text(
                'Green Contribution Certificate',
                style: TextStyle(fontSize: 9, color: Colors.grey),
              ),
            ],
          ),
          Stack(
            children: [
              const Icon(
                Icons.notifications_outlined,
                size: 28,
                color: Colors.black87,
              ),
              Positioned(
                right: 0,
                top: 0,
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
        ],
      ),
    );
  }

  // ─── WELCOME BANNER ────────────────────────────────────────────────────────
  Widget _buildWelcomeBanner() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.eco, color: primaryGreen, size: 22),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, Rahul!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                'Let\'s start your green journey today.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── GET STARTED CARD ──────────────────────────────────────────────────────
  Widget _buildGetStartedCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.park, color: primaryGreen, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Take your first step!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Buy GCC Units to grow your Digital Forest.',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            child: const Text(
              'Get Started',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ─── DIGITAL FOREST CARD ───────────────────────────────────────────────────
  Widget _buildDigitalForestCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B6B2F), Color(0xFF2E8B57), Color(0xFF4CAF50)],
        ),
      ),
      child: Column(
        children: [
          // Forest illustration area
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Container(
                  height: 160,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF2E8B57), Color(0xFF4CAF50)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Sky
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xFF87CEEB), Color(0xFFB8E4A3)],
                            ),
                          ),
                        ),
                      ),
                      // Birds (simple dots)
                      const Positioned(top: 20, right: 60, child: _BirdIcon()),
                      const Positioned(top: 30, right: 40, child: _BirdIcon()),
                      const Positioned(top: 15, right: 100, child: _BirdIcon()),
                      // Trees in background
                      Positioned(
                        bottom: 0,
                        left: 20,
                        child: _TreeWidget(
                          height: 60,
                          color: const Color(0xFF1B6B2F),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 60,
                        child: _TreeWidget(
                          height: 80,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                      // Main big sprout center-right
                      Positioned(bottom: 0, right: 20, child: _SproutWidget()),
                      // Text overlay
                      const Positioned(
                        top: 16,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Your Digital Forest ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('🌳', style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            Text(
                              'Start today, create a greener tomorrow.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Stats row
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Row(
                          children: [
                            _ForestStat(
                              label: 'Trees Supported',
                              value: '0',
                              emoji: '🌳',
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: Colors.white38,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                            ),
                            _ForestStat(
                              label: 'CO₂ Offset',
                              value: '0 kg',
                              emoji: '☁️',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Milestone card
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Next Milestone: 10 Trees',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0,
                          backgroundColor: Colors.grey[200],
                          color: primaryGreen,
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '0%',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Complete your first contribution to unlock this milestone.',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // GCC Units
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryGreen.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_bag_outlined,
                        color: primaryGreen,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GCC Units',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Text(
                          '0',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Units',
                          style: TextStyle(
                            fontSize: 11,
                            color: primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Divider
              Container(width: 1, height: 60, color: Colors.grey[200]),
              // Eco-Rewards
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.card_giftcard,
                          color: Colors.orange,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Eco-Rewards',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            '0',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Points',
                            style: TextStyle(
                              fontSize: 11,
                              color: primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Buy GCC Units
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BuyGCCUnitsScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chevron_left, size: 16),
                      SizedBox(width: 4),
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Column(
                        children: [
                          Text(
                            'Buy GCC Units',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Start your impact',
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Redeem Rewards
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RedeemRewardsScreen(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryGreen,
                    side: const BorderSide(color: primaryGreen),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.card_giftcard_outlined,
                            size: 18,
                            color: primaryGreen,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Redeem Rewards',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: primaryGreen,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Use points for exciting offers',
                        style: TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── DAILY STREAK CARD ─────────────────────────────────────────────────────
  Widget _buildDailyStreakCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text('🔥', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Action Streak',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Complete 1 action today & earn 50 Eco-Rewards',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (i) => _StreakDot(index: i + 1, active: i == 0),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4EDDA),
                        foregroundColor: primaryGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        'Start Now',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Gift box illustration
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('🎁', style: TextStyle(fontSize: 38)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── HOW IT WORKS ──────────────────────────────────────────────────────────
  Widget _buildHowItWorksSection() {
    final steps = [
      {'icon': Icons.shopping_bag_outlined, 'label': 'Buy GCC\nUnits'},
      {'icon': Icons.eco_outlined, 'label': 'Grow Your\nDigital Forest'},
      {'icon': Icons.workspace_premium_outlined, 'label': 'Earn\nEco-Rewards'},
      {'icon': Icons.card_giftcard, 'label': 'Redeem\nExciting Offers'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "New Here? Here's how it works",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 18),

          Row(
            children: List.generate(steps.length, (i) {
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9), // light green
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  steps[i]['icon'] as IconData,
                                  color: primaryGreen,
                                  size: 26,
                                ),
                              ),

                              Positioned(
                                bottom: -2,
                                left: -2,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: primaryGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${i + 1}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          Text(
                            steps[i]['label'] as String,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11, height: 1.3),
                          ),
                        ],
                      ),
                    ),

                    if (i < steps.length - 1)
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey,
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quick Actions",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _quickCard(
                  icon: Icons.eco,
                  title: "My Impact",
                  subtitle: "",
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResellExchangeScreen(),
                      ),
                    );
                  },
                  child: _quickCard(
                    icon: Icons.swap_horiz,
                    title: "Resell / Exchange",
                    subtitle: "GCC Units",
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _quickCard(
                  icon: Icons.group,
                  title: "Invite Friends",
                  subtitle: "Earn Rewards",
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _quickCard(
                  icon: Icons.headset_mic,
                  title: "Help & Support",
                  subtitle: "",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      height: 110, // 👈 SAME HEIGHT for all cards
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green, size: 26),
          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),

          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  // ─── DISCLAIMER CARD ───────────────────────────────────────────────────────
  Widget _buildDisclaimerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: primaryGreen,
            size: 18,
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'GCC Units are digital eco-vouchers for ecosystem contribution.\nNo investment. No guaranteed returns. Not a financial instrument.',
              style: TextStyle(fontSize: 10, color: Colors.grey, height: 1.4),
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              const Text(
                'Know More',
                style: TextStyle(
                  color: primaryGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Icon(Icons.chevron_right, color: primaryGreen, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  // ─── BOTTOM NAV BAR ────────────────────────────────────────────────────────
  Widget _buildBottomNavBar() {
    final items = [
      {'icon': Icons.home, 'label': 'Home'},
      {'icon': Icons.stars_outlined, 'label': 'Earn Rewards'},
      {'icon': Icons.card_giftcard_outlined, 'label': 'Rewards Store'},
      {'icon': Icons.person_outline, 'label': 'Profile'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = _selectedIndex == i;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedIndex = i);
                  if (i == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EarnRewardsScreen(),
                      ),
                    );
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      items[i]['icon'] as IconData,
                      color: selected ? primaryGreen : Colors.grey,
                      size: 24,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      items[i]['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: selected ? primaryGreen : Colors.grey,
                        fontWeight:
                            selected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
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
      style: TextStyle(color: Colors.black45, fontSize: 10),
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
    // Triangle top
    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height * 0.6);
    path.lineTo(size.width, size.height * 0.6);
    path.close();
    canvas.drawPath(path, paint);

    // Trunk
    final trunkPaint = Paint()..color = const Color(0xFF5D4037);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.4,
        size.height * 0.6,
        size.width * 0.2,
        size.height * 0.4,
      ),
      trunkPaint,
    );
  }

  @override
  bool shouldRepaint(_TreePainter old) => old.color != color;
}

class _SproutWidget extends StatelessWidget {
  const _SproutWidget();

  @override
  Widget build(BuildContext context) {
    return const Text('🌱', style: TextStyle(fontSize: 70));
  }
}

class _ForestStat extends StatelessWidget {
  final String label;
  final String value;
  final String emoji;
  const _ForestStat({
    required this.label,
    required this.value,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(emoji, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}

class _StreakDot extends StatelessWidget {
  final int index;
  final bool active;
  const _StreakDot({required this.index, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: active ? const Color(0xFF1B6B2F) : Colors.transparent,
        border: Border.all(
          color: active ? const Color(0xFF1B6B2F) : Colors.grey.shade300,
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$index',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: active ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}
