import 'package:flutter/material.dart';

enum BreathPhaseType {
  inhale,
  holdIn,
  exhale,
  holdOut,
}

class BreathPhase {
  final BreathPhaseType type;
  final String label;
  final int durationSeconds;
  final String hapticDescription;
  final Color startColor;
  final Color endColor;

  const BreathPhase({
    required this.type,
    required this.label,
    required this.durationSeconds,
    required this.hapticDescription,
    required this.startColor,
    required this.endColor,
  });

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'label': label,
    'durationSeconds': durationSeconds,
    'hapticDescription': hapticDescription,
  };

  factory BreathPhase.fromJson(Map<String, dynamic> json) {
    final type = BreathPhaseType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => BreathPhaseType.inhale,
    );
    return BreathPhase(
      type: type,
      label: json['label'] ?? 'Breath',
      durationSeconds: json['durationSeconds'] ?? 4,
      hapticDescription: json['hapticDescription'] ?? '',
      startColor: const Color(0xFF00F2FE),
      endColor: const Color(0xFF4FACFE),
    );
  }
}

class BreathingPattern {
  final String id;
  final String title;
  final String subtitle;
  final List<BreathPhase> phases;
  final int defaultCycles;

  const BreathingPattern({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.phases,
    this.defaultCycles = 10,
  });

  int get totalCycleSeconds => phases.fold(0, (sum, p) => sum + p.durationSeconds);

  static List<BreathingPattern> defaultPatterns = [
    BreathingPattern(
      id: 'box_breathing',
      title: 'Box Breathing',
      subtitle: 'Focus & Stress Reduction (4-4-4-4)',
      defaultCycles: 10,
      phases: const [
        BreathPhase(
          type: BreathPhaseType.inhale,
          label: 'Inhale',
          durationSeconds: 4,
          hapticDescription: 'Micro-tick ramp up',
          startColor: Color(0xFF00F2FE),
          endColor: Color(0xFF4FACFE),
        ),
        BreathPhase(
          type: BreathPhaseType.holdIn,
          label: 'Hold (Full)',
          durationSeconds: 4,
          hapticDescription: 'Soft rhythmic pulse',
          startColor: Color(0xFF4FACFE),
          endColor: Color(0xFF8E2DE2),
        ),
        BreathPhase(
          type: BreathPhaseType.exhale,
          label: 'Exhale',
          durationSeconds: 4,
          hapticDescription: 'Smooth descending hum',
          startColor: Color(0xFF8E2DE2),
          endColor: Color(0xFF4A00E0),
        ),
        BreathPhase(
          type: BreathPhaseType.holdOut,
          label: 'Hold (Empty)',
          durationSeconds: 4,
          hapticDescription: 'Pure stillness',
          startColor: Color(0xFF4A00E0),
          endColor: Color(0xFF00F2FE),
        ),
      ],
    ),
    BreathingPattern(
      id: 'relax_478',
      title: '4-7-8 Relax',
      subtitle: 'Deep Sleep & Nervous System Calm',
      defaultCycles: 8,
      phases: const [
        BreathPhase(
          type: BreathPhaseType.inhale,
          label: 'Inhale',
          durationSeconds: 4,
          hapticDescription: 'Gentle rising hum',
          startColor: Color(0xFF00E676),
          endColor: Color(0xFF00B0FF),
        ),
        BreathPhase(
          type: BreathPhaseType.holdIn,
          label: 'Hold (Full)',
          durationSeconds: 7,
          hapticDescription: 'Low calming heartbeat',
          startColor: Color(0xFF00B0FF),
          endColor: Color(0xFF7C4DFF),
        ),
        BreathPhase(
          type: BreathPhaseType.exhale,
          label: 'Exhale',
          durationSeconds: 8,
          hapticDescription: 'Long slow release vibration',
          startColor: Color(0xFF7C4DFF),
          endColor: Color(0xFF00E676),
        ),
      ],
    ),
    BreathingPattern(
      id: 'awake_energize',
      title: 'Awake & Energize',
      subtitle: 'Quick Oxygenation Boost (2-1-4-1)',
      defaultCycles: 15,
      phases: const [
        BreathPhase(
          type: BreathPhaseType.inhale,
          label: 'Power Inhale',
          durationSeconds: 2,
          hapticDescription: 'Rapid rising tick',
          startColor: Color(0xFFFF9100),
          endColor: Color(0xFFFF5252),
        ),
        BreathPhase(
          type: BreathPhaseType.holdIn,
          label: 'Peak Hold',
          durationSeconds: 1,
          hapticDescription: 'Sharp pulse',
          startColor: Color(0xFFFF5252),
          endColor: Color(0xFFFFD600),
        ),
        BreathPhase(
          type: BreathPhaseType.exhale,
          label: 'Exhale',
          durationSeconds: 4,
          hapticDescription: 'Steady descending hum',
          startColor: Color(0xFFFFD600),
          endColor: Color(0xFFFF9100),
        ),
        BreathPhase(
          type: BreathPhaseType.holdOut,
          label: 'Rest',
          durationSeconds: 1,
          hapticDescription: 'Silence',
          startColor: Color(0xFFFF9100),
          endColor: Color(0xFFFF9100),
        ),
      ],
    ),
  ];
}
