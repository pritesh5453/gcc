import 'package:flutter/material.dart';
import 'package:gcc/contribute/contribute_screen.dart';
import 'package:gcc/profile/profile.dart';
import 'package:gcc/earn/earn_rewards_screen.dart';
import 'package:gcc/Homescreen/gcc_home_screen.dart';
import 'package:gcc/reward/rewards_store_screen.dart';

class MainScreen extends StatefulWidget {
  final Widget? child;
  final int initialIndex;

  const MainScreen({super.key, this.child, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    GCCHomeScreen(), // index 0 - Home
    EarnRewardsScreen(), // index 1 - Earn
    PortfolioScreen(), // index 2 - Contribute/Portfolio
    RewardsStoreScreen(), // index 3 - Rewards
    ProfileScreen(), // index 4 - Profile
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          widget.child != null
              ? widget.child!
              : IndexedStack(index: _currentIndex, children: _screens),
      extendBody: true,
      bottomNavigationBar:
          widget.child == null
              ? Container(
                height: 90,
                margin: const EdgeInsets.fromLTRB(15, 0, 15, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.home_outlined, "Home", 0),
                    _buildNavItem(Icons.stars_outlined, "Earn", 1),
                    _buildCenterNavItem(2),
                    _buildNavItem(Icons.card_giftcard_outlined, "Rewards", 3),
                    _buildNavItem(Icons.person_outline, "Profile", 4),
                  ],
                ),
              )
              : null,
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color:
                  isSelected
                      ? const Color(0xFF1B6B2F)
                      : const Color(0xFF7D848D),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color:
                    isSelected
                        ? const Color(0xFF1B6B2F)
                        : const Color(0xFF7D848D),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterNavItem(int index) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.translate(
            offset: const Offset(0, -15),
            child: Container(
              height: 55,
              width: 55,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF76B852), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x4D4CAF50),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.eco, color: Colors.white, size: 30),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -8),
            child: Text(
              "Contribute",
              style: TextStyle(
                fontSize: 12,
                color:
                    isSelected
                        ? const Color(0xFF1B6B2F)
                        : const Color(0xFF1B6B2F),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
