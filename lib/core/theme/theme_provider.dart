import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

// State model for Theme Settings
class ThemeSettings {
  final bool isHighContrast;
  final double fontSizeScale;

  ThemeSettings({
    this.isHighContrast = false,
    this.fontSizeScale = 1.0,
  });

  ThemeSettings copyWith({
    bool? isHighContrast,
    double? fontSizeScale,
  }) {
    return ThemeSettings(
      isHighContrast: isHighContrast ?? this.isHighContrast,
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
    );
  }
}

// Notifier to manage Theme Settings
class ThemeController extends StateNotifier<ThemeSettings> {
  ThemeController() : super(ThemeSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    final box = Hive.box(AppConstants.settingsBox);
    final isHighContrast = box.get(AppConstants.highContrastKey, defaultValue: false);
    final fontSizeScale = box.get(AppConstants.fontSizeScaleKey, defaultValue: 1.0);
    
    state = ThemeSettings(
      isHighContrast: isHighContrast,
      fontSizeScale: fontSizeScale,
    );
  }

  Future<void> setHighContrast(bool value) async {
    final box = Hive.box(AppConstants.settingsBox);
    await box.put(AppConstants.highContrastKey, value);
    state = state.copyWith(isHighContrast: value);
  }

  Future<void> setFontSizeScale(double value) async {
    final box = Hive.box(AppConstants.settingsBox);
    await box.put(AppConstants.fontSizeScaleKey, value);
    state = state.copyWith(fontSizeScale: value);
  }
}

// Provider
final themeControllerProvider = StateNotifierProvider<ThemeController, ThemeSettings>((ref) {
  return ThemeController();
});

// Generated Theme Data based on settings
final themeDataProvider = Provider<ThemeData>((ref) {
  final settings = ref.watch(themeControllerProvider);

  if (settings.isHighContrast) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: const ColorScheme.dark(
        primary: Colors.yellow,
        onPrimary: Colors.black,
        surface: Colors.black,
        onSurface: Colors.yellow,
        secondary: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: Colors.grey[900], // Slightly lighter black for cards
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.yellow, width: 2)),
      ),
      iconTheme: const IconThemeData(color: Colors.yellow, size: 32),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.yellow,
        titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.yellow),
      ),
      useMaterial3: true,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.yellow),
        titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.yellow), // Card labels
        titleLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.yellow),
      ).apply(fontSizeFactor: settings.fontSizeScale),
    );
  }

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    useMaterial3: true,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 16),
      bodyLarge: TextStyle(fontSize: 18),
      titleLarge: TextStyle(fontSize: 24),
    ).apply(fontSizeFactor: settings.fontSizeScale),
  );
});
