import 'package:flutter/material.dart';



class RewardsStoreScreen extends StatefulWidget {
  const RewardsStoreScreen({super.key});

  @override
  State<RewardsStoreScreen> createState() => _RewardsStoreScreenState();
}

class _RewardsStoreScreenState extends State<RewardsStoreScreen> {
  static const Color primaryGreen = Color(0xFF1B6B2F);
  static const Color lightGreenBg = Color(0xFFF0FAF2);

  int _selectedCategory = 0;
  int _selectedNav = 2;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.card_giftcard_outlined, 'label': 'All Rewards'},
    {'icon': Icons.local_offer_outlined, 'label': 'E-Vouchers'},
    {'icon': Icons.shopping_bag_outlined, 'label': 'Shopping'},
    {'icon': Icons.coffee_outlined, 'label': 'Lifestyle'},
    {'icon': Icons.favorite_border, 'label': 'Donation'},
  ];

  final List<Map<String, dynamic>> _rewards = [
    {
      'title': 'Amazon Pay eGift Card',
      'voucher': '₹100 Voucher',
      'points': '1,000 Points',
      'bgColor': Color(0xFF131921),
      'logo': 'amazon',
      'liked': false,
    },
    {
      'title': 'Flipkart Gift Card',
      'voucher': '₹100 Voucher',
      'points': '1,000 Points',
      'bgColor': Color(0xFF2874F0),
      'logo': 'flipkart',
      'liked': false,
    },
    {
      'title': 'Starbucks eGift Card',
      'voucher': '₹150 Voucher',
      'points': '1,500 Points',
      'bgColor': Color(0xFF00704A),
      'logo': 'starbucks',
      'liked': false,
    },
    {
      'title': 'BigBasket Voucher',
      'voucher': '₹250 Voucher',
      'points': '2,500 Points',
      'bgColor': Color(0xFFD4EDAB),
      'logo': 'bigbasket',
      'liked': false,
    },
    {
      'title': 'BookMyShow Voucher',
      'voucher': '₹200 Voucher',
      'points': '2,000 Points',
      'bgColor': Color(0xFFCC0000),
      'logo': 'bookmyshow',
      'liked': false,
    },
    {
      'title': 'Plant a Tree',
      'voucher': 'Contribute & Grow',
      'points': '500 Points',
      'bgColor': Color(0xFFD6EED6),
      'logo': 'plant',
      'liked': false,
    },
  ];

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
                      child: _buildBalanceCard(),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: _buildCategorySection(),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: _buildAllRewardsSection(),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: _buildBottomBanner(),
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
          const Icon(Icons.chevron_left, color: Colors.black87, size: 28),
          const Expanded(
            child: Column(
              children: [
                Text('Rewards Store',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text('Redeem your points for exciting rewards',
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          Stack(
            children: [
              const Icon(Icons.shopping_bag_outlined, size: 28, color: Colors.black87),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
                  child: const Center(
                    child: Text('2', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Balance Card ──────────────────────────────────────────────────────────
  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        color: lightGreenBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBBE5C8)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Your Balance',
                        style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('1,850',
                            style: TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(width: 8),
                        Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.recycling, color: Colors.white, size: 14),
                        ),
                      ],
                    ),
                    const Text('Points',
                        style: TextStyle(fontSize: 13, color: Colors.black54)),
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                height: 80,
                child: Stack(
                  children: const [
                    Positioned(right: 0, bottom: 0, child: Text('🎁', style: TextStyle(fontSize: 58))),
                    Positioned(left: 0, bottom: 8, child: Text('🪙', style: TextStyle(fontSize: 22))),
                    Positioned(top: 2, right: 12, child: Text('✦', style: TextStyle(fontSize: 10, color: Color(0xFFFFD700)))),
                    Positioned(top: 10, left: 16, child: Text('✦', style: TextStyle(fontSize: 8, color: Color(0xFF4CAF50)))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🌿', style: TextStyle(fontSize: 13)),
                SizedBox(width: 6),
                Text('Earn more points by completing tasks and challenges!',
                    style: TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Category Section ──────────────────────────────────────────────────────
  Widget _buildCategorySection() {
    return Column(
      children: [
        Row(
          children: [
            const Text('Browse by Category',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
            const Spacer(),
            const Text('View All',
                style: TextStyle(fontSize: 12, color: primaryGreen, fontWeight: FontWeight.w600)),
            const Icon(Icons.chevron_right, size: 16, color: primaryGreen),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_categories.length, (i) {
            final selected = _selectedCategory == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = i),
              child: Column(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFFD6EED6) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? primaryGreen : Colors.grey[200]!,
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Icon(_categories[i]['icon'] as IconData,
                        color: primaryGreen, size: 26),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: 62,
                    child: Text(_categories[i]['label'] as String,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: selected ? primaryGreen : Colors.black54,
                          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                        )),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  // ── All Rewards Section ───────────────────────────────────────────────────
  Widget _buildAllRewardsSection() {
    return Column(
      children: [
        Row(
          children: [
            const Text('All Rewards',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: const Row(
                children: [
                  Text('Sort by: Popular',
                      style: TextStyle(fontSize: 11, color: Colors.black54)),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 14,
            childAspectRatio: 0.62,
          ),
          itemCount: _rewards.length,
          itemBuilder: (context, i) => _RewardCard(
            reward: _rewards[i],
            onLike: () => setState(() => _rewards[i]['liked'] = !_rewards[i]['liked']),
          ),
        ),
      ],
    );
  }

  // ── Bottom Banner ─────────────────────────────────────────────────────────
  Widget _buildBottomBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: lightGreenBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBBE5C8)),
      ),
      child: Row(
        children: [
          const Text('🌳', style: TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Every redemption supports a greener planet.',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                Text('Thank you for being a part of the change!',
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 10, offset: const Offset(0, -2))],
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

// ── Reward Card Widget ────────────────────────────────────────────────────────
class _RewardCard extends StatelessWidget {
  final Map<String, dynamic> reward;
  final VoidCallback onLike;
  static const Color primaryGreen = Color(0xFF1B6B2F);

  const _RewardCard({required this.reward, required this.onLike});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Brand image area
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: Container(
                  height: 90,
                  width: double.infinity,
                  color: reward['bgColor'] as Color,
                  child: Center(child: _BrandLogo(logo: reward['logo'] as String)),
                ),
              ),
              // Heart button
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: onLike,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                    ),
                    child: Icon(
                      (reward['liked'] as bool) ? Icons.favorite : Icons.favorite_border,
                      size: 14,
                      color: (reward['liked'] as bool) ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reward['title'] as String,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, height: 1.3)),
                  const SizedBox(height: 2),
                  Text(reward['voucher'] as String,
                      style: const TextStyle(fontSize: 9, color: Colors.grey)),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: 8),
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(reward['points'] as String,
                            style: const TextStyle(fontSize: 10, color: primaryGreen, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 28,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Redeem Now', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Brand Logo Widget ─────────────────────────────────────────────────────────
class _BrandLogo extends StatelessWidget {
  final String logo;
  const _BrandLogo({required this.logo});

  @override
  Widget build(BuildContext context) {
    switch (logo) {
      case 'amazon':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('a',
                style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'serif')),
            Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9900),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        );
      case 'flipkart':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Flipkart',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 2),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE000),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text('F', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF2874F0))),
              ),
            ),
          ],
        );
      case 'starbucks':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Center(
                child: Text('☕', style: TextStyle(fontSize: 28)),
              ),
            ),
          ],
        );
      case 'bigbasket':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF84C225),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text('bb',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                ),
                const SizedBox(width: 6),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('big', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF84C225))),
                    Text('basket', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFCC0000))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text('A TATA Enterprise',
                style: TextStyle(fontSize: 8, color: Colors.black45)),
          ],
        );
      case 'bookmyshow':
        return const Center(
          child: Text.rich(
            TextSpan(children: [
              TextSpan(text: 'book', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
              TextSpan(text: 'my', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFFFFD700))),
              TextSpan(text: 'show', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Colors.white)),
            ]),
          ),
        );
      case 'plant':
        return const Center(child: Text('🌱', style: TextStyle(fontSize: 44)));
      default:
        return const SizedBox();
    }
  }
}
