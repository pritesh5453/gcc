import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gcc/Screens/Homescreen/manual_deposite.dart';
import 'package:gcc/Screens/Homescreen/payment_screen.dart';
import 'package:gcc/Models_nServices/Banner/banner_model.dart';
import 'package:gcc/Models_nServices/Banner/banner_svc.dart';
import 'package:gcc/Models_nServices/Trading_response/trading_model.dart';
import 'package:gcc/Models_nServices/Trading_response/trading_svc.dart';
import 'package:gcc/Screens/comman_appbar/comman_appbar.dart';

class BuyGCCUnitsScreen extends StatefulWidget {
  const BuyGCCUnitsScreen({super.key});

  @override
  State<BuyGCCUnitsScreen> createState() => _BuyGCCUnitsScreenState();
}

class _BuyGCCUnitsScreenState extends State<BuyGCCUnitsScreen> {
  static const Color primaryGreen = Color(0xFF1B6B2F);
  static const Color lightGreenBg = Color(0xFFF0FAF2);

  int selectedIndex = 0;
  int _currentBannerIndex = 0;
  late Future<List<BannerModel>> _bannerFuture;
  late Future<TradingCoinsResponse> _tradingCoinsFuture;
  Timer? _autoSlideTimer;
  late PageController _pageController;

  // Custom amount mode: true = Amount→Coins, false = Coins→Amount
  bool _isAmountToCoins = true;
  bool _isCustomAmount = false;

  final TextEditingController _customAmountController = TextEditingController();
  final FocusNode _customAmountFocusNode = FocusNode();

  List<PackModel> packs = [];
  double currentUnitPrice = 0.0;

  // Calculated values – now units are double (fractional allowed)
  double? _enteredAmount; // the value user typed (INR or Units)
  double? _computedAmount; // the other value (INR)
  double? _computedUnits; // units (can be fractional)

  @override
  void initState() {
    super.initState();
    _bannerFuture = fetchBanners();
    _tradingCoinsFuture = fetchTradingCoins();
    _pageController = PageController();
    _customAmountController.addListener(_onCustomAmountChanged);
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    _customAmountController.removeListener(_onCustomAmountChanged);
    _customAmountController.dispose();
    _customAmountFocusNode.dispose();
    super.dispose();
  }

  void _onCustomAmountChanged() {
    final text = _customAmountController.text;
    if (text.isNotEmpty && currentUnitPrice > 0) {
      final value = double.tryParse(text);
      if (value != null && value > 0) {
        if (_isAmountToCoins) {
          // Amount → Units: user enters INR, compute units (fractional)
          final units = value / currentUnitPrice;
          setState(() {
            _enteredAmount = value;
            _computedUnits = units;
            _computedAmount = units * currentUnitPrice;
          });
        } else {
          // Units → Amount: user enters units (fractional allowed)
          final units = value; // can be decimal
          final amount = units * currentUnitPrice;
          setState(() {
            _enteredAmount = value;
            _computedUnits = units;
            _computedAmount = amount;
          });
        }
      } else {
        setState(() {
          _enteredAmount = null;
          _computedUnits = null;
          _computedAmount = null;
        });
      }
    } else {
      setState(() {
        _enteredAmount = null;
        _computedUnits = null;
        _computedAmount = null;
      });
    }
  }

  void _startAutoSlide(List<BannerModel> banners) {
    _autoSlideTimer?.cancel();
    if (banners.length > 1) {
      _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_pageController.hasClients && mounted) {
          int nextPage = _currentBannerIndex + 1;
          if (nextPage >= banners.length) nextPage = 0;
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _selectCustomAmount() {
    setState(() {
      _isCustomAmount = true;
      selectedIndex = -1;
      _enteredAmount = null;
      _computedUnits = null;
      _computedAmount = null;
      _customAmountController.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _customAmountFocusNode.requestFocus();
    });
  }

  void _selectPack(int index) {
    setState(() {
      selectedIndex = index;
      _isCustomAmount = false;
      _customAmountController.clear();
      _enteredAmount = null;
      _computedUnits = null;
      _computedAmount = null;
    });
  }

  void _toggleMode(bool isAmountToCoins) {
    setState(() {
      _isAmountToCoins = isAmountToCoins;
      _enteredAmount = null;
      _computedUnits = null;
      _computedAmount = null;
      _customAmountController.clear();
    });
    _customAmountFocusNode.requestFocus();
  }

  // Current selected amount (INR) for summary
  double get _selectedAmount {
    if (_isCustomAmount && _computedAmount != null && _computedAmount! > 0) {
      return _computedAmount!;
    }
    if (selectedIndex >= 0 && selectedIndex < packs.length) {
      return packs[selectedIndex].amount ?? 0;
    }
    return 0;
  }

  // Current selected units (double)
  double get _selectedUnits {
    if (_isCustomAmount && _computedUnits != null && _computedUnits! > 0) {
      return _computedUnits!;
    }
    if (selectedIndex >= 0 && selectedIndex < packs.length) {
      return (packs[selectedIndex].units ?? 0).toDouble();
    }
    return 0;
  }

  bool get _isButtonEnabled {
    if (_isCustomAmount) {
      return _computedUnits != null && _computedUnits! > 0;
    } else {
      return selectedIndex >= 0 && selectedIndex < packs.length;
    }
  }

  bool get _hasSelection {
    return (_isCustomAmount && _computedUnits != null && _computedUnits! > 0) ||
        (selectedIndex >= 0 && selectedIndex < packs.length);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TradingCoinsResponse>(
      future: _tradingCoinsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            body: const Center(
              child: CircularProgressIndicator(color: Color(0xFF1B6B2F)),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Buy GCC Units',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        if (!snapshot.hasData || snapshot.data?.data == null) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Buy GCC Units',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: const Center(child: Text('No packs available')),
          );
        }

        packs = snapshot.data!.data!.packs ?? [];
        currentUnitPrice = snapshot.data!.data!.currentUnitPrice ?? 0.0;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: SafeArea(
            child: Column(
              children: [
                const CommonAppBar(title: 'Buy GCC Units', subtitle: ''),
                _buildTrustBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        _buildBannerSection(),
                        const SizedBox(height: 12),
                        _buildPriceCard(currentUnitPrice),
                        const SizedBox(height: 12),
                        _buildPackSelector(),
                        const SizedBox(height: 12),
                        if (_hasSelection) ...[
                          _buildSummaryCard(),
                          const SizedBox(height: 12),
                          _buildImpactCard(),
                        ],
                        const SizedBox(height: 12),
                        _buildFeatureBadges(),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Trust Bar ─────────────────────────────────────────────────────────────
  Widget _buildTrustBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.verified_user, color: Color(0xFF1B6B2F), size: 14),
          const SizedBox(width: 4),
          const Text(
            'Secure',
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
          _divider(),
          const Text(
            'Trusted',
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
          _divider(),
          const Text(
            'Transparent',
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: Text('|', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
  );

  // ── Banner Section ────────────────────────────────────────────────────────
  Widget _buildBannerSection() {
    return FutureBuilder<List<BannerModel>>(
      future: _bannerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 160,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF1B6B2F)),
            ),
          );
        }

        if (snapshot.hasError ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return _buildHeroBanner();
        }

        final banners = snapshot.data!;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _startAutoSlide(banners);
        });

        return Column(
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: banners.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentBannerIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final banner = banners[index];
                      return Image.network(
                        banner.image ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF1B6B2F),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return _buildHeroBanner();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            if (banners.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    banners.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentBannerIndex == index ? 20 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color:
                            _currentBannerIndex == index
                                ? const Color(0xFF1B6B2F)
                                : Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ── Hero Banner ───────────────────────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 200,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Color(0xFFD8F5E0)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          const Positioned(
            top: 18,
            right: 60,
            child: Text(
              '✓',
              style: TextStyle(color: Color(0xFF4CAF50), fontSize: 10),
            ),
          ),
          const Positioned(
            top: 30,
            right: 80,
            child: Text(
              '✓',
              style: TextStyle(color: Color(0xFF4CAF50), fontSize: 8),
            ),
          ),
          const Positioned(
            top: 14,
            right: 110,
            child: Text(
              '✓',
              style: TextStyle(color: Color(0xFF4CAF50), fontSize: 10),
            ),
          ),
          const Positioned(
            right: 10,
            top: 10,
            bottom: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🌱', style: TextStyle(fontSize: 70)),
                Text('🤲', style: TextStyle(fontSize: 28)),
              ],
            ),
          ),
          const Positioned(
            left: 18,
            top: 28,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Every Unit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Creates Impact',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B6B2F),
                  ),
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      'You buy. We plant.\nThe planet grows. ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    Text('🌿', style: TextStyle(fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Price Card ────────────────────────────────────────────────────────────
  Widget _buildPriceCard(double unitPrice) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.monetization_on_outlined,
                color: Color(0xFF1B6B2F),
                size: 18,
              ),
              const SizedBox(width: 6),
              const Text(
                'Current Unit Price',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${unitPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              const Padding(
                padding: EdgeInsets.only(bottom: 4),
                child: Text(
                  '/ Unit',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FAF2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: Color(0xFF1B6B2F),
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '100% Secure\nPayments',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF1B6B2F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Price is fixed and not an investment.',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ── Pack Selector ─────────────────────────────────────────────────────────
  Widget _buildPackSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shopping_basket_outlined,
                color: Color(0xFF1B6B2F),
                size: 18,
              ),
              const SizedBox(width: 6),
              const Text(
                'Choose Your Pack',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _selectCustomAmount,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _isCustomAmount
                            ? const Color(0xFF1B6B2F)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF1B6B2F)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        color:
                            _isCustomAmount
                                ? Colors.white
                                : const Color(0xFF1B6B2F),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Custom Amount',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              _isCustomAmount
                                  ? Colors.white
                                  : const Color(0xFF1B6B2F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (packs.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ...List.generate(
                    packs.length,
                    (i) => _PackCard(
                      pack: packs[i],
                      isSelected: selectedIndex == i && !_isCustomAmount,
                      onTap: () => _selectPack(i),
                    ),
                  ),
                ],
              ),
            ),
          if (_isCustomAmount) ...[
            const SizedBox(height: 16),
            _buildCustomAmountCard(),
          ],
        ],
      ),
    );
  }

  // ── Custom Amount Card (now with fractional units) ──────────────────────
  Widget _buildCustomAmountCard() {
    final bool showResult = _computedUnits != null && _computedUnits! > 0;
    final bool showWarning =
        _enteredAmount != null &&
        _enteredAmount! > 0 &&
        (_computedUnits == null || _computedUnits! <= 0);

    String inputLabel = _isAmountToCoins ? 'Enter Amount (₹)' : 'Enter Units';
    String resultLabel = _isAmountToCoins ? 'You get' : 'You pay';
    String resultValue = '';
    if (_isAmountToCoins && _computedUnits != null) {
      resultValue = '${_computedUnits!.toStringAsFixed(2)} Units';
    } else if (!_isAmountToCoins && _computedAmount != null) {
      resultValue = '₹${_computedAmount!.toStringAsFixed(2)}';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3FBF5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1B6B2F), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mode toggle
          Row(
            children: [
              Expanded(
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(
                      value: true,
                      label: Text('₹ → Units'),
                      icon: Icon(Icons.currency_rupee, size: 16),
                    ),
                    ButtonSegment<bool>(
                      value: false,
                      label: Text('Units → ₹'),
                      icon: Icon(Icons.square_foot, size: 16),
                    ),
                  ],
                  selected: {_isAmountToCoins},
                  onSelectionChanged: (Set<bool> newSelection) {
                    _toggleMode(newSelection.first);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return const Color(0xFF1B6B2F);
                      }
                      return Colors.white;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith<Color>((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return Colors.black87;
                    }),
                    side: WidgetStateProperty.resolveWith<BorderSide>((states) {
                      return BorderSide(
                        color:
                            states.contains(WidgetState.selected)
                                ? const Color(0xFF1B6B2F)
                                : Colors.grey.shade300,
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Input field
          TextField(
            controller: _customAmountController,
            focusNode: _customAmountFocusNode,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: inputLabel,
              hintText: _isAmountToCoins ? 'e.g., 500' : 'e.g., 10.5',
              prefixText: _isAmountToCoins ? '₹ ' : null,
              suffixText: _isAmountToCoins ? null : ' Units',
              suffixStyle: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF1B6B2F),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Result display
          if (showResult && resultValue.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    resultLabel,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  Text(
                    resultValue,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B6B2F),
                    ),
                  ),
                ],
              ),
            ),

          if (showWarning) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Amount is too small to receive any units. Please enter a higher amount.',
                      style: TextStyle(fontSize: 12, color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 8),
          const Text(
            'Minimum 0.001 unit required.',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ── Summary Card (units displayed with 2 decimals) ──────────────────────
  Widget _buildSummaryCard() {
    final totalAmount = _selectedAmount.toStringAsFixed(2);
    final units = _selectedUnits;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0FAF2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Color(0xFF1B6B2F),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'You Pay',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        '₹$totalAmount',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward,
              color: Colors.grey,
              size: 18,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'You Get',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  '${units.toStringAsFixed(2)} Units',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B6B2F),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FAF2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '₹${currentUnitPrice.toStringAsFixed(2)} / Unit',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF1B6B2F),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Impact Card ───────────────────────────────────────────────────────────
  Widget _buildImpactCard() {
    final units = _selectedUnits;
    final treesSupported = (units * 0.5).toInt(); // floor to whole trees

    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFFF0FAF2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBE5C8)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 160,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF0FAF2), Color(0xFFD0F0DA)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: const Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: Text('🌍', style: TextStyle(fontSize: 65)),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Text('🌲', style: TextStyle(fontSize: 30)),
                  ),
                  Positioned(
                    top: 10,
                    right: 30,
                    child: Text('🐦', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1B6B2F),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite, color: Colors.white, size: 12),
                  SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Thank You!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'For Choosing Green',
                        style: TextStyle(color: Colors.white70, fontSize: 9),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.eco, color: Color(0xFF1B6B2F), size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      'Your Impact',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1B6B2F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  '${units.toStringAsFixed(2)} Units = Supports ~$treesSupported Trees',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'You are one step closer to a\ngreener tomorrow.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Feature Badges ────────────────────────────────────────────────────────
  Widget _buildFeatureBadges() {
    final features = [
      {'icon': Icons.verified_user_outlined, 'label': 'Secure\nPayments'},
      {'icon': Icons.bolt_outlined, 'label': 'Instant\nUnits'},
      {'icon': Icons.bar_chart_outlined, 'label': 'Track\nImpact'},
      {'icon': Icons.remove_red_eye_outlined, 'label': '100%\nTransparent'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            features.map((f) {
              return Column(
                children: [
                  Icon(
                    f['icon'] as IconData,
                    color: const Color(0xFF1B6B2F),
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    f['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }

  // ── Bottom Bar ────────────────────────────────────────────────────────────
  Widget _buildBottomBar() {
    String? validationMessage;
    if (_isCustomAmount) {
      if (_customAmountController.text.isEmpty) {
        validationMessage = 'Please enter an amount';
      } else if (_enteredAmount == null || _enteredAmount! <= 0) {
        validationMessage = 'Please enter a valid value';
      } else if (_computedUnits == null || _computedUnits! <= 0) {
        validationMessage = 'Amount is too low to receive any units';
      }
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isButtonEnabled ? _handleBuyUnits : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B6B2F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
                disabledBackgroundColor: Colors.grey[400],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Proceed to Payment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                ],
              ),
            ),
          ),
          if (validationMessage != null && _isCustomAmount) ...[
            const SizedBox(height: 8),
            Text(
              validationMessage,
              style: const TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user_outlined, size: 13, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                'Your payment information is safe and encrypted.',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _handleBuyUnits() async {
    double amount;
    double units;

    if (_isCustomAmount && _computedAmount != null && _computedAmount! > 0) {
      amount = _computedAmount!;
      units = _computedUnits ?? 0;
    } else if (selectedIndex >= 0 && selectedIndex < packs.length) {
      amount = packs[selectedIndex].amount ?? 0;
      units = (packs[selectedIndex].units ?? 0).toDouble();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter an amount')),
      );
      return;
    }

    if (amount <= 0 || units <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    debugPrint('Buy request amount: $amount, units: $units');

    // ⚠️ You must change BuyGCCScreen's `gccUnits` parameter from `int` to `double`
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BuyGCCScreen(purchaseAmount: amount, gccUnits: units),
      ),
    );
  }
}

// ── Pack Card (unchanged) ──────────────────────────────────────────────────
class _PackCard extends StatelessWidget {
  final PackModel pack;
  final bool isSelected;
  final VoidCallback onTap;

  const _PackCard({
    required this.pack,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String units = pack.units?.toString() ?? '0';
    final String price = (pack.amount ?? 0).toStringAsFixed(0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF3FBF5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1B6B2F) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (isSelected)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1B6B2F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                ),
              ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (pack.image != null && pack.image!.isNotEmpty)
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.network(
                      pack.image!,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              const Text('🌱', style: TextStyle(fontSize: 32)),
                    ),
                  )
                else
                  const Text('🌱', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 8),
                Text(
                  units,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Units',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
                const SizedBox(height: 6),
                Text(
                  '₹$price',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B6B2F),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
