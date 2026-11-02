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
                // சித்தர் குறிப்பு (Siddha Note)
                if (widget.currentPhase.siddhaNote.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      widget.currentPhase.siddhaNote,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.currentPhase.startColor.withValues(alpha: 0.85),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],

                // முதன்மை தமிழ் பெயர் (Primary Tamil Label)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.currentPhase.labelTamil,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),

                // துணை ஆங்கில பெயர் (Secondary English Label)
                Text(
                  widget.currentPhase.labelEnglish,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),

                // வினாடிகள் (Seconds Remaining)
                Text(
                  '${widget.secondsRemaining}வி',
                  style: TextStyle(
                    color: widget.currentPhase.startColor,
                    fontSize: 44,
                    fontWeight: FontWeight.w200,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),

                // இடைகலை / பிங்கலை குறிப்பான் (Nostril cue in Tamil)
                if (widget.currentPhase.nostrilSide != NostrilSide.both) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.75),
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
                        const SizedBox(width: 5),
                        Text(
                          widget.currentPhase.nostrilSide == NostrilSide.left
                              ? 'இடைகலை (சந்திர கலை)'
                              : 'பிங்கலை (சூரிய கலை)',
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

    // 1. அவுரா ஒளி வட்டம் (Outer Bioluminescent Aura)
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

    // 2. அஷ்டதள தாமரை இதழ்கள் (8-Petal Sacred Lotus)
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

    // 3. ஸ்ரீ சக்கர முக்கோணங்கள் (Sri Yantra Triangles)
    final yantraPaint = Paint()
      ..color = endColor.withValues(alpha: 0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    _drawEquilateralTriangle(canvas, center, baseRadius * 1.15, rotationAngle * 0.5, yantraPaint);
    _drawEquilateralTriangle(canvas, center, baseRadius * 1.15, rotationAngle * 0.5 + math.pi, yantraPaint);

    // 4. உள் பிராண மையம் (Core Prana Sphere)
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

    // 5. பொன் விளிம்பு வட்டம் (Golden Rim)
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
