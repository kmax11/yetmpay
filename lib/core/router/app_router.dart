import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/approval/approval_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/charging/charging_screen.dart';
import '../../features/face_scan/face_scan_screen.dart';
import '../../features/face_scan/payment_declined_screen.dart';
import '../../features/face_scan/payment_processing_screen.dart';
import '../../features/face_scan/payment_success_screen.dart';
import '../../features/onboarding/get_started_screen.dart';
import '../../features/registration/link_bank_screen.dart';
import '../../features/registration/merchant_registration_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/terminal/terminal_screen.dart';
import '../../features/transactions/transactions_screen.dart';
import '../widgets/app_bottom_nav_bar.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// App Router configuration with StatefulShellRoute and top-level biometric flows.
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

      // ── Top-Level Payment & Biometric Scanning Routes ───────────────────
      GoRoute(
        path: '/charging',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ChargingScreen(),
      ),
      GoRoute(
        path: '/face-scan',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const FaceScanScreen(),
      ),
      GoRoute(
        path: '/payment-processing',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PaymentProcessingScreen(),
      ),
      GoRoute(
        path: '/payment-success',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PaymentSuccessScreen(),
      ),
      GoRoute(
        path: '/payment-declined',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const PaymentDeclinedScreen(),
      ),
      GoRoute(
        path: '/approval',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ApprovalScreen(),
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
          // Branch 1: Transactions
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (context, state) => const TransactionsScreen(),
              ),
            ],
          ),
          // Branch 2: Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
