import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/breathing_pattern.dart';

class SacredGeometryOrb extends StatefulWidget {
  final BreathPhase currentPhase;
  final double animationProgress; // 0.0 to 1.0 within phase
  final int secondsRemaining;

  const SacredGeometryOrb({
    super.key,
    required this.currentPhase,
    required this.animationProgress,
    required this.secondsRemaining,
  });

  @override
  State<SacredGeometryOrb> createState() => _SacredGeometryOrbState();
}

class _SacredGeometryOrbState extends State<SacredGeometryOrb> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scale;
    switch (widget.currentPhase.type) {
      case BreathPhaseType.inhale:
        scale = 1.0 + (0.55 * widget.animationProgress);
        break;
      case BreathPhaseType.holdIn:
        scale = 1.55;
        break;
      case BreathPhaseType.exhale:
        scale = 1.55 - (0.55 * widget.animationProgress);
        break;
      case BreathPhaseType.holdOut:
        scale = 1.0;
        break;
    }

    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(340, 340),
          painter: SacredMandalaPainter(
            scale: scale,
            rotationAngle: _rotationController.value * 2 * math.pi,
            startColor: widget.currentPhase.startColor,
            endColor: widget.currentPhase.endColor,
            nostrilSide: widget.currentPhase.nostrilSide,
          ),
          child: SizedBox(
            width: 340,
            height: 340,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sanskrit indicator badge
                if (widget.currentPhase.sanskritLabel.isNotEmpty) ...[
                  Text(
                    widget.currentPhase.sanskritLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: widget.currentPhase.startColor.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],

                // Main English Label
                Text(
                  widget.currentPhase.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),

                // Seconds remaining
                Text(
                  '${widget.secondsRemaining}s',
                  style: TextStyle(
                    color: widget.currentPhase.startColor,
                    fontSize: 46,
                    fontWeight: FontWeight.w200,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),

                // Nostril directional cue badge
                if (widget.currentPhase.nostrilSide != NostrilSide.both) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: widget.currentPhase.startColor.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.currentPhase.nostrilSide == NostrilSide.left
                              ? Icons.nightlight_round
                              : Icons.wb_sunny_rounded,
                          color: widget.currentPhase.startColor,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.currentPhase.nostrilSide == NostrilSide.left
                              ? 'Ida (Moon / Left)'
                              : 'Pingala (Sun / Right)',
                          style: TextStyle(
                            color: widget.currentPhase.startColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class SacredMandalaPainter extends CustomPainter {
  final double scale;
  final double rotationAngle;
  final Color startColor;
  final Color endColor;
  final NostrilSide nostrilSide;

  SacredMandalaPainter({
    required this.scale,
    required this.rotationAngle,
    required this.startColor,
    required this.endColor,
    required this.nostrilSide,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = 82.0 * scale;

    // 1. Outer Bioluminescent Aura
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          startColor.withValues(alpha: 0.32),
          endColor.withValues(alpha: 0.12),
          Colors.transparent,
        ],
        stops: const [0.2, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: baseRadius * 1.6));
    canvas.drawCircle(center, baseRadius * 1.6, auraPaint);

    // 2. Sacred Geometry: 8-Petal Lotus Pattern
    final lotusPaint = Paint()
      ..color = startColor.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    const petals = 8;
    for (int i = 0; i < petals; i++) {
      final angle = rotationAngle + (i * 2 * math.pi / petals);
      final petalCenter = Offset(
        center.dx + (baseRadius * 0.45) * math.cos(angle),
        center.dy + (baseRadius * 0.45) * math.sin(angle),
      );
      canvas.drawCircle(petalCenter, baseRadius * 0.55, lotusPaint);
    }

    // 3. Sri Yantra Intersecting Triangles
    final yantraPaint = Paint()
      ..color = endColor.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    _drawEquilateralTriangle(canvas, center, baseRadius * 1.15, rotationAngle * 0.5, yantraPaint);
    _drawEquilateralTriangle(canvas, center, baseRadius * 1.15, rotationAngle * 0.5 + math.pi, yantraPaint);

    // 4. Central Prana Core
    final coreGradient = RadialGradient(
      colors: [
        startColor.withValues(alpha: 0.85),
        endColor.withValues(alpha: 0.45),
        Colors.black.withValues(alpha: 0.95),
      ],
      stops: const [0.0, 0.6, 1.0],
    );

    final corePaint = Paint()
      ..shader = coreGradient.createShader(Rect.fromCircle(center: center, radius: baseRadius));
    canvas.drawCircle(center, baseRadius, corePaint);

    // 5. Golden Rim Contour
    final rimPaint = Paint()
      ..color = startColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, baseRadius, rimPaint);
  }

  void _drawEquilateralTriangle(Canvas canvas, Offset center, double radius, double rotation, Paint paint) {
    final path = Path();
    for (int i = 0; i < 3; i++) {
      final angle = rotation + (i * 2 * math.pi / 3);
      final point = Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SacredMandalaPainter oldDelegate) {
    return oldDelegate.scale != scale ||
        oldDelegate.rotationAngle != rotationAngle ||
        oldDelegate.startColor != startColor ||
        oldDelegate.nostrilSide != nostrilSide;
  }
}
