import 'package:flutter/material.dart';
import 'package:gcc/profile/add_money.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  // Sample balance and transaction data
  double _balance = 1250.75;

  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      title: 'Added to Wallet',
      amount: 500.0,
      date: DateTime(2025, 4, 15),
      isCredit: true,
      icon: Icons.add_circle_outline,
    ),
    Transaction(
      id: '2',
      title: 'Tree Plantation Drive',
      amount: 150.0,
      date: DateTime(2025, 4, 12),
      isCredit: false,
      icon: Icons.forest,
    ),
    Transaction(
      id: '3',
      title: 'Cashback Earned',
      amount: 25.50,
      date: DateTime(2025, 4, 10),
      isCredit: true,
      icon: Icons.arrow_upward,
    ),
    Transaction(
      id: '4',
      title: 'Eco Workshop',
      amount: 75.0,
      date: DateTime(2025, 4, 8),
      isCredit: false,
      icon: Icons.workspace_premium,
    ),
    Transaction(
      id: '5',
      title: 'Referral Bonus',
      amount: 100.0,
      date: DateTime(2025, 4, 5),
      isCredit: true,
      icon: Icons.people_outline,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9F5),
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/tree.png',
              height: 20,
              width: 20,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 6),
            const Text(
              'My Wallet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B3B1F),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1B3B1F)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Color(0xFF2E7D32)),
            onPressed: () {
              // Navigate to full transaction history
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // --- Balance Card ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white70,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Total Balance',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.85),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '₹${_balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddMoneyScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Money'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _sendMoney(context),
                          icon: const Icon(Icons.send, size: 16),
                          label: const Text('Send'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // --- Quick Actions Row ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickAction(Icons.qr_code_scanner, 'Scan & Pay', () {}),
                _buildQuickAction(Icons.receipt_long, 'Request', () {}),
                _buildQuickAction(Icons.history, 'History', () {}),
                _buildQuickAction(Icons.help_outline, 'Help', () {}),
              ],
            ),

            const SizedBox(height: 32),

            // --- Recent Transactions Header ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B3B1F),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // --- Transactions List ---
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              separatorBuilder:
                  (context, index) =>
                      Divider(color: Colors.grey.shade200, thickness: 1),
              itemBuilder: (context, index) {
                final transaction = _transactions[index];
                return _buildTransactionTile(transaction);
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: const Color(0xFF2E7D32), size: 26),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTile(Transaction transaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  transaction.isCredit
                      ? const Color(0xFF2E7D32).withOpacity(0.1)
                      : Colors.red.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              transaction.icon,
              color:
                  transaction.isCredit
                      ? const Color(0xFF2E7D32)
                      : Colors.red.shade400,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1B3B1F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(transaction.date),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.isCredit ? '+' : '-'} ₹${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color:
                      transaction.isCredit
                          ? const Color(0xFF2E7D32)
                          : Colors.red.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }
    final difference = now.difference(date).inDays;
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return '${difference} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  // Dummy functions for demonstration
  void _addMoney(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add Money feature coming soon!'),
        backgroundColor: Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _sendMoney(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Send Money feature coming soon!'),
        backgroundColor: Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// Transaction model class
class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isCredit; // true = money added, false = money spent
  final IconData icon;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isCredit,
    required this.icon,
  });
}
