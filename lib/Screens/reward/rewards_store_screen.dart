import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gcc/Models_nServices/Coupons/coupons_model.dart';
import 'package:gcc/Models_nServices/Coupons/coupons_svc.dart';
import 'package:gcc/Navbar/navbar.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:gcc/prefs/app_preference.dart';
import 'package:gcc/main.dart';

// ─── Theme colors ────────────────────────────────────────────────────────
const Color kPrimaryGreen = Color(0xFF1B6B2F);
const Color kPrimaryGreenDark = Color(0xFF0F4D1F);
const Color kBg = Color(0xFFF6F8F6);

// ─── Helper enum for coupon status ──────────────────────────────────────
enum _CouponStatus { available, needMore, claimed }

// ─── Main Screen ─────────────────────────────────────────────────────────────
class ScratchCardScreen extends StatefulWidget {
  const ScratchCardScreen({super.key});

  @override
  ScratchCardScreenState createState() => ScratchCardScreenState();
}

class ScratchCardScreenState extends State<ScratchCardScreen> with RouteAware {
  final CouponService _couponService = CouponService();
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;
  int _rewardPoints = 0;
  int total_cashback_earned = 0;
  List<CouponData> _coupons = [];

  // ─── Responsive helpers ────────────────────────────────────────────────
  double get _width => MediaQuery.of(context).size.width;
  double get _height => MediaQuery.of(context).size.height;
  double rw(double value) => value * (_width / 375);
  double rh(double value) => value * (_height / 812);
  double rs(double value) => value * (_width / 375);

  @override
  void initState() {
    super.initState();
    _fetchCoupons(showLoading: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _fetchCoupons(showLoading: false);
  }

  void refreshData() {
    _fetchCoupons(showLoading: false);
  }

  Future<void> _fetchCoupons({bool showLoading = true}) async {
    if (showLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    } else {
      setState(() {
        _isRefreshing = true;
        _errorMessage = null;
      });
    }

    try {
      final token = AppPreference().getString(PreferencesKey.authToken);
      if (token.isEmpty) {
        setState(() {
          _errorMessage = 'Please login again.';
          if (showLoading) _isLoading = false;
          _isRefreshing = false;
        });
        return;
      }

      final response = await _couponService.getCoupons(token: token);
      if (response != null && response.status) {
        // 🔍 Debug: print all coupons to verify required_reward_points
        print('📦 Coupons received:');
        for (var c in response.data) {
          print('id: ${c.id}, name: ${c.couponName}, required: ${c.requiredRewardPoints}, '
              'isScratch: ${c.isScratch}, isEligible: ${c.isEligible}, earned: ${c.earnedAmount}');
        }
        setState(() {
          _rewardPoints = response.rewardPoints;
          total_cashback_earned = response.total_cashback_earned;
          _coupons = response.data;
          if (showLoading) _isLoading = false;
          _isRefreshing = false;
        });
      } else {
        setState(() {
          _errorMessage = response?.status == false ? 'Failed to load coupons' : 'No coupons available';
          if (showLoading) _isLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        if (showLoading) _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await _fetchCoupons(showLoading: false);
  }

  // ─── Determine status ─────────────────────────────────────────────────
  // isScratch == true  → claimed
  // isScratch == false → not claimed; use isEligible to distinguish available/needMore
  _CouponStatus _getStatus(CouponData c) {
    if (c.isScratch) return _CouponStatus.claimed;
    if (c.isEligible) return _CouponStatus.available;
    return _CouponStatus.needMore;
  }

  // ─── Sorted list: all coupons, grouped & sorted ──────────────────────
  List<CouponData> get _sortedCoupons {
    final available = <CouponData>[];
    final needMore = <CouponData>[];
    final claimed = <CouponData>[];

    for (final c in _coupons) {
      switch (_getStatus(c)) {
        case _CouponStatus.available:
          available.add(c);
          break;
        case _CouponStatus.needMore:
          needMore.add(c);
          break;
        case _CouponStatus.claimed:
          claimed.add(c);
          break;
      }
    }

    // Sort each group by required points ascending
    available.sort((a, b) => a.requiredRewardPoints.compareTo(b.requiredRewardPoints));
    needMore.sort((a, b) => a.requiredRewardPoints.compareTo(b.requiredRewardPoints));
    claimed.sort((a, b) => a.requiredRewardPoints.compareTo(b.requiredRewardPoints));

    return [...available, ...needMore, ...claimed];
  }

  int get _scratchableCount => _sortedCoupons
      .where((c) => _getStatus(c) == _CouponStatus.available)
      .length;

  void _onCouponClaimed(int couponId, int rewardAmountWon, int newPoints) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 You won ₹$rewardAmountWon!'),
        backgroundColor: kPrimaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    _fetchCoupons(showLoading: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: kPrimaryGreen))
                  : _errorMessage != null
                  ? _buildErrorWidget()
                  : _coupons.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: kPrimaryGreen,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: rh(14)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: rw(16)),
                              child: _buildBalanceCard(),
                            ),
                            SizedBox(height: rh(22)),
                            _buildSectionHeader(),
                            SizedBox(height: rh(14)),
                            _buildGrid(),
                            SizedBox(height: rh(24)),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Empty state, error, app bar, balance card ──────────────────────
  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: kPrimaryGreen,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: _height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: rw(96),
                  height: rw(96),
                  decoration: BoxDecoration(
                    color: kPrimaryGreen.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('🎯', style: TextStyle(fontSize: rs(46))),
                  ),
                ),
                SizedBox(height: rh(20)),
                Text(
                  'No scratch cards available',
                  style: TextStyle(
                    fontSize: rs(18),
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: rh(6)),
                Text(
                  'Check back later for new offers',
                  style: TextStyle(fontSize: rs(13), color: Colors.grey[600]),
                ),
                SizedBox(height: rh(26)),
                ElevatedButton(
                  onPressed: () => _fetchCoupons(showLoading: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: rw(28), vertical: rh(12)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Refresh', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: kPrimaryGreen,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: _height * 0.7,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(rw(24)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: rw(72),
                    height: rw(72),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.error_outline, size: 36, color: Colors.red),
                  ),
                  SizedBox(height: rh(18)),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: rs(14), color: Colors.black87),
                  ),
                  SizedBox(height: rh(22)),
                  ElevatedButton(
                    onPressed: () => _fetchCoupons(showLoading: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: rw(28), vertical: rh(12)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Retry', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: rw(16), vertical: rh(14)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  'Scratch Cards',
                  style: TextStyle(
                    fontSize: rs(18),
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: rh(2)),
                Text(
                  'Scratch to reveal your rewards',
                  style: TextStyle(fontSize: rs(11.5), color: Colors.black45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: EdgeInsets.fromLTRB(rw(18), rh(18), rw(18), rh(16)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimaryGreen, kPrimaryGreenDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(rw(22)),
        boxShadow: [
          BoxShadow(
            color: kPrimaryGreen.withOpacity(0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -rw(20),
            top: -rh(20),
            child: Container(
              width: rw(90),
              height: rw(90),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -rw(30),
            bottom: -rh(30),
            child: Container(
              width: rw(70),
              height: rw(70),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(rw(8)),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(rw(12)),
                          ),
                          child: Icon(Icons.stars_rounded, color: Colors.amber[300], size: rs(20)),
                        ),
                        SizedBox(width: rw(10)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Reward Points",
                              style: TextStyle(fontSize: rs(11.5), color: Colors.white70),
                            ),
                            SizedBox(height: rh(2)),
                            Text(
                              _rewardPoints.toString(),
                              style: TextStyle(
                                fontSize: rs(30),
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 1,
                    height: rh(40),
                    color: Colors.white.withOpacity(0.18),
                    margin: EdgeInsets.symmetric(horizontal: rw(8)),
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Cashback",
                              style: TextStyle(fontSize: rs(11.5), color: Colors.white70),
                            ),
                            SizedBox(height: rh(2)),
                            Text(
                              '₹$total_cashback_earned',
                              style: TextStyle(
                                fontSize: rs(24),
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: rw(8)),
                        Container(
                          padding: EdgeInsets.all(rw(8)),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(rw(12)),
                          ),
                          child: Icon(Icons.card_giftcard_rounded, color: Colors.pinkAccent[100], size: rs(20)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: rh(14)),
              Container(
                padding: EdgeInsets.symmetric(vertical: rh(6)),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white.withOpacity(0.14), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Available balance",
                        style: TextStyle(fontSize: rs(11.5), color: Colors.white60),
                      ),
                    ),
                    Text(
                      "Total earned so far",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: rs(11.5), color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(rw(16), 0, rw(16), 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your scratch cards',
                style: TextStyle(
                  fontSize: rs(16),
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: rw(10), vertical: rh(4)),
                decoration: BoxDecoration(
                  color: kPrimaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$_scratchableCount available',
                  style: TextStyle(
                    fontSize: rs(11),
                    fontWeight: FontWeight.w600,
                    color: kPrimaryGreen,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: rh(4)),
          Text(
            'Scratch to reveal your reward.',
            style: TextStyle(fontSize: rs(11.5), color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final coupons = _sortedCoupons;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: rw(12)),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
          final cardWidth = (constraints.maxWidth - (crossAxisCount - 1) * 12) / crossAxisCount;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: coupons.map((coupon) {
              return SizedBox(
                key: ValueKey(coupon.id),
                width: cardWidth,
                child: _ScratchCard(
                  coupon: coupon,
                  userPoints: _rewardPoints,
                  onClaimed: _onCouponClaimed,
                  cardWidth: cardWidth,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

// ─── Scratch Card Widget ──────────────────────────────────────────────────
class _ScratchCard extends StatefulWidget {
  final CouponData coupon;
  final int userPoints;
  final void Function(int couponId, int rewardAmount, int newPoints) onClaimed;
  final double cardWidth;

  const _ScratchCard({
    required this.coupon,
    required this.userPoints,
    required this.onClaimed,
    required this.cardWidth,
  });

  @override
  State<_ScratchCard> createState() => _ScratchCardState();
}

class _ScratchCardState extends State<_ScratchCard>
    with SingleTickerProviderStateMixin {
  final CouponService _couponService = CouponService();
  bool _revealed = false;
  bool _isClaiming = false;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  bool get _canScratch =>
      !widget.coupon.isScratch &&
      widget.coupon.isEligible &&
      widget.userPoints >= widget.coupon.requiredRewardPoints &&
      !_isClaiming;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut),
    );

    if (widget.coupon.isScratch || !widget.coupon.isEligible) {
      _revealed = true;
      _fadeCtrl.value = 0;
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _onScratchComplete() async {
    if (_revealed || _isClaiming || !_canScratch) return;

    setState(() => _isClaiming = true);

    try {
      final token = AppPreference().getString(PreferencesKey.authToken);
      if (token.isEmpty) {
        _showError('Please login again');
        setState(() => _isClaiming = false);
        return;
      }

      final response = await _couponService.scratchCoupon(
        token: token,
        couponId: widget.coupon.id,
      );

      if (response != null && response.status) {
        setState(() {
          _revealed = true;
          _isClaiming = false;
          _fadeCtrl.forward();
        });
        widget.onClaimed(
          widget.coupon.id,
          response.data.rewardAmountWon,
          response.data.remainingRewardPoints,
        );
      } else {
        setState(() => _isClaiming = false);
        _showError(response?.message ?? 'Failed to claim reward');
      }
    } catch (e) {
      setState(() => _isClaiming = false);
      _showError('Error: $e');
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: kPrimaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ─── 🌈 Vibrant gradient palette ──────────────────────────────────
  final List<List<Color>> _gradientColors = [
    [Color(0xFFFF7675), Color(0xFFD63031)],
    [Color(0xFFFF9F43), Color(0xFFE67E22)],
    [Color(0xFFFFA502), Color(0xFFF0932B)],
    [Color(0xFFF368E0), Color(0xFF6C5CE7)],
    [Color(0xFFFD79A8), Color(0xFFE84393)],
    [Color(0xFFA29BFE), Color(0xFF6C5CE7)],
    [Color(0xFFD980FA), Color(0xFF6C5CE7)],
    [Color(0xFF74B9FF), Color(0xFF0984E3)],
    [Color(0xFF00CEC9), Color(0xFF00B894)],
    [Color(0xFF55EFC4), Color(0xFF00B894)],
    [Color(0xFF00BFFF), Color(0xFF0066CC)],
    [Color(0xFF7BED9F), Color(0xFF2ECC71)],
    [Color(0xFF2ECC71), Color(0xFF1B5E20)],
    [Color(0xFFFFD93D), Color(0xFFF9CA24)],
    [Color(0xFF00CEC9), Color(0xFF0984E3)],
    [Color(0xFFFF6B6B), Color(0xFFFECA57)],
    [Color(0xFFA29BFE), Color(0xFFFD79A8)],
    [Color(0xFF74B9FF), Color(0xFFF368E0)],
  ];

  List<Color> _getGradient(int id) {
    return _gradientColors[id % _gradientColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.coupon;
    final bool hasEnoughPoints = widget.userPoints >= c.requiredRewardPoints;
    final bool isEligible = c.isEligible && hasEnoughPoints && !c.isScratch;
    final bool isClaimed = c.isScratch;

    final double cardHeight = widget.cardWidth * 0.8;
    final double fontSize = widget.cardWidth * 0.09;
    final double smallFont = widget.cardWidth * 0.05;
    final double pad = widget.cardWidth * 0.07;

    // ─── Claimed card ────────────────────────────────────────────────────
    if (isClaimed) {
      return Opacity(
        opacity: 0.55,
        child: Container(
          height: cardHeight,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: fontSize * 1.5,
                ),
                SizedBox(height: 6),
                Text(
                  'Won ₹${c.earnedAmount}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: fontSize * 0.7,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Required: ${c.requiredRewardPoints} pts',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: smallFont * 0.9,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // ─── Build card content for available / need more ──────────────────
    String discountText;
    String description;
    Color badgeColor;
    String badgeText;
    IconData? badgeIcon;
    bool showScratchLayer;

    if (isEligible) {
      discountText = '₹${c.minRewardAmount} - ₹${c.maxRewardAmount}';
      description = c.couponName;
      badgeColor = const Color(0xFFE84118);
      badgeText = 'NEW';
      badgeIcon = Icons.bolt_rounded;
      showScratchLayer = true;
    } else {
      discountText = '';
      description = 'Need ${c.requiredRewardPoints} pts';
      badgeColor = Colors.black45;
      badgeText = 'LOCKED';
      badgeIcon = Icons.lock_rounded;
      showScratchLayer = false;
    }

    final gradientColors = _getGradient(c.id);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: gradientColors[1].withOpacity(0.28),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: cardHeight,
          child: Stack(
            children: [
              // ─── Always colorful background ────────────────────────────
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.all(pad),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ─── Badge ──────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: badgeColor.withOpacity(0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(badgeIcon, color: Colors.white, size: smallFont * 1.1),
                              SizedBox(width: 3),
                              Text(
                                badgeText,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: smallFont * 0.85,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (showScratchLayer)
                          Container(
                            padding: EdgeInsets.all(smallFont * 0.5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.22),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.credit_card_rounded,
                              color: Colors.white,
                              size: smallFont * 1.3,
                            ),
                          ),
                      ],
                    ),
                    // ─── Discount Amount ──────────────────────────────
                    if (discountText.isNotEmpty)
                      Text(
                        discountText,
                        style: TextStyle(
                          fontSize: fontSize * 1.25,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1,
                          letterSpacing: -0.5,
                        ),
                      ),
                    // ─── Description ────────────────────────────────────
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: smallFont,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    // ─── Required points (visible only when overlay is NOT showing) ──
                    // But we also show them inside overlay, so this is backup.
                    if (isEligible) ...[
                      Text(
                        'Min. spend ₹${c.minRewardAmount}',
                        style: TextStyle(
                          fontSize: smallFont * 0.8,
                          color: Colors.white.withOpacity(0.65),
                        ),
                      ),
                      Text(
                        'Required: ${c.requiredRewardPoints} pts',
                        style: TextStyle(
                          fontSize: smallFont * 0.9,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // ─── Scratch overlay (only for active cards) ──────────────
              if (showScratchLayer && !_revealed)
                FadeTransition(
                  opacity: _fadeAnim,
                  child: _ScratchLayer(
                    onRevealed: _onScratchComplete,
                    requiredPoints: c.requiredRewardPoints,
                  ),
                ),
              if (_isClaiming)
                Container(
                  color: Colors.black.withOpacity(0.55),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.6),
                  ),
                ),
              // ─── Dim overlay for locked cards ──────────────────────
              if (!showScratchLayer && !_revealed)
                Container(
                  color: Colors.black.withOpacity(0.45),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_rounded,
                          color: Colors.white,
                          size: fontSize * 1.6,
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Locked',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: fontSize * 0.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Scratch Layer (CustomPainter) ────────────────────────────────────────
class _ScratchLayer extends StatefulWidget {
  final VoidCallback onRevealed;
  final int requiredPoints;

  const _ScratchLayer({
    required this.onRevealed,
    required this.requiredPoints,
  });

  @override
  State<_ScratchLayer> createState() => _ScratchLayerState();
}

class _ScratchLayerState extends State<_ScratchLayer> {
  final List<Offset> _points = [];
  double _scratchedPercent = 0;
  bool _alreadyRevealed = false;
  Size _lastSize = Size.zero;

  void _addPoint(Offset localPos) {
    setState(() {
      _points.add(localPos);
    });
    _estimateScratch();
  }

  void _estimateScratch() {
    if (_lastSize == Size.zero) return;
    final total = _lastSize.width * _lastSize.height;
    if (total == 0) return;

    double covered = 0;
    const r = 22.0;
    for (final p in _points) {
      covered += pi * r * r;
    }
    _scratchedPercent = (covered / total).clamp(0, 1);

    if (_scratchedPercent > 0.45 && !_alreadyRevealed) {
      _alreadyRevealed = true;
      widget.onRevealed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (d) => _addPoint(d.localPosition),
      onPanUpdate: (d) => _addPoint(d.localPosition),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          _lastSize = Size(constraints.maxWidth, constraints.maxHeight);
          return CustomPaint(
            size: _lastSize,
            painter: _ScratchPainter(
              points: _points,
              requiredPoints: widget.requiredPoints,
            ),
          );
        },
      ),
    );
  }
}

class _ScratchPainter extends CustomPainter {
  final List<Offset> points;
  final int requiredPoints;

  _ScratchPainter({
    required this.points,
    required this.requiredPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ─── Base metallic gradient ────────────────────────────────────
    final basePaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(size.width, size.height),
        [
          const Color(0xFF9AA0A6),
          const Color(0xFF6B7280),
          const Color(0xFF4B5563),
        ],
        [0.0, 0.5, 1.0],
      );
    canvas.drawRect(Offset.zero & size, basePaint);

    // ─── Diagonal shine streaks ─────────────────────────────────────────
    final shinePaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(size.width, size.height),
        [
          Colors.white.withOpacity(0.08),
          Colors.white.withOpacity(0.22),
          Colors.white.withOpacity(0.08),
        ],
        [0.0, 0.5, 1.0],
      );
    canvas.drawRect(Offset.zero & size, shinePaint);

    // ─── Dots pattern ──────────────────────────────────────────────────
    final dotPaint = Paint()..color = Colors.white.withOpacity(0.10);
    final cols = 6;
    for (int i = 0; i < cols; i++) {
      final x = (size.width / cols) * i + size.width / (cols * 2);
      canvas.drawCircle(Offset(x, size.height / 2), 18, dotPaint);
    }

    // ─── Bold "SCRATCH HERE" title ────────────────────────────────────
    final titleTp = TextPainter(
      text: const TextSpan(
        text: 'SCRATCH HERE',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.1,
          shadows: [
            Shadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 1)),
          ],
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    titleTp.layout(maxWidth: size.width - 16);
    final titleY = size.height * 0.16;
    titleTp.paint(
      canvas,
      Offset((size.width - titleTp.width) / 2, titleY),
    );

    // underline accent
    final underlinePaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final underlineY = titleY + titleTp.height + 6;
    canvas.drawLine(
      Offset(size.width / 2 - 16, underlineY),
      Offset(size.width / 2 + 16, underlineY),
      underlinePaint,
    );

    // ─── Coin icon + supporting text ──────────────────────────────────
    final centerY = size.height / 2 + 6;

    final coinPaint = Paint()..color = Colors.white.withOpacity(0.25);
    canvas.drawCircle(Offset(size.width / 2, centerY - 14), 14, coinPaint);
    final coinBorder = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawCircle(Offset(size.width / 2, centerY - 14), 14, coinBorder);

    final coinText = TextPainter(
      text: const TextSpan(
        text: '₹',
        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
      ),
      textDirection: TextDirection.ltr,
    );
    coinText.layout();
    coinText.paint(
      canvas,
      Offset(size.width / 2 - coinText.width / 2, centerY - 14 - coinText.height / 2),
    );

    // "to reveal reward" text
    final tp = TextPainter(
      text: TextSpan(
        text: 'to reveal reward',
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 10.5,
          fontWeight: FontWeight.w500,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: size.width);
    final tpY = centerY + 6;
    tp.paint(
      canvas,
      Offset((size.width - tp.width) / 2, tpY),
    );

    // ─── 👇 REQUIRED POINTS AT THE BOTTOM ──────────────────────────────
    final reqTp = TextPainter(
      text: TextSpan(
        text: 'Required: $requiredPoints pts',
        style: TextStyle(
          color: Colors.white.withOpacity(0.95),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          shadows: [
            Shadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 1)),
          ],
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    reqTp.layout(maxWidth: size.width - 16);
    // Place it below "to reveal reward" with some padding
    final reqY = tpY + tp.height + 8;
    reqTp.paint(
      canvas,
      Offset((size.width - reqTp.width) / 2, reqY),
    );

    // ─── Erase (scratch) with blend mode ──────────────────────────────
    if (points.isEmpty) return;

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Offset.zero & size, basePaint);

    final erasePaint = Paint()
      ..blendMode = BlendMode.clear
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 22, erasePaint);
      if (i > 0) {
        final path = Path()
          ..moveTo(points[i - 1].dx, points[i - 1].dy)
          ..lineTo(points[i].dx, points[i].dy);
        canvas.drawPath(
          path,
          erasePaint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 44
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round,
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ScratchPainter old) => old.points.length != points.length;
}