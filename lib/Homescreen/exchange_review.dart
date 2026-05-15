import 'package:flutter/material.dart';
import 'package:gcc/Homescreen/green_exchange.dart';

class ExchangeReviewScreen extends StatelessWidget {
  const ExchangeReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2E7D32);
    const secondaryGreen = Color(0xFF2E4D31);
    const lightGreenBg = Color(0xFFF1F8F1);
    const notePurpleBg = Color(0xFFF5F3FF);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          children: [
            const Text(
              'Exchange Review',
              style: TextStyle(
                color: secondaryGreen,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Review and confirm your exchange',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield, color: Colors.green, size: 14),
                SizedBox(width: 4),
                Text(
                  'Secure',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/Images/almost_there.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 2. Exchange Summary Card
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
                  const Row(
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        size: 18,
                        color: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Exchange Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24, thickness: 0.5),
                  _buildSummaryRow(
                    icon: Icons.eco_outlined,
                    label: 'Units to Exchange',
                    value: '100 Units',
                    valueColor: Colors.green,
                    showEdit: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryItem(
                          Icons.currency_rupee,
                          'You Will Get (Est.)',
                          '₹1,000.00',
                          valueColor: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: _buildSummaryItem(null, 'Rate', '₹10.00 / Unit'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryItem(
                          Icons.calendar_today_outlined,
                          'Exchange Type',
                          'Instant Payout',
                          valueColor: Colors.green,
                        ),
                      ),
                      Expanded(
                        child: _buildSummaryItem(
                          null,
                          'Processing Time',
                          'Within 24 Hours',
                          valueColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow(
                    icon: Icons.account_balance_wallet_outlined,
                    label: 'Payout Method',
                    value: 'Bank Transfer',
                    subLabel: 'Bank Account',
                    subValue: 'XXXX XXXX 4567',
                    showArrow: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Current Holdings Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightGreenBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.pie_chart_outline,
                              size: 16,
                              color: secondaryGreen,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Your Current Holdings',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildHoldingCol(
                              'GCC Units',
                              '240 Units',
                              secondaryGreen,
                            ),
                            const SizedBox(width: 24),
                            _buildHoldingCol(
                              'Est. Value',
                              '₹2,400.00',
                              secondaryGreen,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 24,
                    child: Icon(Icons.eco, color: Colors.green, size: 28),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. Information Box
            _buildInfoBox(
              'Exchange price is based on current market demand and platform rules.',
              true,
            ),
            const SizedBox(height: 16),

            // 5. Important Note Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: notePurpleBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple.shade100),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    color: Colors.deepPurple,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Important Note',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Once confirmed, this exchange request cannot be cancelled. Please ensure all details are correct.',
                          style: TextStyle(color: Colors.black87, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 6. Confirm Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GreenExchangeApp(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF388E3C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Confirm Exchange',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.security, size: 12, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    'Your transaction is 100% secure and encrypted.',
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    bool showEdit = false,
    String? subLabel,
    String? subValue,
    bool showArrow = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFFF1F8F1),
          child: Icon(icon, size: 16, color: Colors.green),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? Colors.black87,
                ),
              ),
              if (subLabel != null) ...[
                const SizedBox(height: 12),
                Text(
                  subLabel,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                Text(
                  subValue!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E4D31),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (showEdit)
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              foregroundColor: Colors.grey,
            ),
            child: const Text('Edit', style: TextStyle(fontSize: 12)),
          ),
        if (showArrow) const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }

  Widget _buildSummaryItem(
    IconData? icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFF1F8F1),
            child: Icon(icon, size: 16, color: Colors.green),
          ),
          const SizedBox(width: 12),
        ] else
          const SizedBox(width: 44),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHoldingCol(String label, String value, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox(String text, bool hasAction) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 10, color: Colors.black87),
            ),
          ),
          if (hasAction)
            TextButton(
              onPressed: () {},
              child: const Text(
                'Know More >',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
