import 'package:flutter/material.dart';
import 'package:gcc/Homescreen/HomeScreen.dart';
import 'package:gcc/Homescreen/contribute.dart';
import 'package:gcc/Homescreen/market.dart';
import 'package:gcc/Homescreen/profile.dart';
import 'package:gcc/Homescreen/rewards.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const MarketplaceScreen(),
    const ContributeScreen(),
    const EcoRewardsScreen(),
    const ProfileScreen(),
    const Center(child: Text("Market Screen")),
    const Center(child: Text("Contribute Screen")),
    const Center(child: Text("Rewards Screen")),
    const Center(child: Text("Profile Screen")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 🔥 Screen Switch
      body: _screens[_currentIndex],

      /// 🔻 Bottom Navbar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },

          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,

          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          showUnselectedLabels: true,

          items: const [
            /// 🏠 Home
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),

            /// 📊 Market
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
              label: "Market",
            ),

            /// ➕ Contribute
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: "Contribute",
            ),

            /// 🎁 Rewards
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard_outlined),
              activeIcon: Icon(Icons.card_giftcard),
              label: "Rewards",
            ),

            /// 👤 Profile
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
