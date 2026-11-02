import 'package:flutter/material.dart';

enum BreathPhaseType {
  inhale,
  holdIn,
  exhale,
  holdOut,
}

enum NostrilSide {
  both,
  left,  // Ida Nadi (Chandra/Moon)
  right, // Pingala Nadi (Surya/Sun)
}

enum HapticPatternType {
  rampUp,       // Micro-tick ramp up (Default Inhale)
  heartbeat,    // Soft rhythmic pulse (Default Hold In)
  rampDown,     // Smooth descending hum (Default Exhale)
  stillness,    // Grounding single click + silence (Default Hold Out)
  continuousHum,// Sustained low vibration (Bhramari humming)
  rapidPulse,   // Quick rhythmic ticks (Kapalabhati fire)
  none,
}

class BreathPhase {
  final BreathPhaseType type;
  final String label;
  final String sanskritLabel;
  final int durationSeconds;
  final HapticPatternType hapticType;
  final String hapticDescription;
  final NostrilSide nostrilSide;
  final Color startColor;
  final Color endColor;

  const BreathPhase({
    required this.type,
    required this.label,
    this.sanskritLabel = '',
    required this.durationSeconds,
    required this.hapticType,
    required this.hapticDescription,
    this.nostrilSide = NostrilSide.both,
    required this.startColor,
    required this.endColor,
  });

  BreathPhase copyWith({
    BreathPhaseType? type,
    String? label,
    String? sanskritLabel,
    int? durationSeconds,
    HapticPatternType? hapticType,
    String? hapticDescription,
    NostrilSide? nostrilSide,
    Color? startColor,
    Color? endColor,
  }) {
    return BreathPhase(
      type: type ?? this.type,
      label: label ?? this.label,
      sanskritLabel: sanskritLabel ?? this.sanskritLabel,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      hapticType: hapticType ?? this.hapticType,
      hapticDescription: hapticDescription ?? this.hapticDescription,
      nostrilSide: nostrilSide ?? this.nostrilSide,
      startColor: startColor ?? this.startColor,
      endColor: endColor ?? this.endColor,
    );
  }
}

class BreathingPattern {
  final String id;
  final String title;
  final String sanskritTitle;
  final String subtitle;
  final List<BreathPhase> phases;
  final int defaultCycles;

  const BreathingPattern({
    required this.id,
    required this.title,
    this.sanskritTitle = '',
    required this.subtitle,
    required this.phases,
    this.defaultCycles = 12,
  });

  BreathingPattern copyWith({
    String? id,
    String? title,
    String? sanskritTitle,
    String? subtitle,
    List<BreathPhase>? phases,
    int? defaultCycles,
  }) {
    return BreathingPattern(
      id: id ?? this.id,
      title: title ?? this.title,
      sanskritTitle: sanskritTitle ?? this.sanskritTitle,
      subtitle: subtitle ?? this.subtitle,
      phases: phases ?? this.phases,
      defaultCycles: defaultCycles ?? this.defaultCycles,
    );
  }

  int get totalCycleSeconds => phases.fold(0, (sum, p) => sum + p.durationSeconds);

  static List<BreathingPattern> defaultPatterns = [
    // 1. Classical Nadi Shodhana (Alternate Nostril)
    BreathingPattern(
      id: 'nadi_shodhana',
      title: 'Nadi Shodhana',
      sanskritTitle: 'नाड़ी शोधन प्राणायाम',
      subtitle: 'Balance Ida & Pingala Nadis (4-4-4-4)',
      defaultCycles: 12,
      phases: const [
        BreathPhase(
          type: BreathPhaseType.inhale,
          label: 'Inhale Left',
          sanskritLabel: 'Puraka (Left Nostril)',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampUp,
          hapticDescription: 'Left Nadi gentle cooling ramp',
          nostrilSide: NostrilSide.left,
          startColor: Color(0xFF00F2FE),
          endColor: Color(0xFF4FACFE),
        ),
        BreathPhase(
          type: BreathPhaseType.holdIn,
          label: 'Hold (Both Closed)',
          sanskritLabel: 'Antar Kumbhaka',
          durationSeconds: 4,
          hapticType: HapticPatternType.heartbeat,
          hapticDescription: 'Stillness center pulse',
          nostrilSide: NostrilSide.both,
          startColor: Color(0xFF4FACFE),
          endColor: Color(0xFF8E2DE2),
        ),
        BreathPhase(
          type: BreathPhaseType.exhale,
          label: 'Exhale Right',
          sanskritLabel: 'Rechaka (Right Nostril)',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampDown,
          hapticDescription: 'Right Nadi solar release hum',
          nostrilSide: NostrilSide.right,
          startColor: Color(0xFFFF9100),
          endColor: Color(0xFFFF5252),
        ),
        BreathPhase(
          type: BreathPhaseType.inhale,
          label: 'Inhale Right',
          sanskritLabel: 'Puraka (Right Nostril)',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampUp,
          hapticDescription: 'Right Nadi solar energy ramp',
          nostrilSide: NostrilSide.right,
          startColor: Color(0xFFFF5252),
          endColor: Color(0xFFFFD600),
        ),
        BreathPhase(
          type: BreathPhaseType.holdIn,
          label: 'Hold (Both Closed)',
          sanskritLabel: 'Antar Kumbhaka',
          durationSeconds: 4,
          hapticType: HapticPatternType.heartbeat,
          hapticDescription: 'Stillness center pulse',
          nostrilSide: NostrilSide.both,
          startColor: Color(0xFF8E2DE2),
          endColor: Color(0xFF4FACFE),
        ),
        BreathPhase(
          type: BreathPhaseType.exhale,
          label: 'Exhale Left',
          sanskritLabel: 'Rechaka (Left Nostril)',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampDown,
          hapticDescription: 'Left Nadi lunar calming hum',
          nostrilSide: NostrilSide.left,
          startColor: Color(0xFF00F2FE),
          endColor: Color(0xFF00E676),
        ),
      ],
    ),

    // 2. Classical Vedic Matra (1:4:2 Golden Ratio)
    BreathingPattern(
      id: 'vedic_matra_142',
      title: 'Vedic 1:4:2 Matra',
      sanskritTitle: 'वैदिक मात्रा प्राण',
      subtitle: 'Classical Puraka : Kumbhaka : Rechaka (4-16-8)',
      defaultCycles: 6,
      phases: const [
        BreathPhase(
          type: BreathPhaseType.inhale,
          label: 'Puraka (Inhale)',
          sanskritLabel: 'पूरक (1 Matra)',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampUp,
          hapticDescription: 'Rhythmic ascending tick',
          startColor: Color(0xFF00E676),
          endColor: Color(0xFF00B0FF),
        ),
        BreathPhase(
          type: BreathPhaseType.holdIn,
          label: 'Antar Kumbhaka',
          sanskritLabel: 'कुम्भक (4 Matra)',
          durationSeconds: 16,
          hapticType: HapticPatternType.heartbeat,
          hapticDescription: 'Low calming heartbeat pulse',
          startColor: Color(0xFF00B0FF),
          endColor: Color(0xFF7C4DFF),
        ),
        BreathPhase(
          type: BreathPhaseType.exhale,
          label: 'Rechaka (Exhale)',
          sanskritLabel: 'रेचक (2 Matra)',
          durationSeconds: 8,
          hapticType: HapticPatternType.rampDown,
          hapticDescription: 'Extended slow release wave',
          startColor: Color(0xFF7C4DFF),
          endColor: Color(0xFF00E676),
        ),
      ],
    ),

    // 3. Bhramari (Humming Bee Breath)
    BreathingPattern(
      id: 'bhramari',
      title: 'Bhramari Pranayama',
      sanskritTitle: 'भ्रामरी प्राणायाम',
      subtitle: 'Resonant Humming Bee Calm (4-10)',
      defaultCycles: 10,
      phases: const [
        BreathPhase(
          type: BreathPhaseType.inhale,
          label: 'Gentle Inhale',
          sanskritLabel: 'पूरक (Puraka)',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampUp,
          hapticDescription: 'Deep smooth intake',
          startColor: Color(0xFFFFD700),
          endColor: Color(0xFFFF8C00),
        ),
        BreathPhase(
          type: BreathPhaseType.exhale,
          label: 'Humming Bee (Mmm)',
          sanskritLabel: 'भ्रामरी नाद (Bhramari)',
          durationSeconds: 10,
          hapticType: HapticPatternType.continuousHum,
          hapticDescription: 'Continuous low resonant humming vibration',
          startColor: Color(0xFFFF8C00),
          endColor: Color(0xFFFF007F),
        ),
      ],
    ),

    // 4. Kapalabhati (Skull Shining Breath)
    BreathingPattern(
      id: 'kapalabhati',
      title: 'Kapalabhati',
      sanskritTitle: 'कपालभाति',
      subtitle: 'Dynamic Rhythmic Cleansing Pulses',
      defaultCycles: 30,
      phases: const [
        BreathPhase(
          type: BreathPhaseType.exhale,
          label: 'Forceful Exhale',
          sanskritLabel: 'सक्रिय रेचक',
          durationSeconds: 1,
          hapticType: HapticPatternType.rapidPulse,
          hapticDescription: 'Sharp rhythmic burst',
          startColor: Color(0xFFFF3D00),
          endColor: Color(0xFFFFD600),
        ),
        BreathPhase(
          type: BreathPhaseType.inhale,
          label: 'Passive Inhale',
          sanskritLabel: 'निष्क्रिय पूरक',
          durationSeconds: 1,
          hapticType: HapticPatternType.stillness,
          hapticDescription: 'Natural automatic recovery',
          startColor: Color(0xFFFFD600),
          endColor: Color(0xFFFF3D00),
        ),
      ],
    ),

    // 5. Classic Sama Vritti (Box Breathing 4-4-4-4)
    BreathingPattern(
      id: 'sama_vritti',
      title: 'Sama Vritti (Box)',
      sanskritTitle: 'समवृत्ति प्राणायाम',
      subtitle: 'Equal Ratio Harmony (4-4-4-4)',
      defaultCycles: 12,
      phases: const [
        BreathPhase(
          type: BreathPhaseType.inhale,
          label: 'Puraka (Inhale)',
          sanskritLabel: 'पूरक',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampUp,
          hapticDescription: 'Default micro-tick ramp up',
          startColor: Color(0xFF00F2FE),
          endColor: Color(0xFF4FACFE),
        ),
        BreathPhase(
          type: BreathPhaseType.holdIn,
          label: 'Antar Kumbhaka',
          sanskritLabel: 'आन्तर कुम्भक',
          durationSeconds: 4,
          hapticType: HapticPatternType.heartbeat,
          hapticDescription: 'Default soft heartbeat bump',
          startColor: Color(0xFF4FACFE),
          endColor: Color(0xFF8E2DE2),
        ),
        BreathPhase(
          type: BreathPhaseType.exhale,
          label: 'Rechaka (Exhale)',
          sanskritLabel: 'रेचक',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampDown,
          hapticDescription: 'Default smooth descending hum',
          startColor: Color(0xFF8E2DE2),
          endColor: Color(0xFF4A00E0),
        ),
        BreathPhase(
          type: BreathPhaseType.holdOut,
          label: 'Bahya Kumbhaka',
          sanskritLabel: 'बाह्य कुम्भक',
          durationSeconds: 4,
          hapticType: HapticPatternType.stillness,
          hapticDescription: 'Default grounding stillness',
          startColor: Color(0xFF4A00E0),
          endColor: Color(0xFF00F2FE),
        ),
      ],
    ),
  ];
}
