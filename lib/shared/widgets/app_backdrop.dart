import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFDFBFF), Color(0xFFF5F7FF), Color(0xFFF7FFFC)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
        ),

        const _MeshGradientLayer(),

        const _AuroraRibbon(),

        const _SurfaceGlow(),

        const _NoiseOverlay(),
      ],
    );
  }
}

class _MeshGradientLayer extends StatelessWidget {
  const _MeshGradientLayer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        _GlowOrb(
          size: 420,
          color: Color.fromARGB(120, 255, 120, 180),
          alignment: Alignment(-1.1, -0.9),
        ),
        _GlowOrb(
          size: 400,
          color: Color.fromARGB(120, 120, 170, 255),
          alignment: Alignment(1.0, -0.8),
        ),
        _GlowOrb(
          size: 360,
          color: Color.fromARGB(100, 120, 255, 220),
          alignment: Alignment(-0.9, 1.0),
        ),
        _GlowOrb(
          size: 320,
          color: Color.fromARGB(90, 255, 210, 120),
          alignment: Alignment(1.1, 0.9),
        ),
        _GlowOrb(
          size: 260,
          color: Color.fromARGB(70, 255, 255, 255),
          alignment: Alignment(0.0, 0.0),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.size,
    required this.color,
    required this.alignment,
  });

  final double size;
  final Color color;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [color, color.withValues(alpha: 0)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuroraRibbon extends StatelessWidget {
  const _AuroraRibbon();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.28,
        child: Transform.rotate(
          angle: -0.4,
          child: Center(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(
                width: MediaQuery.of(context).size.width * 1.5,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(0, 255, 255, 255),
                      Color.fromARGB(90, 255, 120, 180),
                      Color.fromARGB(100, 120, 170, 255),
                      Color.fromARGB(90, 120, 255, 220),
                      Color.fromARGB(0, 255, 255, 255),
                    ],
                    stops: [0.0, 0.2, 0.5, 0.8, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SurfaceGlow extends StatelessWidget {
  const _SurfaceGlow();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.30),
              Colors.white.withValues(alpha: 0.10),
              Colors.white.withValues(alpha: 0.18),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoiseOverlay extends StatelessWidget {
  const _NoiseOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.02,
        child: CustomPaint(painter: _NoisePainter()),
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(8);
    final paint = Paint();

    for (int i = 0; i < 2500; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;

      paint.color = Colors.black.withValues(alpha: random.nextDouble() * 0.05);

      canvas.drawRect(Rect.fromLTWH(dx, dy, 1, 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
