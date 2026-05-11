import 'package:flutter/material.dart';

class ResellExchangeScreen extends StatefulWidget {
  const ResellExchangeScreen({super.key});

  @override
  State<ResellExchangeScreen> createState() => _ResellExchangeScreenState();
}

class _ResellExchangeScreenState extends State<ResellExchangeScreen> {
  // Sample coin data
  String coinName = 'GreenCoin';
  String coinSymbol = 'GRN';
  double currentPrice = 24.85;
  double priceChange = 1.42;
  double priceChangePercent = 6.06;
  double high24h = 25.32;
  double low24h = 23.18;
  double volume = 1245000;
  double userBalance = 450.75; // user holds this many coins
  String selectedOrderType = 'Buy'; // 'Buy' or 'Sell'
  final TextEditingController amountController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // Simulated recent trades
  List<Map<String, dynamic>> recentTrades = [
    {'price': 24.85, 'amount': 125.5, 'time': '10:32 AM', 'type': 'buy'},
    {'price': 24.78, 'amount': 89.2, 'time': '10:28 AM', 'type': 'sell'},
    {'price': 24.92, 'amount': 210.0, 'time': '10:15 AM', 'type': 'buy'},
    {'price': 24.65, 'amount': 45.8, 'time': '10:05 AM', 'type': 'sell'},
    {'price': 24.70, 'amount': 320.1, 'time': '09:52 AM', 'type': 'buy'},
  ];

  @override
  void dispose() {
    amountController.dispose();
    priceController.dispose();
    super.dispose();
  }

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
          'Resell & Exchange',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF2E7D32)),
            onPressed: () {
              // Simulate price change
              setState(() {
                double change =
                    (DateTime.now().millisecondsSinceEpoch % 100) / 1000;
                currentPrice = currentPrice + (change - 0.5) / 10;
                priceChange = currentPrice - 24.0;
                priceChangePercent = (priceChange / 24.0) * 100;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Prices updated!'),
                  duration: Duration(milliseconds: 500),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPriceCard(),
            const SizedBox(height: 20),
            _buildBalanceCard(),
            const SizedBox(height: 20),
            _buildOrderTypeToggle(),
            const SizedBox(height: 16),
            _buildOrderForm(),
            const SizedBox(height: 20),
            _buildMarketDepthCard(),
            const SizedBox(height: 20),
            _buildRecentTrades(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard() {
    bool isPositive = priceChange >= 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[700]!, Colors.green[800]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.currency_bitcoin,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$coinName ($coinSymbol)',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${currentPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isPositive ? Colors.green[400] : Colors.red[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${isPositive ? '+' : ''}${priceChangePercent.toStringAsFixed(2)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoChip('24h High', '₹${high24h.toStringAsFixed(2)}'),
              _infoChip('24h Low', '₹${low24h.toStringAsFixed(2)}'),
              _infoChip('Volume', '₹${(volume / 1000).toStringAsFixed(0)}K'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    double usdValue = userBalance * currentPrice;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Balance',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                '$userBalance $coinSymbol',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '≈ ₹${usdValue.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Color(0xFF2E7D32),
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTypeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedOrderType = 'Buy'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      selectedOrderType == 'Buy'
                          ? Colors.green[700]
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'Buy',
                    style: TextStyle(
                      color:
                          selectedOrderType == 'Buy'
                              ? Colors.white
                              : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedOrderType = 'Sell'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      selectedOrderType == 'Sell'
                          ? Colors.red[700]
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    'Sell',
                    style: TextStyle(
                      color:
                          selectedOrderType == 'Sell'
                              ? Colors.white
                              : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderForm() {
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
            'Place Order',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: const OutlineInputBorder(),
                    suffixText: coinSymbol,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price (Limit)',
                    border: OutlineInputBorder(),
                    prefixText: '₹',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    amountController.text = (userBalance).toString();
                  },
                  icon: const Icon(Icons.maximize, size: 16),
                  label: const Text('Max'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter amount')),
                      );
                      return;
                    }
                    double amount = double.tryParse(amountController.text) ?? 0;
                    double price =
                        priceController.text.isEmpty
                            ? currentPrice
                            : double.tryParse(priceController.text) ??
                                currentPrice;
                    double total = amount * price;
                    String action = selectedOrderType;
                    if (action == 'Buy') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Buy order placed! Total: ₹${total.toStringAsFixed(2)}',
                          ),
                        ),
                      );
                    } else {
                      if (amount > userBalance) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Insufficient balance!'),
                          ),
                        );
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Sell order placed! You will receive ₹${total.toStringAsFixed(2)}',
                          ),
                        ),
                      );
                      // Simulate balance deduction for demo
                      setState(() {
                        userBalance -= amount;
                      });
                      amountController.clear();
                      priceController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedOrderType == 'Buy'
                            ? Colors.green[700]
                            : Colors.red[700],
                  ),
                  child: Text(selectedOrderType),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMarketDepthCard() {
    // Instead of graph, show a simple depth indicator (bid/ask spread)
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
            'Market Depth',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Bid',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${(currentPrice - 0.12).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '1,250',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: Colors.grey.shade300),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Ask',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${(currentPrice + 0.08).toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      '980',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: Colors.grey.shade300),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Spread',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${(0.20).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      '0.80%',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: 0.65,
            backgroundColor: Colors.green[100],
            color: Colors.green[700],
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Buy Pressure',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Text(
                'Sell Pressure',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTrades() {
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
            'Recent Trades',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: recentTrades.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (ctx, idx) {
                var trade = recentTrades[idx];
                bool isBuy = trade['type'] == 'buy';
                return ListTile(
                  dense: true,
                  leading: Icon(
                    isBuy ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isBuy ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  title: Text(
                    '₹${trade['price'].toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    '${trade['amount']} $coinSymbol',
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: Text(
                    trade['time'],
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
