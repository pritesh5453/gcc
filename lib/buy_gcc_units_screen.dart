import 'package:flutter/material.dart';
import 'package:gcc/payment_screen.dart';


class BuyGCCUnitsScreen extends StatefulWidget {
  const BuyGCCUnitsScreen({super.key});

  @override
  State<BuyGCCUnitsScreen> createState() => _BuyGCCUnitsScreenState();
}

class _BuyGCCUnitsScreenState extends State<BuyGCCUnitsScreen> {
  static const Color primaryGreen = Color(0xFF1B6B2F);
  static const Color lightGreenBg = Color(0xFFF0FAF2);

  int selectedIndex = 0;

  final List<Map<String, dynamic>> packs = [
    {'units': 10, 'price': 100, 'emoji': '🌱'},
    {'units': 25, 'price': 250, 'emoji': '🌿'},
    {'units': 50, 'price': 500, 'emoji': '🌱', 'popular': true},
    {'units': 100, 'price': 1000, 'emoji': '🌳'},
    {'units': 250, 'price': 2500, 'emoji': '🌲'},
  ];

  @override
  Widget build(BuildContext context) {
    final selected = packs[selectedIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildTrustBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  children: [
                    _buildHeroBanner(),
                    const SizedBox(height: 12),
                    _buildPriceCard(),
                    const SizedBox(height: 12),
                    _buildPackSelector(),
                    const SizedBox(height: 12),
                    _buildSummaryCard(selected),
                    const SizedBox(height: 12),
                    _buildImpactCard(selected),
                    const SizedBox(height: 12),
                    _buildFeatureBadges(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ── App Bar ────────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.chevron_left, color: Colors.black87, size: 22),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Buy GCC Units',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.help_outline, color: Colors.black87, size: 20),
          ),
        ],
      ),
    );
  }

  // ── Trust Bar ─────────────────────────────────────────────────────────────
  Widget _buildTrustBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified_user, color: Color(0xFF1B6B2F), size: 14),
          const SizedBox(width: 4),
          const Text('Secure', style: TextStyle(fontSize: 12, color: Colors.black87)),
          _divider(),
          const Text('Trusted', style: TextStyle(fontSize: 12, color: Colors.black87)),
          _divider(),
          const Text('Transparent', style: TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _divider() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text('|', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
      );

  // ── Hero Banner ───────────────────────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Green gradient bg right side
          Positioned(
            right: 0, top: 0, bottom: 0,
            width: 200,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFFD8F5E0)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          // Birds
          const Positioned(top: 18, right: 60,
            child: Text('✓', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 10))),
          const Positioned(top: 30, right: 80,
            child: Text('✓', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 8))),
          const Positioned(top: 14, right: 110,
            child: Text('✓', style: TextStyle(color: Color(0xFF4CAF50), fontSize: 10))),
          // Big plant + hand on right
          const Positioned(
            right: 10, top: 10, bottom: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🌱', style: TextStyle(fontSize: 70)),
                Text('🤲', style: TextStyle(fontSize: 28)),
              ],
            ),
          ),
          // Text left
          const Positioned(
            left: 18, top: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Every Unit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text('Creates Impact',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B6B2F))),
                SizedBox(height: 14),
                Row(
                  children: [
                    Text('You buy. We plant.\nThe planet grows. ',
                        style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.5)),
                    Text('🌿', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Price Card ────────────────────────────────────────────────────────────
  Widget _buildPriceCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.monetization_on_outlined, color: Color(0xFF1B6B2F), size: 18),
              const SizedBox(width: 6),
              const Text('Current Unit Price',
                  style: TextStyle(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('₹10.00',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(width: 4),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text('/ Unit', style: TextStyle(fontSize: 14, color: Colors.black54)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FAF2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline, color: Color(0xFF1B6B2F), size: 16),
                    SizedBox(width: 4),
                    Text('100% Secure\nPayments',
                        style: TextStyle(fontSize: 10, color: Color(0xFF1B6B2F), fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Price is fixed and not an investment.',
              style: TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  // ── Pack Selector ─────────────────────────────────────────────────────────
  Widget _buildPackSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_basket_outlined, color: Color(0xFF1B6B2F), size: 18),
              const SizedBox(width: 6),
              const Text('Choose Your Pack',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.edit_outlined, color: Color(0xFF1B6B2F), size: 16),
              const SizedBox(width: 4),
              const Text('Custom Amount',
                  style: TextStyle(fontSize: 12, color: Color(0xFF1B6B2F), fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(packs.length, (i) => _PackCard(
                pack: packs[i],
                isSelected: selectedIndex == i,
                onTap: () => setState(() => selectedIndex = i),
              )),
            ),
          ),
        ],
      ),
    );
  }

  // ── Summary Card ──────────────────────────────────────────────────────────
  Widget _buildSummaryCard(Map<String, dynamic> selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FAF2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance_wallet_outlined,
                color: Color(0xFF1B6B2F), size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('You Pay', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('₹${selected['price']}',
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
            ],
          ),
          const SizedBox(width: 16),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.drag_handle, color: Colors.grey, size: 16),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('You Get', style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text('${selected['units']} Units',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B6B2F))),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FAF2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('₹10 / Unit (Current Price)',
                    style: TextStyle(fontSize: 10, color: Color(0xFF1B6B2F))),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Impact Card ───────────────────────────────────────────────────────────
  Widget _buildImpactCard(Map<String, dynamic> selected) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFFF0FAF2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBE5C8)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Right side green scene
          Positioned(
            right: 0, top: 0, bottom: 0,
            width: 160,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF0FAF2), Color(0xFFD0F0DA)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: const Stack(
                children: [
                  Positioned(bottom: 0, right: 10,
                    child: Text('🌍', style: TextStyle(fontSize: 65))),
                  Positioned(bottom: 0, left: 0,
                    child: Text('🌲', style: TextStyle(fontSize: 30))),
                  Positioned(top: 10, right: 30,
                    child: Text('🐦', style: TextStyle(fontSize: 12))),
                ],
              ),
            ),
          ),
          // Thank you badge
          Positioned(
            right: 8, bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1B6B2F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.favorite, color: Colors.white, size: 12),
                  SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Thank You!', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      Text('For Choosing Green', style: TextStyle(color: Colors.white70, fontSize: 9)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Left text
          Positioned(
            left: 16, top: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.eco, color: Color(0xFF1B6B2F), size: 16),
                    const SizedBox(width: 4),
                    const Text('Your Impact',
                        style: TextStyle(fontSize: 13, color: Color(0xFF1B6B2F), fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${selected['units']} Units = Support ${selected['units']} Trees',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                const Text(
                  'You are one step closer to a\ngreener tomorrow.',
                  style: TextStyle(fontSize: 11, color: Colors.black54, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Feature Badges ────────────────────────────────────────────────────────
  Widget _buildFeatureBadges() {
    final features = [
      {'icon': Icons.verified_user_outlined, 'label': 'Secure\nPayments'},
      {'icon': Icons.bolt_outlined, 'label': 'Instant\nUnits'},
      {'icon': Icons.bar_chart_outlined, 'label': 'Track\nImpact'},
      {'icon': Icons.remove_red_eye_outlined, 'label': '100%\nTransparent'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: features.map((f) => Column(
          children: [
            Icon(f['icon'] as IconData, color: const Color(0xFF1B6B2F), size: 24),
            const SizedBox(height: 4),
            Text(f['label'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Colors.black54, height: 1.3)),
          ],
        )).toList(),
      ),
    );
  }

  // ── Bottom Bar ────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) =>  PaymentSuccessScreen()));

                
               
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B6B2F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Proceed to Payment',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user_outlined, size: 13, color: Colors.grey),
              SizedBox(width: 4),
              Text('Your payment information is safe and encrypted.',
                  style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Pack Card Widget ──────────────────────────────────────────────────────────
class _PackCard extends StatelessWidget {
  final Map<String, dynamic> pack;
  final bool isSelected;
  final VoidCallback onTap;

  const _PackCard({
    required this.pack,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPopular = pack['popular'] == true;

    final String emoji = pack['emoji']?.toString() ?? '🌱';
    final String units = pack['units']?.toString() ?? '0';
    final String price = pack['price']?.toString() ?? '0';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 95, // 👈 PERFECT WIDTH
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3FBF5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1B6B2F) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [

            /// 🔥 MOST POPULAR
            if (isPopular)
             Positioned(
  top: -10,
  left: 0,
  right: 0,
  child: Center(
    child: Transform.translate(
      offset: const Offset(0, -2), // 👈 micro adjust
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF7ED957),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          "Most Popular",
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    ),
  ),
),

            /// ✅ SELECTED ICON
            if (isSelected)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1B6B2F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 11, color: Colors.white),
                ),
              ),

            /// 📦 CONTENT
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 6),

                /// 🌱 TREE ICON
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 26),
                ),

                const SizedBox(height: 6),

                /// 🔢 UNITS
                Text(
                  units,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 2),

                const Text(
                  "Units",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 8),

                /// 💰 PRICE BOX
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFDFF5E5)
                        : const Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "₹$price",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFF1B6B2F)
                            : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}