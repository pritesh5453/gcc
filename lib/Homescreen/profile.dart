import 'package:flutter/material.dart';
import 'package:gcc/Auth/login.dart';
import 'package:gcc/Navbar/navbar.dart';
import 'package:gcc/profile/account_security_screen.dart';
import 'package:gcc/profile/edit_profile.dart';
import 'package:gcc/profile/green_chain.dart';
import 'package:gcc/profile/help_n_support.dart';
import 'package:gcc/profile/my_impacts.dart';
import 'package:gcc/profile/transaction_record_screen.dart';
import 'package:gcc/profile/wallet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Column(
          children: [
            Text(
              'Profile',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              'Manage your account and preferences',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 20),
              _buildImpactStats(),
              const SizedBox(height: 20),
              _buildContributorBanner(),
              const SizedBox(height: 20),
              _buildMenuSection([
                _MenuAction(
                  Icons.person_outline,
                  'Edit Profile',
                  'Update your personal information',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                _MenuAction(
                  Icons.security_outlined,
                  'Account & Security',
                  'Manage password and security settings',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountSecurityScreen(),
                      ),
                    );
                  },
                ),
                _MenuAction(
                  Icons.card_giftcard,
                  'My Rewards',
                  'View your points, rewards and withdrawals',
                  onTap: () {
                    // Navigate to Rewards tab in MainScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => const MainScreen(
                              initialIndex: 3,
                            ), // 3 = RewardsStoreScreen
                      ),
                    );
                  },
                ),
                _MenuAction(
                  Icons.eco_outlined,
                  'My Impact',
                  'See your contribution and environmental impact',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyImpactScreen(),
                      ),
                    );
                  },
                ),
                _MenuAction(
                  Icons.history,
                  'Transaction History',
                  'View all your transactions and payments',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TransactionHistoryScreen(),
                      ),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 16),
              _buildMenuSection([
                _MenuAction(
                  Icons.notifications_none,
                  'Notifications',
                  'Manage your notification preferences',
                ),
                _MenuAction(
                  Icons.help_outline,
                  'Help & Support',
                  'Get help and find answers',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpSupportScreen(),
                      ),
                    );
                  },
                ),
                _MenuAction(
                  Icons.account_balance_wallet,
                  'Wallet',
                  'Account and Wallet balance details',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WalletScreen(),
                      ),
                    );
                  },
                ),
                _MenuAction(
                  Icons.info_outline,
                  'About GreenChain',
                  'Learn more about our mission',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutGreenChainScreen(),
                      ),
                    );
                  },
                ),
                _MenuAction(
                  Icons.logout,
                  'Log Out',
                  'Sign out from your account',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MobileLoginScreen(),
                      ),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 16),
              _buildInviteCard(),
              const SizedBox(height: 20), // Adjusted for better spacing
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rahul Sharma',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Text(
                  'rahulsharma@gmail.com',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const Text(
                  '+91 98765 43210',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.eco, size: 14, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        'Eco Warrior',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildImpactStats() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(Icons.park_outlined, '55', 'Trees Supported'),
          _buildStatItem(Icons.co2_outlined, '12 kg', 'CO₂ Offset'),
          _buildStatItem(Icons.park_rounded, '1,850', 'Eco-Points'),
          _buildStatItem(
            Icons.verified_user_outlined,
            'May 2024',
            'Member Since',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.green[700], size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildContributorBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Text('👑', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You're a Green Contributor! 🌿",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Keep going! Your small actions create a big impact.",
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              children: [
                Text('View Progress', style: TextStyle(fontSize: 12)),
                Icon(Icons.chevron_right, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(List<_MenuAction> actions) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children:
            actions.map((action) {
              final isLast = actions.indexOf(action) == actions.length - 1;
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          action.isDestructive
                              ? Colors.red[50]
                              : Colors.green[50],
                      child: Icon(
                        action.icon,
                        color:
                            action.isDestructive
                                ? Colors.red
                                : Colors.green[700],
                        size: 20,
                      ),
                    ),
                    title: Text(
                      action.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      action.subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: Colors.grey,
                    ),
                    onTap: action.onTap,
                  ),
                  if (!isLast)
                    Divider(height: 1, indent: 70, color: Colors.grey.shade100),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildInviteCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.public, color: Colors.blue, size: 40),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Invite Friends, Grow More Trees! 🌳',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  'Invite your friends and earn exciting rewards.',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, size: 14),
            label: const Text('Invite Now', style: TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green[700],
              side: BorderSide(color: Colors.green[700]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuAction {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDestructive;
  final VoidCallback? onTap;

  _MenuAction(
    this.icon,
    this.title,
    this.subtitle, {
    this.isDestructive = false,
    this.onTap,
  });
}
