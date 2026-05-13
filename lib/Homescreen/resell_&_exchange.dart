import 'package:flutter/material.dart';
import 'package:gcc/Homescreen/exchange_review.dart';

class ExchangeGCCScreen extends StatelessWidget {
  const ExchangeGCCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: Column(
          children: [
            const Text(
              'Exchange GCC Units',
              style: TextStyle(
                color: Color(0xFF2E4D31),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Resell your GCC Units securely',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Card with the generated image
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  // Referencing the generated image file verbatim
                  image: AssetImage('assets/Images/green.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Info Notice
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_user,
                    color: Colors.green,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Exchange is available as per platform rules and availability. Price may vary based on demand.',
                      style: TextStyle(fontSize: 10, color: Colors.black87),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      'Know More >',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Balance and Est Value Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBalanceColumn(
                    'Your GCC Balance',
                    '240',
                    'Units',
                    '₹10.00 / Unit (Current Price)',
                  ),
                  const SizedBox(
                    height: 50,
                    child: VerticalDivider(color: Colors.black12, thickness: 1),
                  ),
                  _buildBalanceColumn(
                    'Est. Value',
                    '₹2,400',
                    '',
                    'At ₹10.00 / Unit',
                  ),
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE8F5E9),
                    child: Icon(
                      Icons.account_balance_wallet,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'How Much Do You Want to Exchange?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),

            // Exchange Input Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Enter Units',
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Use All (240)'),
                      ),
                    ],
                  ),
                  const Text(
                    '0 Units',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Text(
                    'Minimum 10 Units',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Summary Box
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              'You Will Get (Est.)',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '₹ 0',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '=',
                          style: TextStyle(fontSize: 24, color: Colors.grey),
                        ),
                        Column(
                          children: [
                            Text(
                              'At Current Price',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              '₹10.00 / Unit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildNoticeFooter(),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Important Points Section
            const Text(
              'Important Points',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoFeature(
                  Icons.verified_outlined,
                  'Safe & Secure',
                  'Your transactions\nare 100% secure.',
                ),
                _buildInfoFeature(
                  Icons.analytics_outlined,
                  'Market Based',
                  'Price may vary based\non platform demand.',
                ),
                _buildInfoFeature(
                  Icons.access_time_outlined,
                  'Quick Processing',
                  'Once matched, amount\nwill be transferred soon.',
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Bottom Action Button
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExchangeReviewScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 12,
                      child: const Icon(Icons.swap_horiz, color: Colors.green),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Continue to Exchange',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.chevron_right, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoticeFooter() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F8F1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.stars, color: Colors.green, size: 18),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Final payout amount will be shown before you confirm the exchange.',
              style: TextStyle(fontSize: 10, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceColumn(
    String label,
    String value,
    String unit,
    String subtext,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.info_outline, size: 12, color: Colors.grey),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            if (unit.isNotEmpty)
              Text(
                ' $unit',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            subtext,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoFeature(IconData icon, String title, String desc) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFF1F8F1),
            child: Icon(icon, color: Colors.green, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
