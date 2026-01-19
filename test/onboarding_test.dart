import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:adisapp/features/onboarding/presentation/onboarding_screen.dart';
import 'package:adisapp/core/constants/app_constants.dart';

void main() {
  setUp(() async {
    Hive.init('test_store');
    if (!Hive.isBoxOpen(AppConstants.settingsBox)) {
      await Hive.openBox(AppConstants.settingsBox);
    }
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  testWidgets('Onboarding Screen renders and valid selection works', (WidgetTester tester) async {
    // Create a router for testing
    final router = GoRouter(
      initialLocation: '/onboarding',
      routes: [
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Text('Home Screen')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    // Verify initial state
    expect(find.text('Hoşgeldiniz'), findsOneWidget);
    expect(find.text('Devam Et'), findsOneWidget);

    // Try submit without data
    await tester.tap(find.text('Devam Et'));
    await tester.pumpAndSettle();
    expect(find.text('Lütfen yaşınızı girin'), findsOneWidget);

    // Enter Age
    await tester.enterText(find.widgetWithText(TextFormField, 'Yaş'), '70');
    
    // Select Switch (Impairment)
    await tester.tap(find.byType(Switch));
    await tester.pump();

    // Select Level (Dropdown)
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    
    // Tap the item in the menu
    await tester.tap(find.text('Temel (4x3)'));
    await tester.pumpAndSettle();

    // Submit
    await tester.tap(find.text('Devam Et'));
    await tester.pumpAndSettle();

    // Debug: Check if validation error is present
    if (find.text('Lütfen bir düzey seçin').evaluate().isNotEmpty) {
      debugPrint('Validation failed: Level not selected');
    }

    // Should navigate to Home
    expect(find.text('Home Screen'), findsOneWidget);
  });
}
