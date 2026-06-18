import 'package:flutter/material.dart';
import 'package:gcc/Homescreen/buy_gcc_units_screen.dart';
import 'package:gcc/Homescreen/resell_&_exchange.dart';
import 'package:gcc/Models_nServices/portfolio/portfolio_model.dart';
import 'package:gcc/Models_nServices/portfolio/portfolio_svc.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/profile/referral_screen.dart';
import 'package:gcc/profile/transaction_record_screen.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final PortfolioService _portfolioService = PortfolioService();
  final AppPreference _appPref = AppPreference();
  late Future<PortfolioResponse> _portfolioFuture;

  // Responsive helpers (baseline: 375 width, 812 height)
  double get _width => MediaQuery.of(context).size.width;
  double get _height => MediaQuery.of(context).size.height;
  double rw(double value) => value * (_width / 375);
  double rh(double value) => value * (_height / 812);
  double rs(double value) => value * (_width / 375);

  @override
  void initState() {
    super.initState();
    _loadPortfolio();
  }

  void _loadPortfolio() {
    final token = _appPref.getString(PreferencesKey.authToken);
    if (token.isEmpty) {
      _portfolioFuture = Future.error('Authentication token missing');
    } else {
      _portfolioFuture = _portfolioService.fetchPortfolio(token);
    }
  }

  String _formatDouble(double value) {
    if (value == value.toInt()) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          children: [
            Text(
              "My Portfolio",
              style: TextStyle(
                color: const Color(0xFF1B5E20),
                fontWeight: FontWeight.bold,
                fontSize: rs(18),
              ),
            ),
            Text(
              "Your GCC overview",
              style: TextStyle(color: Colors.grey[500], fontSize: rs(12)),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<PortfolioResponse>(
        future: _portfolioFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: const Color(0xFF1B5E20)),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: rh(16)),
                  Text('Error: ${snapshot.error}'),
                  SizedBox(height: rh(16)),
                  ElevatedButton(
                    onPressed: () => setState(() => _loadPortfolio()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B5E20),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            final portfolioData = snapshot.data!.data;
            final portfolio = portfolioData.portfolio;
            final holdingsSummary = portfolioData.holdingsSummary;
            final quickStats = portfolioData.quickStats;

            return SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(rw(16), rh(8), rw(16), rh(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainCard(
                      totalUnits: portfolio.totalUnits,
                      unitPrice: portfolio.unitPrice,
                      totalValue: portfolio.totalValue,
                    ),
                    SizedBox(height: rh(16)),
                    _buildActionGrid(),
                    SizedBox(height: rh(16)),
                    _buildHoldingsSummary(
                      totalUnits: holdingsSummary.totalUnits,
                      totalValue: holdingsSummary.currentValue,
                      unitPrice: portfolio.unitPrice,
                    ),
                    SizedBox(height: rh(16)),
                    _buildKeepGrowingBanner(),
                    SizedBox(height: rh(16)),
                    _buildQuickStats(
                      co2Offset: quickStats.co2Offset,
                      waterSaved: quickStats.waterSaved,
                      energySaved: quickStats.energySaved,
                      treesPlanted: quickStats.treesPlanted,
                    ),
                    SizedBox(height: rh(16)),
                    _buildDisclaimer(),
                    SizedBox(height: rh(16)),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No portfolio data found'));
          }
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 1. MAIN CARD (responsive)
  // ─────────────────────────────────────────────────────────
  Widget _buildMainCard({
    required double totalUnits,
    required double unitPrice,
    required double totalValue,
  }) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(rw(20)),
        gradient: LinearGradient(
          colors: [Colors.green[50]!, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.green[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.08),
            blurRadius: rh(12),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/Images/portfolio.png',
              fit: BoxFit.cover,
              alignment: Alignment.centerRight,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.96),
                    Colors.white.withOpacity(0.85),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.52, 1.0],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(rw(20), rh(20), rw(160), rh(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total GCC Units",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                    fontSize: rs(13),
                  ),
                ),
                SizedBox(height: rh(6)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatDouble(totalUnits),
                      style: TextStyle(
                        fontSize: rs(38),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2E7D32),
                        height: 1.1,
                      ),
                    ),
                    SizedBox(width: rw(6)),
                    Padding(
                      padding: EdgeInsets.only(bottom: rh(5)),
                      child: Text(
                        "Units",
                        style: TextStyle(
                          fontSize: rs(16),
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "₹${unitPrice.toStringAsFixed(2)} per unit (Current Price)",
                  style: TextStyle(
                    color: Colors.green[600],
                    fontSize: rs(11),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: rh(14)),
                Text(
                  "Total Value",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                    fontSize: rs(13),
                  ),
                ),
                Text(
                  "₹${totalValue.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: rs(26),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: rh(4)),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: rs(11),
                      color: Colors.grey[400],
                    ),
                    SizedBox(width: rw(3)),
                    Text(
                      "Value is based on current price",
                      style: TextStyle(
                        fontSize: rs(10),
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 2. ACTION GRID (responsive)
  // ─────────────────────────────────────────────────────────
  Widget _buildActionGrid() {
    return Row(
      children: [
        _actionItem(Icons.trending_up_rounded, "Buy More", "Buy GCC Units", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BuyGCCUnitsScreen()),
          );
        }),
        _actionItem(Icons.swap_horiz_rounded, "Exchange", "Resell Units", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ExchangeGCCScreen()),
          );
        }),
        _actionItem(
          Icons.receipt_long_outlined,
          "Transactions",
          "View History",
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TransactionHistoryScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _actionItem(
    IconData icon,
    String title,
    String sub,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(rw(13)),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(rw(14)),
                border: Border.all(color: Colors.grey[200]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: rh(6),
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: const Color(0xFF2E7D32), size: rs(22)),
            ),
            SizedBox(height: rh(7)),
            Text(
              title,
              style: TextStyle(fontSize: rs(12), fontWeight: FontWeight.w600),
            ),
            Text(
              sub,
              style: TextStyle(fontSize: rs(10), color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 3. HOLDINGS SUMMARY (responsive)
  // ─────────────────────────────────────────────────────────
  Widget _buildHoldingsSummary({
    required double totalUnits,
    required double totalValue,
    required double unitPrice,
  }) {
    return Container(
      padding: EdgeInsets.fromLTRB(rw(16), rh(14), rw(16), rh(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(rw(16)),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: rh(6),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart_rounded,
                color: Colors.green[700],
                size: rs(17),
              ),
              SizedBox(width: rw(6)),
              Text(
                "Holdings Summary",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: rs(14)),
              ),
            ],
          ),
          SizedBox(height: rh(14)),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _holdingsCol(
                  Icons.energy_savings_leaf_outlined,
                  _formatDouble(totalUnits),
                  "Total Units\nOwned",
                ),
                _vDivider(),
                _holdingsCol(
                  Icons.account_balance_wallet_outlined,
                  "₹${totalValue.toStringAsFixed(2)}",
                  "Total Value\n(Current)",
                ),
                _vDivider(),
                _holdingsCol(
                  Icons.monetization_on_outlined,
                  "₹${unitPrice.toStringAsFixed(2)}",
                  "Current Price\nper Unit",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vDivider() => Container(
    width: 1,
    color: Colors.grey[200],
    margin: EdgeInsets.symmetric(horizontal: rw(4)),
  );

  Widget _holdingsCol(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF388E3C), size: rs(20)),
          SizedBox(height: rh(6)),
          Text(
            value,
            style: TextStyle(
              fontSize: rs(13),
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: rh(3)),
          Text(
            label,
            style: TextStyle(fontSize: rs(9), color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 4. KEEP GROWING BANNER (responsive)
  // ─────────────────────────────────────────────────────────
  Widget _buildKeepGrowingBanner() {
    return Container(
      height: rh(100),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(rw(16)),
        image: const DecorationImage(
          image: AssetImage('assets/Images/portfolio.png'),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(rw(16)),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.50),
              Colors.black.withOpacity(0.15),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: rw(16)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Keep Growing!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: rs(14),
                    ),
                  ),
                  SizedBox(height: rh(4)),
                  Text(
                    "Your contributions are creating real\nimpact. Keep supporting a greener\ntomorrow.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: rs(10),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReferralGrowthScreen(),
                    ),
                  ),
              icon: Icon(Icons.person_add_alt_1_rounded, size: rs(12)),
              label: Text("Invite Friends", style: TextStyle(fontSize: rs(10))),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1B5E20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(rw(10)),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: rw(10),
                  vertical: rh(8),
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 5. QUICK STATS (responsive horizontal list)
  // ─────────────────────────────────────────────────────────
  Widget _buildQuickStats({
    required String co2Offset,
    required String waterSaved,
    required String energySaved,
    required int treesPlanted,
  }) {
    final stats = [
      (
        "CO₂ Offset",
        co2Offset,
        const Color(0xFFE8F5E9),
        Icons.eco_rounded,
        const Color(0xFF2E7D32),
      ),
      (
        "Water Saved",
        waterSaved,
        const Color(0xFFE3F2FD),
        Icons.water_drop_rounded,
        const Color(0xFF1565C0),
      ),
      (
        "Energy Saved",
        energySaved,
        const Color(0xFFFFFDE7),
        Icons.bolt_rounded,
        const Color(0xFFF9A825),
      ),
      (
        "Trees Supported",
        "$treesPlanted",
        const Color(0xFFF1F8E9),
        Icons.park_rounded,
        const Color(0xFF33691E),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.bar_chart_rounded,
              color: Colors.green[700],
              size: rs(17),
            ),
            SizedBox(width: rw(6)),
            Text(
              "Quick Stats",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: rs(14)),
            ),
          ],
        ),
        SizedBox(height: rh(12)),
        SizedBox(
          height: rh(130),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: stats.length,
            separatorBuilder: (_, __) => SizedBox(width: rw(12)),
            itemBuilder: (context, index) {
              return _statCard(
                label: stats[index].$1,
                value: stats[index].$2,
                subtitle: "Approx.",
                bg: stats[index].$3,
                icon: stats[index].$4,
                iconColor: stats[index].$5,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required String subtitle,
    required Color bg,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: rw(140),
      padding: EdgeInsets.fromLTRB(rw(12), rh(10), rw(12), rh(10)),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(rw(14)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: iconColor, size: rs(20)),
          SizedBox(height: rh(8)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: rs(17),
              color: iconColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: rh(4)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: rs(10),
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: rs(9), color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // 6. DISCLAIMER (responsive)
  // ─────────────────────────────────────────────────────────
  Widget _buildDisclaimer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: rw(12), vertical: rh(9)),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(rw(10)),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_outlined, color: Colors.green[600], size: rs(14)),
          SizedBox(width: rw(8)),
          Expanded(
            child: Text(
              "GCC Units are digital eco-vouchers. Not an investment. No guaranteed returns.",
              style: TextStyle(fontSize: rs(10), color: Colors.grey[500]),
            ),
          ),
        ],
      ),
    );
  }
}
