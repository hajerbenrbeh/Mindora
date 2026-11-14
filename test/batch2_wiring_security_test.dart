import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mind_forensics/app/theme/lab_theme.dart';
import 'package:mind_forensics/core/security/app_lock_provider.dart';
import 'package:mind_forensics/core/security/biometric_service.dart';
import 'package:mind_forensics/core/security/lock_overlay.dart';
import 'package:mind_forensics/features/backup/data/unified_backup_service.dart';
import 'package:mind_forensics/features/case_file/presentation/case_report_screen.dart';
import 'package:mind_forensics/features/investigation/controllers/investigation_providers.dart';
import 'package:mind_forensics/features/investigation/domain/case_model.dart';
import 'package:mind_forensics/features/investigation/domain/case_stage.dart';
import 'package:mind_forensics/features/investigation/domain/statement.dart';
import 'package:mind_forensics/features/mind_trace/controllers/mind_trace_controller.dart';
import 'package:mind_forensics/features/mind_trace/domain/mind_trace_model.dart';
import 'package:mind_forensics/features/observatory/data/local_symptom_repository.dart';
import 'package:mind_forensics/features/observatory/domain/symptom_report.dart';
import 'package:mind_forensics/features/observatory/presentation/widgets/symptom_library_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeLocalAuth extends Fake implements LocalAuthentication {
  bool shouldSucceed = true;

  @override
  Future<bool> get canCheckBiometrics async => true;

  @override
  Future<bool> isDeviceSupported() async => true;

  @override
  Future<bool> authenticate({
    required String localizedReason,
    Iterable<dynamic> authMessages = const [],
    bool biometricOnly = false,
    bool persistAcrossBackgrounding = false,
    bool sensitiveTransaction = true,
  }) async {
    return shouldSucceed;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Batch 2 Security, Backup, Report & Symptom Log Regressions', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('AppLockNotifier starts uninitialized before async check completes', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final initialState = container.read(appLockProvider);
      expect(initialState.isInitialized, isFalse);
      expect(initialState.isLocked, isFalse);
    });

    testWidgets('LockOverlay renders child after init and re-locks on paused lifecycle',
        (tester) async {
      final container = ProviderContainer(
        overrides: [
          biometricServiceProvider.overrideWithValue(
            BiometricSecurityService(auth: _FakeLocalAuth()),
          ),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: LabTheme.nightTheme,
            home: const LockOverlay(
              child: Scaffold(body: Text('PRIVATE_VAULT_CONTENT')),
            ),
          ),
        ),
      );

      // Once initialized (biometrics disabled by default), child renders.
      await tester.pumpAndSettle();
      expect(container.read(appLockProvider).isInitialized, isTrue);
      expect(find.text('PRIVATE_VAULT_CONTENT'), findsOneWidget);

      // Enable biometrics & authenticate; then background the app -> must lock.
      final enabled = await container.read(appLockProvider.notifier).toggleBiometrics(true);
      expect(enabled, isTrue);
      await tester.pump();
      expect(container.read(appLockProvider).isLocked, isFalse);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump();
      expect(container.read(appLockProvider).isLocked, isTrue);

      // Frames resume on foreground transition; LockOverlay must immediately shield child.
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(find.text('PRIVATE_VAULT_CONTENT'), findsNothing);
    });

    test('Password-encrypted backup rejects wrong password and restores on matching password',
        () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final now = DateTime.now();
      await container.read(caseRepositoryProvider).saveCase(
            CaseModel(
              id: 'b2_case_1',
              caseNumber: 'CASE-01',
              title: 'Deadline Pressure',
              currentStage: CaseStage.conclusion,
              incidentDescription: 'Felt rushed before standup.',
              findingsSummary: 'All-or-nothing self-expectation.',
              createdAt: now,
              updatedAt: now,
            ),
          );
      await container.read(mindTraceRepositoryProvider).saveTrace(
            MindTraceModel(
              id: 'b2_trace_1',
              date: now,
              overallMood: 'calm',
              moodIntensity: 4,
              createdAt: now,
              updatedAt: now,
            ),
          );

      final backupService = container.read(unifiedBackupServiceProvider);
      final exportRes = await backupService.createPasswordEncryptedBackup('SecretKey!2026');
      expect(exportRes.success, isTrue);
      expect(exportRes.rawJson, isNotNull);
      expect(exportRes.rawJson, isNot(contains('Deadline Pressure')));

      // Clear local data
      await container.read(caseRepositoryProvider).deleteAllCases();
      await container.read(mindTraceRepositoryProvider).clearAllTraces();
      expect(await container.read(caseRepositoryProvider).getAllCases(), isEmpty);

      // Wrong password must fail cleanly
      final wrongRes = await backupService.restoreFromPasswordEncryptedBackup(
        exportRes.rawJson!,
        'WrongPass',
      );
      expect(wrongRes.success, isFalse);

      // Correct password restores data
      final okRes = await backupService.restoreFromPasswordEncryptedBackup(
        exportRes.rawJson!,
        'SecretKey!2026',
      );
      expect(okRes.success, isTrue);
      final restoredCases = await container.read(caseRepositoryProvider).getAllCases();
      final restoredTraces = await container.read(mindTraceRepositoryProvider).getAllTraces();
      expect(restoredCases.map((c) => c.title), contains('Deadline Pressure'));
      expect(restoredTraces.map((t) => t.id), contains('b2_trace_1'));
    });

    testWidgets('CaseReportScreen renders findingsSummary and dialogue statements',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final now = DateTime.now();
      await container.read(caseRepositoryProvider).saveCase(
            CaseModel(
              id: 'b2_report_case',
              caseNumber: 'CASE-07',
              title: 'Quiet Evening Reflection',
              currentStage: CaseStage.conclusion,
              incidentDescription: 'Paced in the hallway after receiving feedback.',
              findingsSummary: 'Delayed criticism tends to amplify worst-case forecasting.',
              statements: [
                Statement(
                  id: 's1',
                  text: 'Notice how fast the conclusion jumped ahead of the evidence.',
                  speaker: StatementSpeaker.investigator,
                  timestamp: now,
                ),
                Statement(
                  id: 's2',
                  text: 'I assumed one critique meant the whole sprint failed.',
                  speaker: StatementSpeaker.user,
                  timestamp: now,
                ),
              ],
              createdAt: now,
              updatedAt: now,
            ),
          );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: LabTheme.nightTheme,
            home: const CaseReportScreen(caseId: 'b2_report_case'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Delayed criticism tends to amplify worst-case forecasting.'),
        findsOneWidget,
      );
      expect(
        find.text('Notice how fast the conclusion jumped ahead of the evidence.'),
        findsOneWidget,
      );
      expect(
        find.text('I assumed one critique meant the whole sprint failed.'),
        findsOneWidget,
      );
    });

    testWidgets('SymptomLibraryView displays Saved Logs tab and persisted reports',
        (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(symptomRepositoryProvider).saveReport(
            SymptomReport(
              id: 'rep_1',
              symptomIds: const ['sym_persistent_heaviness'],
              createdAt: DateTime.now(),
              intensity: 6,
              aiAnalysis: 'Tight shoulders before sleep.',
            ),
          );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: LabTheme.nightTheme,
            home: const Scaffold(body: SymptomLibraryView()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final savedLogsTab = find.text('Saved Logs (1)');
      expect(savedLogsTab, findsOneWidget);
      await tester.tap(savedLogsTab);
      await tester.pumpAndSettle();

      expect(find.text('Tight shoulders before sleep.'), findsOneWidget);
    });
  });
}
