import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/login_screen.dart';
import '../../features/charging/charging_screen.dart';
import '../../features/face_scan/face_scan_screen.dart';
import '../../features/onboarding/get_started_screen.dart';
import '../../features/registration/link_bank_screen.dart';
import '../../features/registration/merchant_registration_screen.dart';
import '../../features/terminal/terminal_screen.dart';
import '../widgets/app_bottom_nav_bar.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// App Router configuration with StatefulShellRoute and top-level face-scan route.
abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // ── Root Onboarding & Registration Routes ───────────────────────────
      GoRoute(
        path: '/',
        builder: (context, state) => const GetStartedScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const MerchantRegistrationScreen(),
      ),
      GoRoute(
        path: '/register/link-bank',
        builder: (context, state) => const LinkBankScreen(),
      ),

      // ── Top-Level Face Scan Route (Covers Bottom Nav Bar) ────────────────
      GoRoute(
        path: '/face-scan',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const FaceScanScreen(),
      ),

      // ── Stateful Shell Route (Shared Bottom Nav Bar) ─────────────────────
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppBottomNavBar(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Terminal
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/terminal',
                builder: (context, state) => const TerminalScreen(),
              ),
            ],
          ),
          // Branch 1: Transactions / Charge
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/charging',
                builder: (context, state) => const ChargingScreen(),
              ),
            ],
          ),
          // Branch 2: Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const Scaffold(
                  body: Center(
                    child: Text('Settings'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

