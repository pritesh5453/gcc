import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyForestScreen extends StatefulWidget {
  const MyForestScreen({super.key});

  @override
  State<MyForestScreen> createState() => _MyForestScreenState();
}

class _MyForestScreenState extends State<MyForestScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  // Data
  final int totalTrees = 240;
  final double forestValue = 2400.00;
  final int co2Offset = 480;
  final int waterSaved = 12000;
  final int energySaved = 960;

  final List<Map<String, dynamic>> locations = [
    {'name': 'Maharashtra', 'trees': 120, 'percent': 0.50},
    {'name': 'Gujarat', 'trees': 80, 'percent': 0.33},
    {'name': 'Rajasthan', 'trees': 40, 'percent': 0.17},
  ];

  final List<Map<String, dynamic>> activities = [
    {'title': '20 Trees planted in Nashik, Maharashtra', 'date': '15 Jan 2026'},
    {'title': '35 Trees planted in Pune, Maharashtra', 'date': '10 Jan 2026'},
    {'title': '15 Trees planted in Mumbai, Maharashtra', 'date': '05 Jan 2026'},
  ];

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOut,
    );
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      body: CustomScrollView(
        slivers: [
          // Hero Forest Header
          SliverToBoxAdapter(child: _buildHeroSection()),

          // Impact Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: _buildImpactSection(),
            ),
          ),

          // Forest Growth
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: _buildForestGrowthSection(),
            ),
          ),

          // Where are your trees
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: _buildLocationSection(),
            ),
          ),

          // Recent Activities
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
              child: _buildActivitiesSection(),
            ),
          ),

          // Bottom Share Button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
              child: _buildShareButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Forest background illustration
        Container(
          height: size.height * 0.42,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFD4EDD4), Color(0xFFB8DFB0), Color(0xFF8FC98A)],
            ),
          ),
          child: Stack(
            children: [
              // Sky birds
              Positioned(top: 80, right: 60, child: _buildBirds()),
              // Forest illustration (SVG-like using containers)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildForestIllustration(),
              ),
              // River
              Positioned(
                bottom: 30,
                left: size.width * 0.55,
                child: _buildRiver(),
              ),
            ],
          ),
        ),

        // Top navigation bar
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: Color(0xFF2D5A27),
                    size: 26,
                  ),
                ),
                const Expanded(
                  child: Column(
                    children: [
                      Text(
                        'My Forest',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A3D14),
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Your green impact at a glance',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4A7A40),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Color(0xFF2D5A27),
                        size: 22,
                      ),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '2',
                            style: TextStyle(
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
              ],
            ),
          ),
        ),

        // Trees count overlay text
        Positioned(
          top: MediaQuery.of(context).padding.top + 72,
          left: 0,
          right: 0,
          child: Column(
            children: [
              const Text(
                'You have planted',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF3A6632),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '240 ',
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1A3D14),
                        letterSpacing: -2,
                      ),
                    ),
                    TextSpan(
                      text: 'Trees',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A3D14),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'with 240 GCC Units',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4A7A40),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Forest Value card
        Positioned(
          bottom: 20,
          left: 50,
          right: 50,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1A3D14),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1A3D14).withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Column(
                  children: [
                    Text(
                      'Forest Value',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '₹2,400.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D7A22),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text('🌿', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForestIllustration() {
    return SizedBox(
      height: 160,
      child: CustomPaint(
        painter: ForestPainter(),
        size: Size(MediaQuery.of(context).size.width, 160),
      ),
    );
  }

  Widget _buildRiver() {
    return CustomPaint(painter: RiverPainter(), size: const Size(60, 100));
  }

  Widget _buildBirds() {
    return const Row(
      children: [
        Text('🐦', style: TextStyle(fontSize: 10)),
        SizedBox(width: 8),
        Text('🐦', style: TextStyle(fontSize: 8)),
        SizedBox(width: 12),
        Text('🐦', style: TextStyle(fontSize: 10)),
      ],
    );
  }

  Widget _buildImpactSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Impact',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildImpactCard(
                icon: '🌿',
                iconBg: const Color(0xFFE8F5E4),
                label: 'CO₂ Offset',
                value: '480 kg',
                valueColor: const Color(0xFF2D7A22),
                isEmoji: true,
              ),
              _buildImpactCard(
                icon: '💧',
                iconBg: const Color(0xFFE3F2FD),
                label: 'Water Saved',
                value: '12,000 L',
                valueColor: const Color(0xFF1976D2),
                isEmoji: true,
              ),
              _buildImpactCard(
                icon: '⚡',
                iconBg: const Color(0xFFFFF8E1),
                label: 'Energy Saved',
                value: '960 kWh',
                valueColor: const Color(0xFFF57C00),
                isEmoji: true,
              ),
              _buildImpactCard(
                icon: '🌲',
                iconBg: const Color(0xFFE8F5E4),
                label: 'Trees Supported',
                value: '240',
                valueColor: const Color(0xFF1A3D14),
                isEmoji: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactCard({
    required String icon,
    required Color iconBg,
    required String label,
    required String value,
    required Color valueColor,
    bool isEmoji = false,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF888888),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: valueColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForestGrowthSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Forest Growth',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  children: [
                    const Text(
                      'View Details',
                      style: TextStyle(
                        color: Color(0xFF2D7A22),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF2D7A22),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildGrowthItem(
                emoji: '🌱',
                label: 'Saplings',
                count: 50,
                progress: 50 / 240,
              ),
              const SizedBox(width: 12),
              _buildGrowthItem(
                emoji: '🌳',
                label: 'Young Trees',
                count: 120,
                progress: 120 / 240,
              ),
              const SizedBox(width: 12),
              _buildGrowthItem(
                emoji: '🌲',
                label: 'Mature Trees',
                count: 70,
                progress: 70 / 240,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthItem({
    required String emoji,
    required String label,
    required int count,
    required double progress,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF888888),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(emoji, style: const TextStyle(fontSize: 22)),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FractionallySizedBox(
                  widthFactor: progress * _progressAnimation.value,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D7A22),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Where are your trees?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Row(
                  children: [
                    Text(
                      'View Map',
                      style: TextStyle(
                        color: Color(0xFF2D7A22),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF2D7A22),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children:
                locations
                    .map(
                      (loc) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: loc == locations.last ? 0 : 10,
                          ),
                          child: _buildLocationCard(
                            name: loc['name'],
                            trees: loc['trees'],
                            percent: loc['percent'],
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard({
    required String name,
    required int trees,
    required double percent,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAF6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0EDD9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 14,
                color: Color(0xFF2D7A22),
              ),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$trees Trees',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D7A22),
            ),
          ),
          Text(
            '${(percent * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF888888),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return SizedBox(
                width: 40,
                height: 40,
                child: CustomPaint(
                  painter: CircularProgressPainter(
                    progress: percent * _progressAnimation.value,
                    backgroundColor: const Color(0xFFDDEEDA),
                    progressColor: const Color(0xFF2D7A22),
                    strokeWidth: 4,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Activities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF2D7A22),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...activities.map(
            (act) => _buildActivityItem(
              title: act['title'],
              date: act['date'],
              isLast: act == activities.last,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String date,
    required bool isLast,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('🌲', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFCCCCCC),
                  size: 22,
                ),
              ],
            ),
          ),
        ),
        if (!isLast) const Divider(height: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }

  Widget _buildShareButton() {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A4D14), Color(0xFF2D7A22)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2D7A22).withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative leaves right side
          Positioned(
            right: 16,
            bottom: 0,
            child: Opacity(
              opacity: 0.25,
              child: const Text('🍃', style: TextStyle(fontSize: 38)),
            ),
          ),
          Positioned(
            right: 44,
            top: 8,
            child: Opacity(
              opacity: 0.2,
              child: const Text('🌿', style: TextStyle(fontSize: 24)),
            ),
          ),
          // Button content
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(20),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Icon(Icons.share_rounded, color: Colors.white, size: 24),
                    SizedBox(width: 14),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Share My Forest',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          'Let others know about your green impact',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for forest background illustration
class ForestPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final groundPaint = Paint()..color = const Color(0xFF5A9E4A);
    final darkLeafPaint = Paint()..color = const Color(0xFF2D7A22);
    final midLeafPaint = Paint()..color = const Color(0xFF4CAF50);
    final lightLeafPaint = Paint()..color = const Color(0xFF81C784);
    final trunkPaint = Paint()..color = const Color(0xFF5D4037);

    // Ground
    final groundPath =
        Path()
          ..moveTo(0, size.height * 0.65)
          ..quadraticBezierTo(
            size.width * 0.5,
            size.height * 0.5,
            size.width,
            size.height * 0.60,
          )
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
    canvas.drawPath(groundPath, groundPaint);

    // Draw multiple trees
    _drawTree(
      canvas,
      Offset(size.width * 0.08, size.height * 0.72),
      55,
      22,
      darkLeafPaint,
      trunkPaint,
    );
    _drawTree(
      canvas,
      Offset(size.width * 0.22, size.height * 0.68),
      65,
      20,
      midLeafPaint,
      trunkPaint,
    );
    _drawTree(
      canvas,
      Offset(size.width * 0.38, size.height * 0.72),
      50,
      18,
      darkLeafPaint,
      trunkPaint,
    );
    _drawTree(
      canvas,
      Offset(size.width * 0.55, size.height * 0.74),
      45,
      16,
      lightLeafPaint,
      trunkPaint,
    );
    _drawTree(
      canvas,
      Offset(size.width * 0.70, size.height * 0.70),
      60,
      20,
      midLeafPaint,
      trunkPaint,
    );
    _drawTree(
      canvas,
      Offset(size.width * 0.85, size.height * 0.73),
      55,
      19,
      darkLeafPaint,
      trunkPaint,
    );
    _drawTree(
      canvas,
      Offset(size.width * 0.95, size.height * 0.70),
      48,
      17,
      lightLeafPaint,
      trunkPaint,
    );
  }

  void _drawTree(
    Canvas canvas,
    Offset base,
    double height,
    double width,
    Paint leafPaint,
    Paint trunkPaint,
  ) {
    // Trunk
    final trunkRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        base.dx - width * 0.12,
        base.dy - height * 0.35,
        width * 0.24,
        height * 0.38,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(trunkRect, trunkPaint);

    // Three layered canopy circles
    canvas.drawCircle(
      Offset(base.dx, base.dy - height * 0.8),
      width * 0.7,
      leafPaint,
    );
    canvas.drawCircle(
      Offset(base.dx - width * 0.35, base.dy - height * 0.55),
      width * 0.55,
      leafPaint,
    );
    canvas.drawCircle(
      Offset(base.dx + width * 0.35, base.dy - height * 0.50),
      width * 0.50,
      leafPaint,
    );

    // Highlight
    final highlightPaint = Paint()..color = Colors.white.withOpacity(0.1);
    canvas.drawCircle(
      Offset(base.dx - width * 0.1, base.dy - height * 0.9),
      width * 0.3,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// River painter
class RiverPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF64B5F6).withOpacity(0.7)
          ..style = PaintingStyle.fill;

    final path =
        Path()
          ..moveTo(size.width * 0.3, 0)
          ..quadraticBezierTo(
            size.width * 0.8,
            size.height * 0.3,
            size.width * 0.5,
            size.height,
          )
          ..lineTo(size.width * 0.1, size.height)
          ..quadraticBezierTo(size.width * 0.4, size.height * 0.3, 0, 0)
          ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Circular progress painter for location cards
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint =
        Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint =
        Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CircularProgressPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
