import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/keyboard/presentation/keyboard_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final box = Hive.box(AppConstants.settingsBox);
    final userLevel = box.get(AppConstants.userLevelKey);
    
    // If no user level is set, redirect to onboarding
    if (userLevel == null && state.uri.toString() != '/onboarding') {
      return '/onboarding';
    }
    
    // If onboarding is done but user tries to access it, go to home
    if (userLevel != null && state.uri.toString() == '/onboarding') {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/keyboard',
      builder: (context, state) => const KeyboardScreen(),
    ),
  ],
);
