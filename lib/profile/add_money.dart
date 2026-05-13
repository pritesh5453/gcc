import 'package:flutter/material.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();
  double? _selectedAmount;
  String _selectedPaymentMethod = 'UPI';

  final List<double> _quickAmounts = [100, 500, 1000, 2000, 5000];
  final List<PaymentMethod> _paymentMethods = [
    PaymentMethod(name: 'UPI', icon: Icons.qr_code_scanner, color: Color(0xFF2E7D32)),
    PaymentMethod(name: 'Credit/Debit Card', icon: Icons.credit_card, color: Color(0xFF1B5E20)),
    PaymentMethod(name: 'Net Banking', icon: Icons.account_balance, color: Color(0xFF388E3C)),
    PaymentMethod(name: 'Wallet', icon: Icons.account_balance_wallet, color: Color(0xFF43A047)),
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _selectQuickAmount(double amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toStringAsFixed(0);
    });
  }

  void _proceedToPay() {
    String amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an amount'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    double amount = double.tryParse(amountText) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Simulate payment processing
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFF2E7D32)),
                SizedBox(height: 16),
                Text('Processing payment...'),
              ],
            ),
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // close dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('₹${amount.toStringAsFixed(2)} added successfully!'),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Return the added amount to previous screen if needed
      Navigator.pop(context, amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1B3B1F)),
          onPressed: () => Navigator.pop(context),
        ),
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
              'Add Money',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B3B1F),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // Amount input card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter Amount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1B3B1F),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      const Text(
                        '₹',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B3B1F),
                          ),
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: TextStyle(fontSize: 32, color: Colors.grey.shade300),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                _selectedAmount = double.tryParse(value);
                              });
                            } else {
                              setState(() {
                                _selectedAmount = null;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 8, thickness: 1),
                  const SizedBox(height: 16),
                  
                  // Quick amount chips
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _quickAmounts.map((amount) {
                      bool isSelected = _selectedAmount == amount;
                      return GestureDetector(
                        onTap: () => _selectQuickAmount(amount),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade200,
                            ),
                          ),
                          child: Text(
                            '₹${amount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 28),
            
            // Payment method section
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B3B1F),
              ),
            ),
            const SizedBox(height: 16),
            
            // Payment method options
            ..._paymentMethods.map((method) => _buildPaymentMethodTile(method)),
            
            const SizedBox(height: 32),
            
            // Proceed button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _proceedToPay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Text(
                  'Proceed to Pay',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Secure payment footer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock_outline, size: 14, color: Color(0xFF2E7D32)),
                const SizedBox(width: 6),
                Text(
                  'Secure Payment Gateway · 100% Safe',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodTile(PaymentMethod method) {
    bool isSelected = _selectedPaymentMethod == method.name;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method.name;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: method.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(method.icon, color: method.color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1B3B1F),
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 22),
          ],
        ),
      ),
    );
  }
}

class PaymentMethod {
  final String name;
  final IconData icon;
  final Color color;
  
  PaymentMethod({required this.name, required this.icon, required this.color});
}