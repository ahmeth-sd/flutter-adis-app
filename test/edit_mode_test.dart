import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:adisapp/features/dashboard/presentation/dashboard_screen.dart';
import 'package:adisapp/features/dashboard/domain/symbol_item.dart';
import 'package:adisapp/features/dashboard/domain/category_item.dart';
import 'package:adisapp/core/constants/app_constants.dart';
import 'dart:io';

import 'package:flutter/services.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '.';
    });
    
    Hive.init('.');
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(SymbolItemAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(CategoryItemAdapter());
  });

  setUp(() async {
    await Hive.openBox(AppConstants.settingsBox);
    await Hive.openBox<SymbolItem>('symbolsBox');
    await Hive.openBox<CategoryItem>('categoriesBox');
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  testWidgets('Dashboard Edit Mode toggle and Dialog test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: DashboardScreen(),
        ),
      ),
    );

    // Initial State: Edit Mode OFF
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);

    // Toggle Edit Mode ON
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    // Verify Edit Mode ON
    expect(find.byIcon(Icons.edit_off), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap Add Button to open Dialog
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify Dialog Open
    expect(find.text('Yeni Kart Ekle'), findsOneWidget);
    
    // Check for Icon Grid (Key part of the new feature)
    expect(find.byType(GridView), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);

    // Close Dialog
    await tester.tap(find.text('İptal'));
    await tester.pumpAndSettle();
  });
}
