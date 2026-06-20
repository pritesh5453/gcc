import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gcc/Models_nServices/Coupons/coupons_model.dart';
import 'package:gcc/Models_nServices/Coupons/coupons_svc.dart';
import 'package:gcc/Navbar/navbar.dart';
import 'package:gcc/prefs/PreferencesKey.dart';
import 'package:gcc/prefs/app_preference.dart';

// ─── Main Screen ─────────────────────────────────────────────────────────────
class ScratchCardScreen extends StatefulWidget {
  const ScratchCardScreen({super.key});

  @override
  State<ScratchCardScreen> createState() => _ScratchCardScreenState();
}

class _ScratchCardScreenState extends State<ScratchCardScreen> {
  final CouponService _couponService = CouponService();
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;
  int _rewardPoints = 0;
  List<CouponData> _coupons = [];

  // Store claimed reward amounts per coupon ID (for display after scratching)
  final Map<int, int> _claimedRewards = {};

  @override
  void initState() {
    super.initState();
    _fetchCoupons(showLoading: true);
  }

  // ─── Fetch coupons (with optional loading indicator) ────────────────────
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
        setState(() {
          _rewardPoints = response.rewardPoints;
          _coupons = response.data;
          if (showLoading) _isLoading = false;
          _isRefreshing = false;
        });
      } else {
        setState(() {
          _errorMessage =
              response?.status == false
                  ? 'Failed to load coupons'
                  : 'No coupons available';
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

  // ─── Refresh callback for RefreshIndicator ──────────────────────────────
  Future<void> _onRefresh() async {
    await _fetchCoupons(showLoading: false);
  }

  // ─── Called when a coupon is successfully scratched ──────────────────────
  void _onCouponClaimed(int couponId, int rewardAmountWon, int newPoints) {
    setState(() {
      _claimedRewards[couponId] = rewardAmountWon;
      _rewardPoints = newPoints;
      // Mark the coupon as claimed locally (isEligible = false)
      final index = _coupons.indexWhere((c) => c.id == couponId);
      if (index != -1) {
        _coupons[index] = CouponData(
          id: _coupons[index].id,
          couponName: _coupons[index].couponName,
          couponImage: _coupons[index].couponImage,
          requiredRewardPoints: _coupons[index].requiredRewardPoints,
          minRewardAmount: _coupons[index].minRewardAmount,
          maxRewardAmount: _coupons[index].maxRewardAmount,
          isEligible: false,
          isScratch: _coupons[index].isScratch,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage != null
                      ? _buildErrorWidget()
                      : _coupons.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                        onRefresh: _onRefresh,
                        color: const Color(0xFF1B6B2F),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                ),
                                child: _buildBalanceCard(),
                              ),
                              const SizedBox(height: 18),
                              _buildSectionHeader(),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  'Finger se scratch karo to reveal karo',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.white54,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildGrid(),
                              const SizedBox(height: 20),
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

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      color: const Color(0xFF1B6B2F),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🎯', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                const Text(
                  'No coupons available',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  'Check back later for new offers',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _fetchCoupons(showLoading: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B6B2F),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Refresh'),
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
      color: const Color(0xFF1B6B2F),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(_errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _fetchCoupons(showLoading: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B6B2F),
                    ),
                    child: const Text('Retry'),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              children: [
                Text(
                  'Scratch Cards',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Scratch to reveal your rewards',
                  style: TextStyle(fontSize: 11, color: Colors.black54),
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
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        color: const Color(0xFF1B6B2F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your balance',
                      style: TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _rewardPoints.toString(),
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.recycling,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Points available',
                      style: TextStyle(fontSize: 13, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 80,
                height: 70,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Text('🎁', style: TextStyle(fontSize: 52)),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 8,
                      child: Text('🪙', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 9),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🌿', style: TextStyle(fontSize: 13)),
                SizedBox(width: 6),
                Text(
                  'Earn more by completing tasks and challenges',
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Your scratch cards',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1B6B2F),
            ),
          ),
          Text(
            '${_coupons.length} available',
            style: const TextStyle(fontSize: 11, color: Color(0xFF1B6B2F)),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = (constraints.maxWidth - 12) / 2;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                _coupons
                    .map(
                      (coupon) => SizedBox(
                        width: cardWidth,
                        child: _ScratchCard(
                          coupon: coupon,
                          userPoints: _rewardPoints,
                          onClaimed: _onCouponClaimed,
                          claimedReward: _claimedRewards[coupon.id],
                        ),
                      ),
                    )
                    .toList(),
          );
        },
      ),
    );
  }
}

// ─── Scratch Card Widget (unchanged) ──────────────────────────────────────
class _ScratchCard extends StatefulWidget {
  final CouponData coupon;
  final int userPoints;
  final void Function(int couponId, int rewardAmount, int newPoints) onClaimed;
  final int? claimedReward;

  const _ScratchCard({
    required this.coupon,
    required this.userPoints,
    required this.onClaimed,
    this.claimedReward,
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
    _fadeAnim = Tween<double>(begin: 1, end: 0).animate(_fadeCtrl);

    if (!widget.coupon.isEligible || widget.claimedReward != null) {
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
      SnackBar(content: Text(msg), backgroundColor: const Color(0xFF1B6B2F)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.coupon;
    final bool hasEnoughPoints = widget.userPoints >= c.requiredRewardPoints;
    final bool isEligible = c.isEligible && hasEnoughPoints;

    String rewardDisplay;
    String rewardLabel;
    String icon;

    if (widget.claimedReward != null) {
      rewardDisplay = '₹${widget.claimedReward}';
      rewardLabel = 'Won!';
      icon = '🎉';
    } else if (isEligible) {
      rewardDisplay = '₹${c.minRewardAmount} - ₹${c.maxRewardAmount}';
      rewardLabel = 'Scratch to win';
      icon = '🎁';
    } else {
      if (!hasEnoughPoints) {
        rewardDisplay = '—';
        rewardLabel = 'Not enough points';
        icon = '🔒';
      } else {
        rewardDisplay = '—';
        rewardLabel = 'Already Claimed';
        icon = '✅';
      }
    }

    final bgColor = isEligible ? const Color(0xFFE8F5E9) : Colors.grey[200]!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: SizedBox(
              height: 140,
              child: Stack(
                children: [
                  Container(
                    color: bgColor,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(icon, style: const TextStyle(fontSize: 36)),
                          const SizedBox(height: 4),
                          Text(
                            rewardDisplay,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1B6B2F),
                            ),
                          ),
                          Text(
                            rewardLabel,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isEligible && widget.claimedReward == null && !_revealed)
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: _ScratchLayer(
                        scratchColor: _getScratchColor(c.id),
                        onRevealed: _onScratchComplete,
                      ),
                    ),
                  if (!isEligible)
                    Container(
                      color: Colors.black.withOpacity(0.4),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              hasEnoughPoints
                                  ? 'Already Claimed'
                                  : 'Not enough points',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            if (!hasEnoughPoints)
                              Text(
                                'Need ${c.requiredRewardPoints} pts',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  if (_isClaiming)
                    Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _revealed ? 28 : 0,
            color: const Color(0xFFE8F5E9),
            child:
                _revealed
                    ? const Center(
                      child: Text(
                        '🎉  Reward revealed!',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3),
                Text(
                  c.couponName.length > 20
                      ? '${c.couponName.substring(0, 20)}...'
                      : c.couponName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1B6B2F),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 9,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${c.requiredRewardPoints} points',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF1B6B2F),
                        fontWeight: FontWeight.w500,
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

  Color _getScratchColor(int id) {
    final colors = [
      const Color(0xFFB8860B),
      const Color(0xFF388E3C),
      const Color(0xFF5E35B1),
      const Color(0xFF1565C0),
      const Color(0xFFC2185B),
      const Color(0xFF33691E),
      const Color(0xFFE65100),
      const Color(0xFF00838F),
      const Color(0xFF6A1B9A),
      const Color(0xFFF57F17),
    ];
    return colors[id % colors.length];
  }
}

// ─── Scratch Layer (CustomPainter) – unchanged ────────────────────────────
class _ScratchLayer extends StatefulWidget {
  final Color scratchColor;
  final VoidCallback onRevealed;

  const _ScratchLayer({required this.scratchColor, required this.onRevealed});

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
              scratchColor: widget.scratchColor,
            ),
          );
        },
      ),
    );
  }
}

class _ScratchPainter extends CustomPainter {
  final List<Offset> points;
  final Color scratchColor;

  _ScratchPainter({required this.points, required this.scratchColor});

  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()..color = scratchColor;
    canvas.drawRect(Offset.zero & size, basePaint);

    final dotPaint = Paint()..color = Colors.white.withOpacity(0.15);
    final cols = 6;
    for (int i = 0; i < cols; i++) {
      final x = (size.width / cols) * i + size.width / (cols * 2);
      canvas.drawCircle(Offset(x, size.height / 2), 18, dotPaint);
    }

    final tp = TextPainter(
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Scratch here\n',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          TextSpan(
            text: 'to reveal reward',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: size.width);
    tp.paint(
      canvas,
      Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2),
    );

    if (points.isEmpty) return;

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Offset.zero & size, basePaint);

    final erasePaint =
        Paint()
          ..blendMode = BlendMode.clear
          ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 22, erasePaint);
      if (i > 0) {
        final path =
            Path()
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
