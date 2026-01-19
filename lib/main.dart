import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/router/app_router.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/theme_provider.dart';
import 'features/dashboard/domain/symbol_item.dart';
import 'features/dashboard/domain/category_item.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SymbolItemAdapter());
  Hive.registerAdapter(CategoryItemAdapter());
  await Hive.openBox(AppConstants.settingsBox);
  // SymbolBox will be opened by Controller lazily or we can open here. 
  // Better to open here to ensure readiness or let controller handle it.
  // For safety/simplicity in MVP, let's let controller open it or do it here.
  
  runApp(
    const ProviderScope(
      child: AdisApp(),
    ),
  );
}

class AdisApp extends ConsumerWidget {
  const AdisApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(themeDataProvider);

    return MaterialApp.router(
      title: 'Adisapp',
      theme: themeData,
      routerConfig: goRouter,
    );
  }
}
