import 'package:flutter/material.dart';
import 'package:gcc/Screens/Homescreen/exchange_review.dart';
import 'package:gcc/Models_nServices/Coin_sunmary/coin_summary_svc.dart';
import 'package:gcc/Screens/comman_appbar/comman_appbar.dart'; // adjust path

class ExchangeGCCScreen extends StatefulWidget {
  const ExchangeGCCScreen({super.key});

  @override
  State<ExchangeGCCScreen> createState() => _ExchangeGCCScreenState();
}

class _ExchangeGCCScreenState extends State<ExchangeGCCScreen> {
  final TextEditingController _unitsController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;
  double _availableUnits = 0.0;
  double _currentPrice = 0.0;
  double _portfolioValue = 0.0;
  int _serviceChargePercent = 0;
  int _gstPercent = 0;
  double _enteredUnits = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchCoinSummary();
  }

  @override
  void dispose() {
    _unitsController.dispose();
    super.dispose();
  }

  Future<void> _fetchCoinSummary() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await fetchCoinSummary();
      setState(() {
        _availableUnits = response.data.currentUnitsBalance;
        _currentPrice = response.data.gccCurrentPrice;
        _portfolioValue = response.data.portfolioValue;
        _serviceChargePercent = response.data.serviceChargePercentage;
        _gstPercent = response.data.gstPercentage;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = error.toString();
        _isLoading = false;
      });
    }
  }

  void _onUnitsChanged(String value) {
    final parsed = double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
    setState(() {
      _enteredUnits = parsed.clamp(0.0, _availableUnits);
    });
  }

  void _useAllUnits() {
    setState(() {
      _enteredUnits = _availableUnits;
      _unitsController.text = _availableUnits.toStringAsFixed(3);
    });
  }

  double get _grossAmount => _enteredUnits * _currentPrice;
  double get _serviceCharge => _grossAmount * _serviceChargePercent / 100;
  double get _gstCharge => _serviceCharge * _gstPercent / 100;
  double get _estimatedPayout => _grossAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      body: Column(
        children: [
          // Fixed app bar (already has SafeArea inside)
          const CommonAppBar(
            title: 'Exchange GCC Units',
            subtitle: 'Resell your GCC Units securely',
            showHelp: true,
            // onHelpTap: () {}, // optional
          ),
          // Scrollable content area
          Expanded(child: _buildBodyContent()),
        ],
      ),
    );
  }

  Widget _buildBodyContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchCoinSummary,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Main content
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('assets/Images/green.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user, color: Colors.green, size: 18),
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
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
                  _availableUnits.toStringAsFixed(3),
                  'Units',
                  '₹${_currentPrice.toStringAsFixed(2)} / Unit',
                ),
                const SizedBox(
                  height: 50,
                  child: VerticalDivider(color: Colors.black12, thickness: 1),
                ),
                _buildBalanceColumn(
                  'Est. Value',
                  '₹${_portfolioValue.toStringAsFixed(2)}',
                  '',
                  'At ₹${_currentPrice.toStringAsFixed(2)} / Unit',
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
                        Icon(Icons.info_outline, size: 14, color: Colors.grey),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: _availableUnits > 0 ? _useAllUnits : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Use All (${_availableUnits.toStringAsFixed(3)})',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _unitsController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter units',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixText: 'Units',
                  ),
                  onChanged: _onUnitsChanged,
                ),
                const SizedBox(height: 16),
                Text(
                  '${_enteredUnits.toStringAsFixed(3)} Units',
                  style: const TextStyle(
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
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'You Will Get (Est.)',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          Text(
                            '₹${_estimatedPayout.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        '=',
                        style: TextStyle(fontSize: 24, color: Colors.grey),
                      ),
                      Column(
                        children: [
                          const Text(
                            'At Current Price',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                          Text(
                            '₹${_currentPrice.toStringAsFixed(2)} / Unit',
                            style: const TextStyle(
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
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              onPressed: _enteredUnits > 0
    ? () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExchangeReviewScreen(
              coinId: 8,
              enteredUnits: _enteredUnits,
              currentPrice: _currentPrice,
              estimatedPayout: _estimatedPayout,
              availableUnits: _availableUnits,
              grossAmount: _grossAmount,
              serviceCharge: _serviceCharge,
              gstCharge: _gstCharge,
            ),
          ),
        );
      }
    : null,
              style: ElevatedButton.styleFrom(
  backgroundColor: _enteredUnits > 0
      ? const Color(0xFF2E7D32)
      : Colors.grey.shade400,
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
                    child: Icon(Icons.swap_horiz, color: Colors.green),
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
                ],
              ),
            ),
          ),
        ],
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
