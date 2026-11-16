import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mind_forensics/app/localization/app_strings.dart';
import 'package:mind_forensics/app/localization/locale_controller.dart';
import 'package:mind_forensics/app/theme/lab_theme.dart';
import 'package:mind_forensics/features/home/presentation/home_screen.dart';
import 'package:mind_forensics/features/insights/presentation/insights_screen.dart';
import 'package:mind_forensics/features/investigation/presentation/flash_case_screen.dart';
import 'package:mind_forensics/features/mind_trace/controllers/mind_trace_controller.dart';
import 'package:mind_forensics/features/mind_trace/domain/mind_trace_model.dart';
import 'package:mind_forensics/features/observatory/presentation/inner_observatory_screen.dart';
import 'package:mind_forensics/features/settings/presentation/settings_screen.dart';
import 'package:mind_forensics/features/tools/presentation/widgets/quick_calm_breathing_sheet.dart';
import 'package:mind_forensics/features/track/presentation/track_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _step6VqaDir = String.fromEnvironment('VQA_OUT_DIR');

Future<void> _loadBundledFonts() async {
  Future<void> loadInter(String family) async {
    final loader = FontLoader(family)
      ..addFont(rootBundle.load('assets/fonts/Inter-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Inter-Medium.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Inter-SemiBold.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Inter-Bold.ttf'));
    await loader.load();
  }

  await loadInter('Inter');
  await loadInter('Inter_regular');
  await loadInter('Inter_500');
  await loadInter('Inter_600');
  await loadInter('Inter_700');

  final arabicLoader = FontLoader('Noto Sans Arabic')
    ..addFont(rootBundle.load('assets/fonts/NotoSansArabic-Regular.ttf'))
    ..addFont(rootBundle.load('assets/fonts/NotoSansArabic-SemiBold.ttf'))
    ..addFont(rootBundle.load('assets/fonts/NotoSansArabic-Bold.ttf'));
  await arabicLoader.load();

  try {
    final iconData =
        await rootBundle.load('assets/fonts/MaterialIcons-Regular.otf');
    final materialLoader = FontLoader('MaterialIcons')
      ..addFont(Future.value(iconData));
    await materialLoader.load();
  } catch (_) {}
}

Future<void> _seedSteadyTraces(ProviderContainer container) async {
  final now = DateTime.now();
  const moods = [
    ('calm', 3),
    ('anxious', 6),
    ('frustrated', 5),
    ('heavy', 4),
    ('restless', 6),
    ('calm', 4),
  ];
  final repo = container.read(mindTraceRepositoryProvider);
  for (int i = 0; i < moods.length; i++) {
    final day = now.subtract(Duration(days: moods.length - 1 - i));
    final (mood, intensity) = moods[i];
    await repo.saveTrace(
      MindTraceModel(
        id: 'step6_qa_$i',
        userId: 'qa_user',
        date: DateTime(day.year, day.month, day.day, 10, 0),
        overallMood: mood,
        moodIntensity: intensity,
        energyLevel: 6,
        anxietyLevel: 4,
        journalText: 'Calm morning reflection after breathing reset.',
        sleepHours: 7.5,
        createdAt: day,
        updatedAt: day,
      ),
    );
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
    await _loadBundledFonts();
  });

  Future<void> pumpAndVerifySurface(
    WidgetTester tester, {
    required String surfaceName,
    required Widget Function(AppStrings strings) builder,
    required double width,
    required double textScale,
    required AppLanguage language,
    required bool isDark,
    String? captureFilename,
  }) async {
    SharedPreferences.setMockInitialValues({
      'mind_forensics_locale': language.code,
      'mf_onboarding_completed': true,
    });

    final container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(localeControllerProvider.notifier).setLanguage(language);
    await _seedSteadyTraces(container);

    final logicalSize = Size(width, 760);
    tester.view.physicalSize = logicalSize;
    tester.view.devicePixelRatio = 1.0;

    final errors = <FlutterErrorDetails>[];
    final prevOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      errors.add(details);
    };

    final repaintKey = GlobalKey();
    final isArabic = language == AppLanguage.arabic;
    final strings = AppStrings(language.code);

    try {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MediaQuery(
            data: MediaQueryData(
              size: logicalSize,
              textScaler: TextScaler.linear(textScale),
              disableAnimations: true,
            ),
            child: RepaintBoundary(
              key: repaintKey,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: buildMindTheme(
                  Brightness.light,
                  isArabic: isArabic,
                ),
                darkTheme: buildMindTheme(
                  Brightness.dark,
                  isArabic: isArabic,
                ),
                themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                locale: Locale(language.code),
                supportedLocales: const [
                  Locale('en'),
                  Locale('fr'),
                  Locale('ar'),
                ],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                home: builder(strings),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      if (isArabic) {
        expect(
          Directionality.of(tester.element(find.byType(Scaffold).first)),
          TextDirection.rtl,
          reason: '$surfaceName must use RTL when locale is ar',
        );
      }

      expect(
        errors.map((e) => e.exceptionAsString()).toList(),
        isEmpty,
        reason:
            'Layout/overflow errors on $surfaceName (${width}px, ${textScale}x, ${language.code}, dark=$isDark)',
      );
      expect(tester.takeException(), isNull);

      if (_step6VqaDir.isNotEmpty && captureFilename != null) {
        final boundary = repaintKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
        await tester.runAsync(() async {
          final dir = Directory(_step6VqaDir);
          if (!dir.existsSync()) {
            dir.createSync(recursive: true);
          }
          final image = await boundary.toImage(pixelRatio: 2.0);
          final byteData =
              await image.toByteData(format: ui.ImageByteFormat.png);
          if (byteData != null) {
            final file =
                File('${dir.path}${Platform.pathSeparator}$captureFilename');
            await file.writeAsBytes(byteData.buffer.asUint8List());
          }
        });
      }
    } finally {
      FlutterError.onError = prevOnError;
      tester.view.reset();
    }
  }

  group('Step 6 Visual QA Matrix (Dawn Light & Vercel Dark, 360/320px, 1.35x, RTL)', () {
    final surfaces =
        <({String id, Widget Function(AppStrings strings) build})>[
      (id: 'home', build: (_) => const HomeScreen()),
      (id: 'track', build: (_) => const TrackScreen()),
      (id: 'ai_guide', build: (_) => const FlashCaseScreen()),
      (id: 'insights', build: (_) => const InsightsScreen()),
      (id: 'profile', build: (_) => const SettingsScreen()),
      (id: 'tools', build: (_) => const InnerObservatoryScreen()),
      (
        id: 'breathing',
        build: (s) => Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: QuickCalmBreathingSheet(strings: s),
          ),
        ),
      ),
    ];

    for (final s in surfaces) {
      testWidgets('${s.id}: 360px Dawn Light EN 1.0x', (tester) async {
        await pumpAndVerifySurface(
          tester,
          surfaceName: s.id,
          builder: s.build,
          width: 360,
          textScale: 1.0,
          language: AppLanguage.english,
          isDark: false,
          captureFilename: 's6_${s.id}_360_light_en.png',
        );
      });

      testWidgets('${s.id}: 360px Vercel Dark EN 1.0x', (tester) async {
        await pumpAndVerifySurface(
          tester,
          surfaceName: s.id,
          builder: s.build,
          width: 360,
          textScale: 1.0,
          language: AppLanguage.english,
          isDark: true,
          captureFilename: 's6_${s.id}_360_dark_en.png',
        );
      });

      testWidgets('${s.id}: 320px Vercel Dark 1.35x text scale EN', (tester) async {
        await pumpAndVerifySurface(
          tester,
          surfaceName: s.id,
          builder: s.build,
          width: 320,
          textScale: 1.35,
          language: AppLanguage.english,
          isDark: true,
          captureFilename: 's6_${s.id}_320_dark_135.png',
        );
      });

      testWidgets('${s.id}: 360px Dawn Light 1.35x RTL (AR)', (tester) async {
        await pumpAndVerifySurface(
          tester,
          surfaceName: s.id,
          builder: s.build,
          width: 360,
          textScale: 1.35,
          language: AppLanguage.arabic,
          isDark: false,
          captureFilename: 's6_${s.id}_360_light_ar_rtl.png',
        );
      });

      testWidgets('${s.id}: 320px Vercel Dark RTL (AR)', (tester) async {
        await pumpAndVerifySurface(
          tester,
          surfaceName: s.id,
          builder: s.build,
          width: 320,
          textScale: 1.0,
          language: AppLanguage.arabic,
          isDark: true,
          captureFilename: 's6_${s.id}_320_dark_ar_rtl.png',
        );
      });
    }
  });
}
