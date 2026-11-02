import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/breathing_pattern.dart';

class BreathingOrb extends StatefulWidget {
  final BreathPhase currentPhase;
  final double animationProgress; // 0.0 to 1.0 within current phase
  final int secondsRemaining;

  const BreathingOrb({
    super.key,
    required this.currentPhase,
    required this.animationProgress,
    required this.secondsRemaining,
  });

  @override
  State<BreathingOrb> createState() => _BreathingOrbState();
}

class _BreathingOrbState extends State<BreathingOrb> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine target orb scale based on breathing phase
    double orbScale;
    switch (widget.currentPhase.type) {
      case BreathPhaseType.inhale:
        // Expanding from 1.0 to 1.5
        orbScale = 1.0 + (0.5 * widget.animationProgress);
        break;
      case BreathPhaseType.holdIn:
        // Full expansion with gentle breathing vibration
        orbScale = 1.5;
        break;
      case BreathPhaseType.exhale:
        // Contracting from 1.5 back down to 1.0
        orbScale = 1.5 - (0.5 * widget.animationProgress);
        break;
      case BreathPhaseType.holdOut:
        // Minimum scale
        orbScale = 1.0;
        break;
    }

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(320, 320),
          painter: OrbGlowPainter(
            scale: orbScale,
            pulseValue: _pulseController.value,
            startColor: widget.currentPhase.startColor,
            endColor: widget.currentPhase.endColor,
          ),
          child: SizedBox(
            width: 320,
            height: 320,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.currentPhase.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.secondsRemaining}s',
                  style: TextStyle(
                    color: widget.currentPhase.startColor,
                    fontSize: 48,
                    fontWeight: FontWeight.w200,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OrbGlowPainter extends CustomPainter {
  final double scale;
  final double pulseValue;
  final Color startColor;
  final Color endColor;

  OrbGlowPainter({
    required this.scale,
    required this.pulseValue,
    required this.startColor,
    required this.endColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = 85.0 * scale;

    // Outer subtle atmospheric aura
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          startColor.withValues(alpha: 0.28),
          endColor.withValues(alpha: 0.12),
          Colors.transparent,
        ],
        stops: const [0.2, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: baseRadius * 1.55));
    canvas.drawCircle(center, baseRadius * 1.55, auraPaint);

    // Dynamic rotating dashed orbit ring
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const dashCount = 36;
    final ringRadius = baseRadius * 1.28;
    for (int i = 0; i < dashCount; i++) {
      if (i % 2 == 0) {
        final startAngle = (i / dashCount) * 2 * math.pi + (pulseValue * 2 * math.pi);
        const sweepAngle = (1 / dashCount) * math.pi;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: ringRadius),
          startAngle,
          sweepAngle,
          false,
          ringPaint,
        );
      }
    }

    // Inner glowing core orb
    final coreGradient = RadialGradient(
      colors: [
        startColor.withValues(alpha: 0.85),
        endColor.withValues(alpha: 0.45),
        Colors.black.withValues(alpha: 0.90),
      ],
      stops: const [0.0, 0.6, 1.0],
    );

    final corePaint = Paint()
      ..shader = coreGradient.createShader(Rect.fromCircle(center: center, radius: baseRadius));
    canvas.drawCircle(center, baseRadius, corePaint);

    // Sharp outer rim contour
    final rimPaint = Paint()
      ..color = startColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, baseRadius, rimPaint);
  }

  @override
  bool shouldRepaint(covariant OrbGlowPainter oldDelegate) {
    return oldDelegate.scale != scale ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.startColor != startColor;
  }
}
