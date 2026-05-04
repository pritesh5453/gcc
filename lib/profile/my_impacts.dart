import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyImpactScreen extends StatelessWidget {
  const MyImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBF8),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.eco, color: Colors.green, size: 20),
                  SizedBox(width: 4),
                  Text(
                    'My Impact',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Text(
                'See the positive change you\'re creating',
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.ios_share, size: 18, color: Colors.black),
              label: const Text(
                'Share',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
          ],
          bottom: const TabBar(
            isScrollable: false,
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Trees'),
              Tab(text: 'CO₂ Offset'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildTopBanner(),
              const SizedBox(height: 16),
              _buildOverallImpactCard(),
              const SizedBox(height: 16),
              _buildImpactBreakdown(),
              const SizedBox(height: 16),
              _buildEnvironmentalEquivalents(),
              const SizedBox(height: 16),
              _buildBottomActionCard(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBanner() {
    return Container(
      width: double.infinity,
      height: 80,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        image: const DecorationImage(
          image: NetworkImage('https://via.placeholder.com/400x100'),
          fit: BoxFit.cover,
          opacity: 0.3,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Your contribution is making',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            'a real difference! 🌿',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallImpactCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Overall Impact',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white, size: 12),
                    SizedBox(width: 4),
                    Text(
                      'All Time',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildImpactStat(
                Icons.park,
                '55',
                'Trees Supported',
                '🌱 Growing strong',
              ),
              _buildImpactStat(
                Icons.cloud,
                '12 kg',
                'CO₂ Offset',
                '✨ Good for planet',
              ),
              _buildImpactStat(
                Icons.eco,
                '3,250',
                'GCC Units Used',
                '💚 Keep it up!',
              ),
              _buildImpactStat(
                Icons.stars,
                '1,850',
                'Eco-Rewards Earned',
                '🎉 Great going!',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Image.network(
                  'https://cdn-icons-png.flaticon.com/512/628/628283.png',
                  height: 30,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Together, we are building a greener tomorrow.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        'Every action counts. Thank you!',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactStat(IconData icon, String val, String label, String sub) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white12,
          child: Icon(icon, color: Colors.green[200]),
        ),
        const SizedBox(height: 8),
        Text(
          val,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 9)),
        const SizedBox(height: 4),
        Text(
          sub,
          style: const TextStyle(
            color: Color(0xFFC8E6C9),
            fontSize: 8,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildImpactBreakdown() {
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
          const Text(
            'Impact Breakdown',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(100, 100),
                      painter: DonutChartPainter(),
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '55',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Trees',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  children: [
                    _buildBreakdownRow(
                      Colors.green,
                      'GCC Units Purchase',
                      '40 Trees',
                    ),
                    const Divider(),
                    _buildBreakdownRow(
                      Colors.blue,
                      'Invited Friends',
                      '10 Trees',
                    ),
                    const Divider(),
                    _buildBreakdownRow(
                      Colors.orange,
                      'Rewards & Tasks',
                      '5 Trees',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F8E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.eco_outlined, color: Colors.green),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'You\'re in the top 20% of contributors! 🌿',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        'Keep going, you\'re an inspiration.',
                        style: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(Color color, String label, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
          Text(
            count,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEnvironmentalEquivalents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Environmental Equivalents',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 4),
            Icon(Icons.info_outline, size: 14, color: Colors.grey),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildEqCard(
              Icons.directions_car,
              '26 km',
              'of car emissions avoided',
              Colors.green,
            ),
            const SizedBox(width: 8),
            _buildEqCard(
              Icons.bolt,
              '5',
              'hours of electricity saved',
              Colors.green,
            ),
            const SizedBox(width: 8),
            _buildEqCard(
              Icons.water_drop,
              '2,200 L',
              'of water conserved',
              Colors.blue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEqCard(IconData icon, String val, String desc, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor.withOpacity(0.7)),
            const SizedBox(height: 8),
            Text(
              val,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 8, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionCard() {
    return Container(
      padding: const EdgeInsets.all(12),
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
                  'Want to do even more?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Text(
                  'Explore more ways to increase your impact and help the planet.',
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Row(
              children: [
                Text('Take More Actions', style: TextStyle(fontSize: 10)),
                Icon(Icons.chevron_right, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DonutChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 12.0;

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    // Green Section (70%)
    paint.color = Colors.green;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth),
      -math.pi / 2,
      2 * math.pi * 0.7,
      false,
      paint,
    );

    // Blue Section (20%)
    paint.color = Colors.blue;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth),
      2 * math.pi * 0.7 - math.pi / 2,
      2 * math.pi * 0.2,
      false,
      paint,
    );

    // Orange Section (10%)
    paint.color = Colors.orange;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth),
      2 * math.pi * 0.9 - math.pi / 2,
      2 * math.pi * 0.1,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
