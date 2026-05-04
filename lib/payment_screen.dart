import 'package:flutter/material.dart';
import 'dart:math' as math;




class PaymentSuccessScreen extends StatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin {
  static const Color primaryGreen = Color(0xFF1B6B2F);
  static const Color lightGreenBg = Color(0xFFF0FAF2);

  late AnimationController _checkController;
  late AnimationController _confettiController;
  late Animation<double> _checkScale;
  late Animation<double> _checkFade;

  int _selectedNav = 0;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _checkScale = CurvedAnimation(parent: _checkController, curve: Curves.elasticOut);
    _checkFade = CurvedAnimation(parent: _checkController, curve: Curves.easeIn);

    _checkController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _confettiController.forward();
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildCheckmarkSection(),
                    _buildSuccessText(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildImpactCard(),
                          const SizedBox(height: 20),
                          _buildWhatsNextSection(),
                          const SizedBox(height: 20),
                          _buildTransactionDetails(),
                          const SizedBox(height: 12),
                          _buildReceiptNote(),
                          const SizedBox(height: 16),
                          _buildActionButtons(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
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

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          const SizedBox(width: 40),
          const Expanded(
            child: Column(
              children: [
                Text(
                  'Payment Successful',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2),
                Text(
                  'Thank you for your contribution!',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.close, color: Colors.black54, size: 24),
          ),
        ],
      ),
    );
  }

  // ── Checkmark with Confetti ────────────────────────────────────────────────
  Widget _buildCheckmarkSection() {
    return SizedBox(
      height: 200,
      child: AnimatedBuilder(
        animation: _confettiController,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // Confetti pieces
              ..._buildConfettiPieces(),
              // Check circle
              child!,
            ],
          );
        },
        child: ScaleTransition(
          scale: _checkScale,
          child: FadeTransition(
            opacity: _checkFade,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: primaryGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 44),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildConfettiPieces() {
    final pieces = [
      _ConfettiData(angle: 0, radius: 80, color: const Color(0xFF4CAF50), width: 8, height: 14),
      _ConfettiData(angle: 0.4, radius: 85, color: const Color(0xFFFF9800), width: 6, height: 12),
      _ConfettiData(angle: 0.9, radius: 78, color: const Color(0xFF2196F3), width: 8, height: 8),
      _ConfettiData(angle: 1.4, radius: 88, color: const Color(0xFFFFEB3B), width: 6, height: 10),
      _ConfettiData(angle: 1.9, radius: 82, color: const Color(0xFF9C27B0), width: 8, height: 6),
      _ConfettiData(angle: 2.4, radius: 76, color: const Color(0xFFF44336), width: 6, height: 14),
      _ConfettiData(angle: 2.9, radius: 90, color: const Color(0xFF00BCD4), width: 8, height: 8),
      _ConfettiData(angle: 3.4, radius: 80, color: const Color(0xFF4CAF50), width: 6, height: 12),
      _ConfettiData(angle: 3.9, radius: 86, color: const Color(0xFFFF5722), width: 8, height: 6),
      _ConfettiData(angle: 4.4, radius: 74, color: const Color(0xFF3F51B5), width: 6, height: 10),
      _ConfettiData(angle: 4.9, radius: 88, color: const Color(0xFF8BC34A), width: 8, height: 14),
      _ConfettiData(angle: 5.4, radius: 82, color: const Color(0xFFFFEB3B), width: 6, height: 8),
    ];

    return pieces.map((p) {
      final progress = _confettiController.value;
      final x = math.cos(p.angle) * p.radius * progress;
      final y = math.sin(p.angle) * p.radius * progress;
      return Positioned(
        left: 100 + x,
        top: 100 + y,
        child: Opacity(
          opacity: progress > 0.1 ? 1.0 : 0,
          child: Transform.rotate(
            angle: p.angle + progress * 2,
            child: Container(
              width: p.width.toDouble(),
              height: p.height.toDouble(),
              decoration: BoxDecoration(
                color: p.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  // ── Success Text ──────────────────────────────────────────────────────────
  Widget _buildSuccessText() {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You did it! ',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryGreen),
            ),
            Text('🌱', style: TextStyle(fontSize: 20)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '55 GCC Units added to your account successfully.',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── Impact Card ───────────────────────────────────────────────────────────
  Widget _buildImpactCard() {
    return Container(
      decoration: BoxDecoration(
        color: lightGreenBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBBE5C8)),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Impact Just Grows! ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: primaryGreen),
                ),
                Text('🌍', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Stats row
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: _ImpactStat(emoji: '🌳', value: '5', unit: 'Trees', label: 'Supported')),
                VerticalDivider(color: Colors.grey[300], thickness: 1, width: 1),
                Expanded(
                  child: _ImpactStatCO2(value: '12', unit: 'kg', label: 'CO₂ Offset'),
                ),
                VerticalDivider(color: Colors.grey[300], thickness: 1, width: 1),
                Expanded(child: _ImpactStat(emoji: '🍃', value: '55', unit: 'Tres', label: 'GCC Units\nAdded to your account', isGreen: true)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Quote bar
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                Icon(Icons.format_quote, color: primaryGreen, size: 22),
                SizedBox(width: 8),
                Text(
                  'Small actions today, greener tomorrow. ',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
                Text('💚', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── What's Next ───────────────────────────────────────────────────────────
  Widget _buildWhatsNextSection() {
    final items = [
      {'emoji': '🌱', 'title': 'Track Your\nImpact', 'sub': 'See your trees\nand CO₂ saved'},
      {'emoji': '🎁', 'title': 'Earn\nRewards', 'sub': 'Complete tasks\nand earn points'},
      {'emoji': '🛍️', 'title': 'Redeem\nOffers', 'sub': 'Use your points\non exciting offers'},
      {'emoji': '👥', 'title': 'Invite\nFriends', 'sub': 'Invite and earn\nmore rewards'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("What's Next?",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
        const SizedBox(height: 12),
        Row(
          children: items.map((item) => Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Text(item['emoji']!, style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 6),
                  Text(item['title']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, height: 1.3)),
                  const SizedBox(height: 4),
                  Text(item['sub']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 9, color: Colors.grey, height: 1.3)),
                ],
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }

  // ── Transaction Details ───────────────────────────────────────────────────
  Widget _buildTransactionDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Transaction Details',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 14),
          _TxRow(
            icon: Icons.receipt_outlined,
            label: 'Transaction ID',
            value: 'GCC240501184726',
            valueColor: Colors.black87,
            showCopy: true,
          ),
          _divider(),
          _TxRow(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Amount Paid',
            value: '₹500',
            valueColor: Colors.black87,
          ),
          _divider(),
          _TxRow(
            icon: Icons.eco_outlined,
            label: 'GCC Units Added',
            value: '55 GCC Units',
            valueColor: primaryGreen,
            valueBold: true,
          ),
          _divider(),
          _TxRow(
            icon: Icons.access_time_outlined,
            label: 'Date & Time',
            value: '01 May 2024, 06:47 PM',
            valueColor: Colors.black87,
            valueBold: true,
          ),
        ],
      ),
    );
  }

  Widget _divider() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Divider(color: Colors.grey[100], height: 1),
      );

  // ── Receipt Note ──────────────────────────────────────────────────────────
  Widget _buildReceiptNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.verified_user_outlined, size: 14, color: primaryGreen),
        const SizedBox(width: 6),
        Text(
          'A receipt has been sent to rahulsharma@gmail.com',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // ── Action Buttons ────────────────────────────────────────────────────────
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryGreen,
              side: const BorderSide(color: primaryGreen, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 18,color: Colors.black,),
                SizedBox(width: 6),
                Text('View My Impact',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Back to Home',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Icon(Icons.chevron_right, size: 18,color: Colors.white,),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Bottom Nav Bar ────────────────────────────────────────────────────────
  Widget _buildBottomNavBar() {
    final items = [
      {'icon': Icons.home, 'label': 'Home'},
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

// ── Helper Data class for confetti ───────────────────────────────────────────
class _ConfettiData {
  final double angle;
  final double radius;
  final Color color;
  final int width;
  final int height;

  const _ConfettiData({
    required this.angle,
    required this.radius,
    required this.color,
    required this.width,
    required this.height,
  });
}

// ── Impact Stat Widget ────────────────────────────────────────────────────────
class _ImpactStat extends StatelessWidget {
  final String emoji;
  final String value;
  final String unit;
  final String label;
  final bool isGreen;

  const _ImpactStat({
    required this.emoji,
    required this.value,
    required this.unit,
    required this.label,
    this.isGreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isGreen ? const Color(0xFF1B6B2F) : Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.grey, height: 1.3)),
        ],
      ),
    );
  }
}

// ── CO2 Stat Widget ───────────────────────────────────────────────────────────
class _ImpactStatCO2 extends StatelessWidget {
  final String value;
  final String unit;
  final String label;

  const _ImpactStatCO2({required this.value, required this.unit, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFB2DFDB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('CO₂', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF00695C))),
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const TextSpan(
                  text: ' kg',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}

// ── Transaction Row Widget ────────────────────────────────────────────────────
class _TxRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final bool showCopy;
  final bool valueBold;

  const _TxRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
    this.showCopy = false,
    this.valueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[500]),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: valueColor,
            fontWeight: valueBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (showCopy) ...[
          const SizedBox(width: 6),
          const Icon(Icons.copy_outlined, size: 14, color: Colors.grey),
        ],
      ],
    );
  }
}
