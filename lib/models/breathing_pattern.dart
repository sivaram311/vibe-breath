import 'package:flutter/material.dart';

enum BreathPhaseType {
  inhale,   // பூரகம் (உட்சுவாசம்)
  holdIn,   // கும்பகம் (அடைத்தல்)
  exhale,   // ரேசகம் (வெளிச்சுவாசம்)
  holdOut,  // சூனிய கும்பகம் (வெற்றிட அடக்கம்)
}

enum NostrilSide {
  both,
  left,  // இடைகலை (சந்திர கலை / திங்கள்)
  right, // பிங்கலை (சூரிய கலை / ஞாயிறு)
}

enum HapticPatternType {
  rampUp,       // சீரான ஏறுவரிசை அதிர்வு (பூரகம்)
  heartbeat,    // இதயத் துடிப்பு போன்ற மென் அதிர்வு (கும்பகம்)
  rampDown,     // சீரான இறங்குவரிசை அதிர்வு (ரேசகம்)
  stillness,    // அமைதி மற்றும் மௌனம் (சூனியம்)
  continuousHum,// தொடர் ரீங்கார அதிர்வு (பிராமரி / ஓங்காரம்)
  rapidPulse,   // வேகமான அக்னித் துடிப்பு (கபாலபதி)
  none,
}

class BreathPhase {
  final BreathPhaseType type;
  final String labelTamil;        // முதன்மை தமிழ் பெயர் (எ.கா. பூரகம் - உட்சுவாசம்)
  final String labelEnglish;      // துணையான ஆங்கில பெயர்
  final String siddhaNote;        // சித்தர் குறிப்பு
  final int durationSeconds;
  final HapticPatternType hapticType;
  final String hapticDescription;
  final NostrilSide nostrilSide;
  final Color startColor;
  final Color endColor;

  const BreathPhase({
    required this.type,
    required this.labelTamil,
    required this.labelEnglish,
    this.siddhaNote = '',
    required this.durationSeconds,
    required this.hapticType,
    required this.hapticDescription,
    this.nostrilSide = NostrilSide.both,
    required this.startColor,
    required this.endColor,
  });
}

class BreathingPattern {
  final String id;
  final String titleTamil;        // முதன்மை தமிழ் தலைப்பு
  final String titleEnglish;
  final String siddhaAuthor;      // திருமூலர் / அகத்தியர்
  final String verseTamil;        // மூலப் பாடல் வரிகள்
  final String subtitleTamil;     // விரிவுரை
  final List<BreathPhase> phases;
  final int defaultCycles;

  const BreathingPattern({
    required this.id,
    required this.titleTamil,
    required this.titleEnglish,
    required this.siddhaAuthor,
    this.verseTamil = '',
    required this.subtitleTamil,
    required this.phases,
    this.defaultCycles = 12,
  });

  int get totalCycleSeconds => phases.fold(0, (sum, p) => sum + p.durationSeconds);

  static List<BreathingPattern> defaultPatterns = [
    // 1. திருமூலர் வாசி யோகம் (திருமந்திரம் 568 - ஏற்றி இறக்கி இருகாலும்)
    BreathingPattern(
      id: 'thirumoolar_vaasi',
      titleTamil: 'திருமூலர் வாசி யோகம்',
      titleEnglish: 'Thirumoolar Vaasi Yogam',
      siddhaAuthor: 'திருமூலர் நாயனார் (திருமந்திரம்)',
      verseTamil: 'ஏற்றி இறக்கி இருகாலும் பூரிக்குங் காற்றைப் பிடிக்கும் கணக்கறிவார் இல்லை',
      subtitleTamil: 'ஆயுள் காக்கும் வாசிப் பயிற்சி (16:64:32 விகித அடிப்படை)',
      defaultCycles: 10,
      phases: const [
        BreathPhase(
          type: BreathPhaseType.inhale,
          labelTamil: 'பூரகம் (உள்ளிழுத்தல்)',
          labelEnglish: 'Inhale (Purakam)',
          siddhaNote: 'இடைகலை வழி காற்று உட்செல்லுதல்',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampUp,
          hapticDescription: 'சீரான ஏறுவரிசை அதிர்வு',
          nostrilSide: NostrilSide.left,
          startColor: Color(0xFF00F2FE),
          endColor: Color(0xFF4FACFE),
        ),
        BreathPhase(
          type: BreathPhaseType.holdIn,
          labelTamil: 'கும்பகம் (உள் நிறுத்துதல்)',
          labelEnglish: 'Hold (Kumbhakam)',
          siddhaNote: 'சுழுமுனையில் பிராணனை அடக்குதல்',
          durationSeconds: 8,
          hapticType: HapticPatternType.heartbeat,
          hapticDescription: 'மெதுவான இதயத் துடிப்பு அலை',
          nostrilSide: NostrilSide.both,
          startColor: Color(0xFF4FACFE),
          endColor: Color(0xFF8E2DE2),
        ),
        BreathPhase(
          type: BreathPhaseType.exhale,
          labelTamil: 'ரேசகம் (வெளியேற்றுதல்)',
          labelEnglish: 'Exhale (Rechakam)',
          siddhaNote: 'பிங்கலை வழி காற்று வெளிவருதல்',
          durationSeconds: 8,
          hapticType: HapticPatternType.rampDown,
          hapticDescription: 'சீரான இறங்குவரிசை அதிர்வு',
          nostrilSide: NostrilSide.right,
          startColor: Color(0xFFFF9100),
          endColor: Color(0xFFFF5252),
        ),
        BreathPhase(
          type: BreathPhaseType.holdOut,
          labelTamil: 'சூனியம் (வெற்றிட அடக்கம்)',
          labelEnglish: 'Hold Empty (Sooniyam)',
          siddhaNote: 'மௌன நிலை அமைதி',
          durationSeconds: 4,
          hapticType: HapticPatternType.stillness,
          hapticDescription: 'முழுமையான அமைதி',
          nostrilSide: NostrilSide.both,
          startColor: Color(0xFF4A00E0),
          endColor: Color(0xFF00F2FE),
        ),
      ],
    ),

    // 2. அகத்தியர் சௌக்கிய வாசி (கலை மாற்றம் - இடைகலை / பிங்கலை)
    BreathingPattern(
      id: 'agathiyar_soukkiya',
      titleTamil: 'அகத்தியர் நாடி சுத்தி வாசி',
      titleEnglish: 'Agathiyar Nadi Shodhana',
      siddhaAuthor: 'அகத்திய மாமுனிவர்',
      verseTamil: 'சந்திர சூரிய நாடிகள் சமநிலை பெறுக',
      subtitleTamil: 'சந்திர கலை (இடம்) & சூரிய கலை (வலம்) சமநிலைப்படுத்துதல்',
      defaultCycles: 12,
      phases: const [
        BreathPhase(
          type: BreathPhaseType.inhale,
          labelTamil: 'சந்திர கலை உள்ளிழு (இடம்)',
          labelEnglish: 'Inhale Left (Chandra Nadi)',
          siddhaNote: 'குளிர்ச்சி மற்றும் அமைதி தரும் இடைகலை',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampUp,
          hapticDescription: 'இடைகலை குளிர்ச்சி ஏறு அதிர்வு',
          nostrilSide: NostrilSide.left,
          startColor: Color(0xFF00F2FE),
          endColor: Color(0xFF4FACFE),
        ),
        BreathPhase(
          type: BreathPhaseType.holdIn,
          labelTamil: 'அந்தர கும்பகம் (நிறுத்து)',
          labelEnglish: 'Hold In (Antar Kumbhakam)',
          siddhaNote: 'இரு நாசிகளையும் மூடி நிறுத்துதல்',
          durationSeconds: 4,
          hapticType: HapticPatternType.heartbeat,
          hapticDescription: 'மைய அமைதித் துடிப்பு',
          nostrilSide: NostrilSide.both,
          startColor: Color(0xFF4FACFE),
          endColor: Color(0xFF8E2DE2),
        ),
        BreathPhase(
          type: BreathPhaseType.exhale,
          labelTamil: 'சூரிய கலை வெளியிடு (வலம்)',
          labelEnglish: 'Exhale Right (Surya Nadi)',
          siddhaNote: 'வெப்பம் மற்றும் சுறுசுறுப்பு வெளியீடு',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampDown,
          hapticDescription: 'வலது நாடி இறங்கு அதிர்வு',
          nostrilSide: NostrilSide.right,
          startColor: Color(0xFFFF9100),
          endColor: Color(0xFFFF5252),
        ),
        BreathPhase(
          type: BreathPhaseType.inhale,
          labelTamil: 'சூரிய கலை உள்ளிழு (வலம்)',
          labelEnglish: 'Inhale Right (Surya Nadi)',
          siddhaNote: 'சூரிய ஆற்றல் உட்செலுத்துதல்',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampUp,
          hapticDescription: 'சூரிய நாடி எழுச்சி அதிர்வு',
          nostrilSide: NostrilSide.right,
          startColor: Color(0xFFFF5252),
          endColor: Color(0xFFFFD600),
        ),
        BreathPhase(
          type: BreathPhaseType.holdIn,
          labelTamil: 'அந்தர கும்பகம் (நிறுத்து)',
          labelEnglish: 'Hold In (Antar Kumbhakam)',
          siddhaNote: 'பிராணனை நிறுத்துதல்',
          durationSeconds: 4,
          hapticType: HapticPatternType.heartbeat,
          hapticDescription: 'மைய அமைதித் துடிப்பு',
          nostrilSide: NostrilSide.both,
          startColor: Color(0xFF8E2DE2),
          endColor: Color(0xFF4FACFE),
        ),
        BreathPhase(
          type: BreathPhaseType.exhale,
          labelTamil: 'சந்திர கலை வெளியிடு (இடம்)',
          labelEnglish: 'Exhale Left (Chandra Nadi)',
          siddhaNote: 'சுத்திகரிக்கப்பட்ட பிராணன் வெளியீடு',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampDown,
          hapticDescription: 'இடது நாடி அமைதி அதிர்வு',
          nostrilSide: NostrilSide.left,
          startColor: Color(0xFF00F2FE),
          endColor: Color(0xFF00E676),
        ),
      ],
    ),

    // 3. காயகல்ப சம மூச்சு (4-4-4-4 சமநிலை)
    BreathingPattern(
      id: 'kayakalpa_sama',
      titleTamil: 'சித்தர் காயகல்ப சம மூச்சு',
      titleEnglish: 'Siddha Kayakalpa Breath',
      siddhaAuthor: 'பதினெண் சித்தர்கள் மரபு',
      verseTamil: 'உடம்பினை முன்னம் இழுக்கென் றிருந்தேன் உடம்பினுக் குள்ளே உறுபொருள் கண்டேன்',
      subtitleTamil: 'நால்வகைச் சுவாசம் சமநிலை பெறும் காயகல்ப முறை',
      defaultCycles: 16,
      phases: const [
        BreathPhase(
          type: BreathPhaseType.inhale,
          labelTamil: 'பூரகம் (உள்ளிழு)',
          labelEnglish: 'Inhale',
          siddhaNote: 'சீர்மிகு பிராண ஈர்ப்பு',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampUp,
          hapticDescription: 'சீரான ஏறுவரிசை அதிர்வு',
          startColor: Color(0xFF00F2FE),
          endColor: Color(0xFF4FACFE),
        ),
        BreathPhase(
          type: BreathPhaseType.holdIn,
          labelTamil: 'கும்பகம் (அடக்கு)',
          labelEnglish: 'Hold Full',
          siddhaNote: 'உள்முக அடக்கம்',
          durationSeconds: 4,
          hapticType: HapticPatternType.heartbeat,
          hapticDescription: 'இதயத் துடிப்பு அதிர்வு',
          startColor: Color(0xFF4FACFE),
          endColor: Color(0xFF8E2DE2),
        ),
        BreathPhase(
          type: BreathPhaseType.exhale,
          labelTamil: 'ரேசகம் (வெளியிடு)',
          labelEnglish: 'Exhale',
          siddhaNote: 'நச்சு நீக்கம்',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampDown,
          hapticDescription: 'சீரான இறங்குவரிசை அதிர்வு',
          startColor: Color(0xFF8E2DE2),
          endColor: Color(0xFF4A00E0),
        ),
        BreathPhase(
          type: BreathPhaseType.holdOut,
          labelTamil: 'சூனியம் (வெற்றிடம்)',
          labelEnglish: 'Hold Empty',
          siddhaNote: 'முழு மௌன நிலை',
          durationSeconds: 4,
          hapticType: HapticPatternType.stillness,
          hapticDescription: 'பூரண அமைதி',
          startColor: Color(0xFF4A00E0),
          endColor: Color(0xFF00F2FE),
        ),
      ],
    ),

    // 4. பிராமரி ஓங்கார நாத வாசி (ரீங்காரம்)
    BreathingPattern(
      id: 'omkara_bhramari',
      titleTamil: 'ஓங்கார நாத பிராமரி',
      titleEnglish: 'Omkara Bhramari Hum',
      siddhaAuthor: 'நாதாந்த சித்தர் முறை',
      verseTamil: 'நாத விந்து கலாதி நமோ நம',
      subtitleTamil: 'வண்டு ரீங்காரம் போல தொடர் அதிர்வு தரும் மன அமைதி',
      defaultCycles: 8,
      phases: const [
        BreathPhase(
          type: BreathPhaseType.inhale,
          labelTamil: 'மெல்லிய பூரகம் (உள்ளிழு)',
          labelEnglish: 'Gentle Inhale',
          siddhaNote: 'ஆழ்ந்த பிராண ஈர்ப்பு',
          durationSeconds: 4,
          hapticType: HapticPatternType.rampUp,
          hapticDescription: 'மெதுவான ஏறு அதிர்வு',
          startColor: Color(0xFFFFD700),
          endColor: Color(0xFFFF8C00),
        ),
        BreathPhase(
          type: BreathPhaseType.exhale,
          labelTamil: 'ரீங்கார ரேசகம் (ம்ம்ம்...)',
          labelEnglish: 'Humming Bee Exhale',
          siddhaNote: 'சிரம் முழுதும் பரவும் நாத அதிர்வு',
          durationSeconds: 10,
          hapticType: HapticPatternType.continuousHum,
          hapticDescription: 'தொடர் ரீங்கார அதிர்வு அலை',
          startColor: Color(0xFFFF8C00),
          endColor: Color(0xFFFF007F),
        ),
      ],
    ),
  ];
}
