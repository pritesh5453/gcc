import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RedeemRewardsScreen extends StatefulWidget {
  const RedeemRewardsScreen({super.key});

  @override
  State<RedeemRewardsScreen> createState() => _RedeemRewardsScreenState();
}

class _RedeemRewardsScreenState extends State<RedeemRewardsScreen>
    with SingleTickerProviderStateMixin {
  static const Color primaryGreen = Color(0xFF1B6B2F);
  static const Color lightGreenBg = Color(0xFFF0FAF2);

  int _selectedNav = 2;
  int _selectedFilter = 0;
  late TabController _tabController;

  final List<String> _filters = ['All', 'Available', 'Redeemed', 'Expired'];

  final List<Map<String, dynamic>> _myRewards = [
    {
      'logo': 'amazon',
      'title': 'Amazon Pay eGift Card',
      'voucher': '₹100 Voucher',
      'points': '1,000',
      'bgColor': Color(0xFF131921),
      'status': 'available',
      'expiry': 'Expires: 31 Dec 2025',
      'code': 'AMZN-GCC-7823-XP',
    },
    {
      'logo': 'starbucks',
      'title': 'Starbucks eGift Card',
      'voucher': '₹150 Voucher',
      'points': '1,500',
      'bgColor': Color(0xFF00704A),
      'status': 'available',
      'expiry': 'Expires: 15 Nov 2025',
      'code': 'SBUX-GCC-3341-KY',
    },
    {
      'logo': 'flipkart',
      'title': 'Flipkart Gift Card',
      'voucher': '₹100 Voucher',
      'points': '1,000',
      'bgColor': Color(0xFF2874F0),
      'status': 'redeemed',
      'expiry': 'Redeemed: 01 May 2025',
      'code': 'FLIP-GCC-9910-MZ',
    },
    {
      'logo': 'bigbasket',
      'title': 'BigBasket Voucher',
      'voucher': '₹250 Voucher',
      'points': '2,500',
      'bgColor': Color(0xFFD4EDAB),
      'status': 'expired',
      'expiry': 'Expired: 28 Feb 2025',
      'code': 'BIGB-GCC-5521-RQ',
    },
    {
      'logo': 'plant',
      'title': 'Plant a Tree',
      'voucher': 'Contribute & Grow',
      'points': '500',
      'bgColor': Color(0xFFD6EED6),
      'status': 'redeemed',
      'expiry': 'Redeemed: 20 Apr 2025',
      'code': 'TREE-GCC-1102-GN',
    },
  ];

  List<Map<String, dynamic>> get _filteredRewards {
    if (_selectedFilter == 0) return _myRewards;
    final statusMap = {1: 'available', 2: 'redeemed', 3: 'expired'};
    return _myRewards.where((r) => r['status'] == statusMap[_selectedFilter]).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: _buildBalanceSummaryCard(),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: _buildHowToRedeemCard(),
                    ),
                    const SizedBox(height: 18),
                    _buildFilterBar(),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: _filteredRewards.isEmpty
                          ? _buildEmptyState()
                          : Column(
                              children: _filteredRewards
                                  .map((r) => _RewardItem(
                                        reward: r,
                                        onRedeem: () => _showRedeemDialog(r),
                                      ))
                                  .toList(),
                            ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: _buildEarnMoreCard(),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  // ── App Bar ────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.chevron_left, color: Colors.black87, size: 22),
          ),
          const Expanded(
            child: Column(
              children: [
                Text('Redeem Rewards',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text('Use your points for exciting offers',
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.help_outline, color: Colors.black87, size: 18),
          ),
        ],
      ),
    );
  }

  // ── Balance Summary Card ──────────────────────────────────────────────────
  Widget _buildBalanceSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B6B2F), Color(0xFF2E8B57)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Available Points',
                        style: TextStyle(fontSize: 12, color: Colors.white70)),
                    SizedBox(height: 4),
                    Text('1,850',
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text('Eco-Reward Points',
                        style: TextStyle(fontSize: 11, color: Colors.white70)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Text('🎁', style: TextStyle(fontSize: 32)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _StatChip(label: 'Total Earned', value: '3,850', icon: '⬆️'),
              const SizedBox(width: 10),
              _StatChip(label: 'Total Redeemed', value: '2,000', icon: '✅'),
              const SizedBox(width: 10),
              _StatChip(label: 'Expiring Soon', value: '500', icon: '⏳'),
            ],
          ),
        ],
      ),
    );
  }

  // ── How to Redeem ─────────────────────────────────────────────────────────
  Widget _buildHowToRedeemCard() {
    final steps = [
      {'num': '1', 'text': 'Choose\na Reward'},
      {'num': '2', 'text': 'Tap\nRedeem Now'},
      {'num': '3', 'text': 'Copy\nYour Code'},
      {'num': '4', 'text': 'Use at\nCheckout'},
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: lightGreenBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBE5C8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: primaryGreen, size: 16),
              SizedBox(width: 6),
              Text('How to Redeem',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length, (i) {
              return Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(steps[i]['num']!,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        width: 60,
                        child: Text(steps[i]['text']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10, height: 1.3, color: Colors.black54)),
                      ),
                    ],
                  ),
                  if (i < steps.length - 1)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 18),
                      child: Icon(Icons.arrow_forward, size: 14, color: Colors.grey),
                    ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // ── Filter Bar ────────────────────────────────────────────────────────────
  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_filters.length, (i) {
            final selected = _selectedFilter == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = i),
              child: Container(
                margin: const EdgeInsets.only(right: 10, top: 8, bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? primaryGreen : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? primaryGreen : Colors.grey[300]!,
                  ),
                ),
                child: Text(
                  _filters[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : Colors.black54,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: const Column(
        children: [
          Text('🎁', style: TextStyle(fontSize: 52)),
          SizedBox(height: 12),
          Text('No rewards here yet!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54)),
          SizedBox(height: 4),
          Text('Earn more points and redeem exciting offers.',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // ── Earn More Card ────────────────────────────────────────────────────────
  Widget _buildEarnMoreCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE8A0)),
      ),
      child: Row(
        children: [
          const Text('⭐', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Need more points?',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 2),
                Text('Complete daily tasks & earn Eco-Rewards fast!',
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Earn Now',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ── Redeem Dialog ─────────────────────────────────────────────────────────
  void _showRedeemDialog(Map<String, dynamic> reward) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RedeemBottomSheet(reward: reward),
    );
  }

  // ── Bottom Nav Bar ────────────────────────────────────────────────────────
  Widget _buildBottomNavBar() {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.stars_outlined, 'label': 'Earn'},
      {'icon': Icons.card_giftcard_outlined, 'label': 'Rewards'},
      {'icon': Icons.person_outline, 'label': 'Profile'},
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10, offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final selected = _selectedNav == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedNav = i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(items[i]['icon'] as IconData,
                        color: selected ? primaryGreen : Colors.grey, size: 24),
                    const SizedBox(height: 2),
                    Text(items[i]['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: selected ? primaryGreen : Colors.grey,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                        )),
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

// ── Stat Chip ─────────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  const _StatChip({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 2),
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 8, height: 1.2)),
          ],
        ),
      ),
    );
  }
}

// ── Reward Item ───────────────────────────────────────────────────────────────
class _RewardItem extends StatelessWidget {
  final Map<String, dynamic> reward;
  final VoidCallback onRedeem;
  static const Color primaryGreen = Color(0xFF1B6B2F);

  const _RewardItem({required this.reward, required this.onRedeem});

  Color get _statusColor {
    switch (reward['status']) {
      case 'available':
        return primaryGreen;
      case 'redeemed':
        return Colors.blue;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String get _statusLabel {
    switch (reward['status']) {
      case 'available':
        return 'Available';
      case 'redeemed':
        return 'Redeemed';
      case 'expired':
        return 'Expired';
      default:
        return '';
    }
  }

  IconData get _statusIcon {
    switch (reward['status']) {
      case 'available':
        return Icons.check_circle;
      case 'redeemed':
        return Icons.done_all;
      case 'expired':
        return Icons.cancel_outlined;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAvailable = reward['status'] == 'available';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))
        ],
        border: isAvailable
            ? Border.all(color: const Color(0xFFBBE5C8))
            : Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Top row — brand + info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Brand logo box
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 58,
                    height: 58,
                    color: reward['bgColor'] as Color,
                    child: Center(child: _MiniLogo(logo: reward['logo'] as String)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(reward['title'] as String,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 2),
                      Text(reward['voucher'] as String,
                          style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                                color: primaryGreen, shape: BoxShape.circle),
                            child: const Icon(Icons.check, color: Colors.white, size: 9),
                          ),
                          const SizedBox(width: 4),
                          Text('${reward['points']} Points',
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: primaryGreen,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(_statusIcon, size: 12, color: _statusColor),
                      const SizedBox(width: 3),
                      Text(_statusLabel,
                          style: TextStyle(
                              fontSize: 10,
                              color: _statusColor,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, color: Colors.grey[100]),

          // Bottom row — expiry + redeem button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(
                  reward['status'] == 'available'
                      ? Icons.schedule_outlined
                      : Icons.history,
                  size: 14,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(reward['expiry'] as String,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const Spacer(),
                if (isAvailable)
                  SizedBox(
                    height: 34,
                    child: ElevatedButton(
                      onPressed: onRedeem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Redeem Now',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  )
                else
                  OutlinedButton(
                    onPressed: null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey[300]!),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      minimumSize: const Size(0, 34),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      reward['status'] == 'redeemed' ? 'Used' : 'Expired',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mini Logo ─────────────────────────────────────────────────────────────────
class _MiniLogo extends StatelessWidget {
  final String logo;
  const _MiniLogo({required this.logo});

  @override
  Widget build(BuildContext context) {
    switch (logo) {
      case 'amazon':
        return const Text('a',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white));
      case 'flipkart':
        return const Text('F',
            style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white));
      case 'starbucks':
        return const Text('☕', style: TextStyle(fontSize: 28));
      case 'bigbasket':
        return const Text('bb',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF84C225)));
      case 'bookmyshow':
        return const Text('🎬', style: TextStyle(fontSize: 26));
      case 'plant':
        return const Text('🌱', style: TextStyle(fontSize: 28));
      default:
        return const Icon(Icons.card_giftcard, color: Colors.white, size: 28);
    }
  }
}

// ── Redeem Bottom Sheet ───────────────────────────────────────────────────────
class _RedeemBottomSheet extends StatefulWidget {
  final Map<String, dynamic> reward;
  const _RedeemBottomSheet({required this.reward});

  @override
  State<_RedeemBottomSheet> createState() => _RedeemBottomSheetState();
}

class _RedeemBottomSheetState extends State<_RedeemBottomSheet> {
  static const Color primaryGreen = Color(0xFF1B6B2F);
  bool _copied = false;

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: widget.reward['code'] as String));
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Success check
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(height: 14),

          const Text('🎉 Reward Unlocked!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 4),
          Text(widget.reward['title'] as String,
              style: const TextStyle(fontSize: 13, color: Colors.grey)),
          const SizedBox(height: 20),

          // Voucher code box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FAF2),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBBE5C8)),
            ),
            child: Column(
              children: [
                const Text('Your Voucher Code',
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.reward['code'] as String,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                            letterSpacing: 2)),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _copyCode,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primaryGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _copied ? Icons.check : Icons.copy_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_copied)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text('Copied to clipboard!',
                        style: TextStyle(fontSize: 11, color: primaryGreen)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Text(widget.reward['expiry'] as String,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
          const SizedBox(height: 20),

          // Done button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Done',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}