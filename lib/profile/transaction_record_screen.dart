import 'package:flutter/material.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B5E20)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Transaction History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryCard(),
            const SizedBox(height: 20),
            _buildFilterChips(),
            const SizedBox(height: 16),
            _buildTransactionList(context), // ✅ context passed here
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[700]!, Colors.green[800]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Spent',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 4),
              const Text(
                '₹ 1,850',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Last 30 days',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Total Earned',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 4),
              const Text(
                '₹ 450',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.white70, size: 14),
                  SizedBox(width: 4),
                  Text(
                    '+12% vs last month',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final List<String> filters = ['All', 'Rewards', 'Redeemed', 'Donations', 'Deposits'];
    int selectedIndex = 0; // For demo, can be stateful if needed
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.asMap().entries.map((entry) {
          int idx = entry.key;
          String label = entry.value;
          bool isSelected = idx == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (selected) {
                // Update state in a StatefulWidget if needed
              },
              backgroundColor: Colors.white,
              selectedColor: Colors.green[100],
              checkmarkColor: Colors.green[700],
              labelStyle: TextStyle(
                color: isSelected ? Colors.green[700] : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ✅ Added BuildContext parameter
  Widget _buildTransactionList(BuildContext context) {
    final transactions = [
      _Transaction(
        id: 'TXN001',
        title: 'Plastic Waste Drop',
        date: 'Today, 10:30 AM',
        amount: '+ ₹ 25',
        type: 'credit',
        category: 'Earned',
        icon: Icons.recycling,
        iconColor: Colors.green,
      ),
      _Transaction(
        id: 'TXN002',
        title: 'Recycled PET Bottles',
        date: 'Yesterday, 4:15 PM',
        amount: '+ ₹ 40',
        type: 'credit',
        category: 'Earned',
        icon: Icons.water_drop,
        iconColor: Colors.blue,
      ),
      _Transaction(
        id: 'TXN003',
        title: 'Reward Redeemed - Plant Kit',
        date: 'Dec 12, 2024',
        amount: '- ₹ 150',
        type: 'debit',
        category: 'Redeemed',
        icon: Icons.card_giftcard,
        iconColor: Colors.orange,
      ),
      _Transaction(
        id: 'TXN004',
        title: 'E-Waste Collection',
        date: 'Dec 10, 2024',
        amount: '+ ₹ 60',
        type: 'credit',
        category: 'Earned',
        icon: Icons.computer,
        iconColor: Colors.purple,
      ),
      _Transaction(
        id: 'TXN005',
        title: 'Tree Plantation Donation',
        date: 'Dec 5, 2024',
        amount: '- ₹ 200',
        type: 'debit',
        category: 'Donation',
        icon: Icons.park,
        iconColor: Colors.brown,
      ),
      _Transaction(
        id: 'TXN006',
        title: 'Weekly Challenge Bonus',
        date: 'Dec 1, 2024',
        amount: '+ ₹ 100',
        type: 'credit',
        category: 'Bonus',
        icon: Icons.emoji_events,
        iconColor: Colors.amber,
      ),
    ];

    // Group by date
    Map<String, List<_Transaction>> grouped = {};
    for (var tx in transactions) {
      String groupKey = tx.date.contains('Today')
          ? 'Today'
          : tx.date.contains('Yesterday')
          ? 'Yesterday'
          : 'December 2024';
      if (!grouped.containsKey(groupKey)) grouped[groupKey] = [];
      grouped[groupKey]!.add(tx);
    }

    return Column(
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                entry.key,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: entry.value.map((tx) {
                  final isLast = entry.value.last == tx;
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: tx.iconColor.withOpacity(0.1),
                          child: Icon(tx.icon, color: tx.iconColor, size: 20),
                        ),
                        title: Text(
                          tx.title,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        subtitle: Text(
                          '${tx.date} • ${tx.category}',
                          style: const TextStyle(fontSize: 11, color: Colors.grey),
                        ),
                        trailing: Text(
                          tx.amount,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: tx.type == 'credit' ? Colors.green[700] : Colors.red,
                          ),
                        ),
                        onTap: () => _showTransactionDetails(context, tx), // ✅ context now available
                      ),
                      if (!isLast)
                        Divider(height: 1, indent: 70, color: Colors.grey.shade100),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  void _showTransactionDetails(BuildContext context, _Transaction tx) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: tx.iconColor.withOpacity(0.1),
                  child: Icon(tx.icon, color: tx.iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(
                        tx.category,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Text(
                  tx.amount,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: tx.type == 'credit' ? Colors.green[700] : Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            _detailRow('Transaction ID', tx.id),
            _detailRow('Date & Time', tx.date),
            _detailRow('Status', 'Completed'),
            _detailRow('Payment Method', 'GreenChain Wallet'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Close'),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
        ],
      ),
    );
  }
}

class _Transaction {
  final String id;
  final String title;
  final String date;
  final String amount;
  final String type; // 'credit' or 'debit'
  final String category;
  final IconData icon;
  final Color iconColor;

  _Transaction({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.type,
    required this.category,
    required this.icon,
    required this.iconColor,
  });
}