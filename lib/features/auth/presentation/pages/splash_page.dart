import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sportify/app/router/app_router.dart';
import 'package:sportify/core/di/injection_container.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/auth/presentation/bloc/auth_bloc.dart';

/// Premium animated startup splash screen for Sportify.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  bool _minTimeElapsed = false;
  bool _authResolved = false;
  bool _navigated = false;
  Timer? _minTimer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2200))..forward();
    _logoScale = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack)),
    );
    _logoFade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.4, curve: Curves.easeOut));
    _textFade = CurvedAnimation(parent: _ctrl, curve: const Interval(0.3, 0.75, curve: Curves.easeOut));
    _textSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.3, 0.75, curve: Curves.easeOutCubic)),
    );

    _minTimer = Timer(const Duration(milliseconds: 2100), () {
      _minTimeElapsed = true;
      _tryNavigate();
    });
  }

  void _tryNavigate() {
    if (!mounted || _navigated || !_minTimeElapsed || !_authResolved) return;
    _navigated = true;
    context.go(AppRoutes.home);
  }

  @override
  void dispose() {
    _minTimer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bgTop = Color(0xFF050A10);
    const bgBottom = Color(0xFF0A141F);
    const green = AppColors.green2;

    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(const AuthStarted()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated || state is AuthUnauthenticated) {
            _authResolved = true;
            _tryNavigate();
          }
        },
        child: Scaffold(
          backgroundColor: bgTop,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // ── 1. Deep Stadium Gradient + Tactical Pitch Watermark ──
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [bgTop, bgBottom, bgTop], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
              ),
              CustomPaint(painter: _TacticalPitchPainter()),

              // ── 2. Ambient Stadium Floodlight Glows ──
              Positioned(
                top: -90, left: -60,
                child: Container(
                  width: 280, height: 280,
                  decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [green.withValues(alpha: 0.18), Colors.transparent])),
                ),
              ),
              Positioned(
                bottom: -110, right: -70,
                child: Container(
                  width: 300, height: 300,
                  decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [const Color(0xFF38BDF8).withValues(alpha: 0.12), Colors.transparent])),
                ),
              ),

              // ── 3. Center Animated Crest + Brand Lockup ──
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
                  child: Column(
                    children: [
                      const Spacer(flex: 3),
                      FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: AnimatedBuilder(animation: _ctrl, builder: (_, __) => _SportifyStadiumCrest(progress: _ctrl.value)),
                        ),
                      ),
                      const SizedBox(height: 28),
                      FadeTransition(
                        opacity: _textFade,
                        child: SlideTransition(
                          position: _textSlide,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(color: green.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: green.withValues(alpha: 0.35))),
                                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                                  Icon(Icons.auto_awesome_rounded, color: green, size: 12),
                                  SizedBox(width: 6),
                                  Text('AI-POWERED SCOUTING NETWORK', style: TextStyle(color: green, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
                                ]),
                              ),
                              const SizedBox(height: 14),
                              const Text('SPORTIFY', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 4.5, height: 1.0)),
                              const SizedBox(height: 10),
                              const Text('Discover, analyze & connect global football talent', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 13.5, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(flex: 3),

                      // ── 4. Animated Scouting Progress Bar ──
                      AnimatedBuilder(
                        animation: _ctrl,
                        builder: (_, __) {
                          final pct = (_ctrl.value * 100).round().clamp(0, 100);
                          return Column(children: [
                            SizedBox(
                              width: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(value: _ctrl.value, minHeight: 5, backgroundColor: const Color(0xFF152230), valueColor: const AlwaysStoppedAnimation<Color>(green)),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text('LOADING SCOUTING ENGINE · $pct%', style: const TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                          ]);
                        },
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

class _SportifyStadiumCrest extends StatelessWidget {
  const _SportifyStadiumCrest({required this.progress});
  final double progress;

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;
    final pulse = 0.5 + 0.5 * math.sin(progress * math.pi * 2);

    return SizedBox(
      width: 132,
      height: 132,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 128 + (pulse * 6),
            height: 128 + (pulse * 6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: green.withValues(alpha: 0.18 + pulse * 0.12), width: 1.5),
            ),
          ),
          Container(
            width: 108,
            height: 108,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: const LinearGradient(
                colors: [Color(0xFF132636), Color(0xFF0B1622)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: green.withValues(alpha: 0.55), width: 1.8),
              boxShadow: [
                BoxShadow(color: green.withValues(alpha: 0.28), blurRadius: 28, spreadRadius: 2),
              ],
            ),
            child: CustomPaint(painter: _StadiumLogoPainter()),
          ),
        ],
      ),
    );
  }
}

class _StadiumLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    const green = AppColors.green2, lime = Color(0xFFA3E635);

    // Stadium bowl tiers (matching sportifyplus.de stadium crest)
    for (var i = 0; i < 3; i++) {
      final w = size.width * (0.64 - i * 0.11);
      final h = size.height * (0.28 - i * 0.04);
      final rect = Rect.fromCenter(center: Offset(cx, cy + 4 + i * 5), width: w, height: h);
      final paint = Paint()
        ..color = i.isEven ? green : lime
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.2
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(rect, 0.15, math.pi - 0.3, false, paint);
    }

    // Upper stadium crown arch + floodlight star
    final crownRect = Rect.fromCenter(center: Offset(cx, cy - 2), width: size.width * 0.62, height: size.height * 0.44);
    final crownPaint = Paint()
      ..color = green.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(crownRect, math.pi + 0.25, math.pi - 0.5, false, crownPaint);

    // Center football/talent core dot
    canvas.drawCircle(Offset(cx, cy - 6), 5.5, Paint()..color = lime);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TacticalPitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width * 0.32, linePaint);
    canvas.drawCircle(center, size.width * 0.52, linePaint);
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
