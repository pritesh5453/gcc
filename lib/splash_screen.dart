import 'package:flutter/material.dart';
import 'package:gcc/Navbar/navbar.dart';
import 'package:gcc/Onboarding/onboarding.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  const SplashScreen({super.key, required this.isLoggedIn});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _leafController1;
  late AnimationController _leafController2;
  late AnimationController _leafController3;
  late AnimationController _fadeController;
  late AnimationController _sceneController;

  late Animation<double> _progressAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _sceneSlideAnimation;

  late Animation<double> _leaf1X;
  late Animation<double> _leaf1Y;
  late Animation<double> _leaf1Rotate;
  late Animation<double> _leaf1Opacity;

  late Animation<double> _leaf2X;
  late Animation<double> _leaf2Y;
  late Animation<double> _leaf2Rotate;
  late Animation<double> _leaf2Opacity;

  late Animation<double> _leaf3X;
  late Animation<double> _leaf3Y;
  late Animation<double> _leaf3Rotate;
  late Animation<double> _leaf3Opacity;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _sceneController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _sceneSlideAnimation = Tween<double>(begin: 60, end: 0).animate(
      CurvedAnimation(parent: _sceneController, curve: Curves.easeOutCubic),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Leaf 1
    _leafController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
    _leaf1X = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.72, end: 0.55),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.55, end: 0.72),
        weight: 50,
      ),
    ]).animate(_leafController1);
    _leaf1Y = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.12, end: 0.28),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.28, end: 0.12),
        weight: 50,
      ),
    ]).animate(_leafController1);
    _leaf1Rotate = Tween<double>(begin: -0.3, end: 0.5).animate(
      CurvedAnimation(parent: _leafController1, curve: Curves.easeInOut),
    );
    _leaf1Opacity = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.0), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.0), weight: 80),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 10),
    ]).animate(_leafController1);

    // Leaf 2
    _leafController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();
    _leaf2X = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.1, end: 0.25),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.25, end: 0.1),
        weight: 50,
      ),
    ]).animate(_leafController2);
    _leaf2Y = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.45, end: 0.6),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.6, end: 0.45),
        weight: 50,
      ),
    ]).animate(_leafController2);
    _leaf2Rotate = Tween<double>(begin: 0.8, end: -0.4).animate(
      CurvedAnimation(parent: _leafController2, curve: Curves.easeInOut),
    );
    _leaf2Opacity = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.9), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 0.9), weight: 80),
      TweenSequenceItem(tween: Tween<double>(begin: 0.9, end: 0.0), weight: 10),
    ]).animate(_leafController2);

    // Leaf 3
    _leafController3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat();
    _leaf3X = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.15, end: 0.32),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.32, end: 0.15),
        weight: 50,
      ),
    ]).animate(_leafController3);
    _leaf3Y = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.08, end: 0.22),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.22, end: 0.08),
        weight: 50,
      ),
    ]).animate(_leafController3);
    _leaf3Rotate = Tween<double>(begin: -0.6, end: 0.6).animate(
      CurvedAnimation(parent: _leafController3, curve: Curves.easeInOut),
    );
    _leaf3Opacity = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.85),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 0.85),
        weight: 80,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.85, end: 0.0),
        weight: 10,
      ),
    ]).animate(_leafController3);

    _fadeController.forward();
    _sceneController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _progressController.forward();
    });

    // ✅ Progress complete hone pe navigate karo
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder:
                (_, __, ___) =>
                    widget.isLoggedIn
                        ? const MainScreen()
                        : const WelcomeScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _leafController1.dispose();
    _leafController2.dispose();
    _leafController3.dispose();
    _fadeController.dispose();
    _sceneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _fadeController,
          _progressController,
          _leafController1,
          _leafController2,
          _leafController3,
          _sceneController,
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFEBF5EB),
                  Color(0xFFD4EDDA),
                  Color(0xFFA8D5A2),
                  Color(0xFF4CAF50),
                  Color(0xFF2E7D32),
                ],
                stops: [0.0, 0.3, 0.55, 0.75, 1.0],
              ),
            ),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Stack(
                children: [
                  // Floating Leaf 1
                  Positioned(
                    left: _leaf1X.value * size.width,
                    top: _leaf1Y.value * size.height,
                    child: Opacity(
                      opacity: _leaf1Opacity.value,
                      child: Transform.rotate(
                        angle: _leaf1Rotate.value,
                        child: const _LeafIcon(
                          size: 28,
                          color: Color(0xFF43A047),
                        ),
                      ),
                    ),
                  ),

                  // Floating Leaf 2
                  Positioned(
                    left: _leaf2X.value * size.width,
                    top: _leaf2Y.value * size.height,
                    child: Opacity(
                      opacity: _leaf2Opacity.value,
                      child: Transform.rotate(
                        angle: _leaf2Rotate.value,
                        child: const _LeafIcon(
                          size: 22,
                          color: Color(0xFF388E3C),
                        ),
                      ),
                    ),
                  ),

                  // Floating Leaf 3
                  Positioned(
                    left: _leaf3X.value * size.width,
                    top: _leaf3Y.value * size.height,
                    child: Opacity(
                      opacity: _leaf3Opacity.value,
                      child: Transform.rotate(
                        angle: _leaf3Rotate.value,
                        child: const _LeafIcon(
                          size: 18,
                          color: Color(0xFF66BB6A),
                        ),
                      ),
                    ),
                  ),

                  // Logo + Tagline
                  Positioned(
                    top: size.height * 0.30,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFF43A047),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Center(
                                child: _LeafIcon(size: 30, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'GCC',
                              style: TextStyle(
                                fontSize: 58,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1B5E20),
                                letterSpacing: 2,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Grow.', style: _taglineStyle),
                            SizedBox(width: 6),
                            _DotDivider(),
                            SizedBox(width: 6),
                            Text('Contribute.', style: _taglineStyle),
                            SizedBox(width: 6),
                            _DotDivider(),
                            SizedBox(width: 6),
                            Text(
                              'Certify a Greener Future.',
                              style: _taglineStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Nature Scene
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: size.height * 0.52,
                    child: Transform.translate(
                      offset: Offset(0, _sceneSlideAnimation.value),
                      child: const _NatureScene(),
                    ),
                  ),

                  // Progress bar + Loading text
                  Positioned(
                    bottom: 60,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: _LeafIcon(size: 20, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Growing Impact...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: _progressAnimation.value,
                                  child: Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF81C784),
                                          Color(0xFF43A047),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF81C784,
                                          ).withOpacity(0.7),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Tagline TextStyle ──
const TextStyle _taglineStyle = TextStyle(
  fontSize: 13.5,
  color: Color(0xFF4E6B4E),
  fontWeight: FontWeight.w400,
  letterSpacing: 0.2,
);

// ── Dot Divider ──
class _DotDivider extends StatelessWidget {
  const _DotDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: Color(0xFF4E6B4E),
        shape: BoxShape.circle,
      ),
    );
  }
}

// ── Leaf Icon ──
class _LeafIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _LeafIcon({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _LeafPainter(color: color),
    );
  }
}

class _LeafPainter extends CustomPainter {
  final Color color;
  const _LeafPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;
    final path = Path();
    final w = size.width;
    final h = size.height;

    path.moveTo(w * 0.5, h * 0.05);
    path.cubicTo(w * 0.95, h * 0.05, w * 0.95, h * 0.75, w * 0.5, h * 0.95);
    path.cubicTo(w * 0.05, h * 0.75, w * 0.05, h * 0.05, w * 0.5, h * 0.05);
    path.close();

    canvas.drawPath(path, paint);

    final stemPaint =
        Paint()
          ..color = color.withOpacity(0.6)
          ..strokeWidth = size.width * 0.08
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * 0.5, h * 0.95),
      Offset(w * 0.5, h * 0.55),
      stemPaint,
    );
  }

  @override
  bool shouldRepaint(_LeafPainter old) => old.color != color;
}

// ── Nature Scene ──
class _NatureScene extends StatelessWidget {
  const _NatureScene();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _NatureScenePainter(), child: Container());
  }
}

class _NatureScenePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sky
    final skyPaint =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFB3E5FC), Color(0xFFE8F5E9)],
          ).createShader(Rect.fromLTWH(0, 0, w, h * 0.55));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.55), skyPaint);

    // Far mountains
    final mtnPaint = Paint()..color = const Color(0xFF81C784);
    final mtnPath = Path();
    mtnPath.moveTo(0, h * 0.48);
    mtnPath.lineTo(w * 0.25, h * 0.18);
    mtnPath.lineTo(w * 0.5, h * 0.35);
    mtnPath.lineTo(w * 0.7, h * 0.12);
    mtnPath.lineTo(w, h * 0.38);
    mtnPath.lineTo(w, h * 0.55);
    mtnPath.lineTo(0, h * 0.55);
    mtnPath.close();
    canvas.drawPath(mtnPath, mtnPaint);

    // Near hills
    final hillPaint = Paint()..color = const Color(0xFF4CAF50);
    final hillPath = Path();
    hillPath.moveTo(0, h * 0.62);
    hillPath.cubicTo(w * 0.15, h * 0.45, w * 0.35, h * 0.48, w * 0.5, h * 0.58);
    hillPath.cubicTo(w * 0.65, h * 0.68, w * 0.82, h * 0.5, w, h * 0.55);
    hillPath.lineTo(w, h);
    hillPath.lineTo(0, h);
    hillPath.close();
    canvas.drawPath(hillPath, hillPaint);

    // Ground
    final groundPaint = Paint()..color = const Color(0xFF2E7D32);
    final groundPath = Path();
    groundPath.moveTo(0, h * 0.75);
    groundPath.cubicTo(w * 0.3, h * 0.65, w * 0.7, h * 0.7, w, h * 0.72);
    groundPath.lineTo(w, h);
    groundPath.lineTo(0, h);
    groundPath.close();
    canvas.drawPath(groundPath, groundPaint);

    // Trees
    _drawTree(canvas, w * 0.78, h * 0.38, 1.8);
    _drawTree(canvas, w * 0.12, h * 0.62, 1.0);
    _drawTree(canvas, w * 0.32, h * 0.58, 0.85);
    _drawTree(canvas, w * 0.55, h * 0.65, 0.75);
    _drawTree(canvas, w * 0.88, h * 0.68, 0.9);
    _drawTree(canvas, w * 0.22, h * 0.7, 0.65);
    _drawTree(canvas, w * 0.68, h * 0.58, 0.7);

    // Birds
    _drawBird(canvas, w * 0.42, h * 0.28);
    _drawBird(canvas, w * 0.52, h * 0.22);
    _drawBird(canvas, w * 0.58, h * 0.31);
  }

  void _drawTree(Canvas canvas, double x, double y, double scale) {
    final trunkPaint = Paint()..color = const Color(0xFF5D4037);
    final foliagePaint = Paint()..color = const Color(0xFF388E3C);
    final foliageHighlight = Paint()..color = const Color(0xFF66BB6A);

    final trunkW = 8.0 * scale;
    final trunkH = 28.0 * scale;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x - trunkW / 2, y - trunkH, trunkW, trunkH),
        Radius.circular(3 * scale),
      ),
      trunkPaint,
    );

    canvas.drawCircle(
      Offset(x, y - trunkH - 10 * scale),
      28 * scale,
      foliagePaint,
    );
    canvas.drawCircle(
      Offset(x - 12 * scale, y - trunkH - 2 * scale),
      22 * scale,
      foliagePaint,
    );
    canvas.drawCircle(
      Offset(x + 12 * scale, y - trunkH - 2 * scale),
      22 * scale,
      foliagePaint,
    );
    canvas.drawCircle(
      Offset(x, y - trunkH - 18 * scale),
      20 * scale,
      foliageHighlight,
    );
  }

  void _drawBird(Canvas canvas, double x, double y) {
    final paint =
        Paint()
          ..color = const Color(0xFF0288D1)
          ..strokeWidth = 1.8
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(x - 10, y);
    path.cubicTo(x - 6, y - 5, x - 2, y - 5, x, y);
    path.cubicTo(x + 2, y - 5, x + 6, y - 5, x + 10, y);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_NatureScenePainter old) => false;
}
