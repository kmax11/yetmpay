import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:Yetmpay/app.dart';
import 'package:Yetmpay/core/strings/app_strings.dart';
import 'package:Yetmpay/core/widgets/app_back_button.dart';
import 'package:Yetmpay/features/auth/auth_notifier.dart';
import 'package:Yetmpay/features/charging/payment_notifier.dart';
import 'package:Yetmpay/features/registration/registration_notifier.dart';
import 'package:Yetmpay/features/terminal/terminal_notifier.dart';
import 'package:Yetmpay/features/transactions/transaction_notifier.dart';

void main() {
  testWidgets('App smoke test - verifies GetStartedScreen renders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthNotifier()),
          ChangeNotifierProvider(create: (_) => RegistrationNotifier()),
          ChangeNotifierProvider(create: (_) => TerminalNotifier()),
          ChangeNotifierProvider(create: (_) => PaymentNotifier()),
          ChangeNotifierProvider(create: (_) => TransactionNotifier()),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(AppStrings.getStarted), findsOneWidget);
    expect(find.text(AppStrings.tagline), findsOneWidget);
  });

  group('AppBackButton', () {
    testWidgets('falls back to fallbackLocation without crashing when stack cannot pop', (
      WidgetTester tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/details',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const Scaffold(body: Text('Home Page')),
          ),
          GoRoute(
            path: '/details',
            builder: (_, __) => const Scaffold(
              body: AppBackButton(fallbackLocation: '/'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppBackButton), findsOneWidget);

      // Tapping back button when canPop is false should not throw
      // "You have popped the last page off of the stack" assertion.
      await tester.tap(find.byType(AppBackButton));
      await tester.pumpAndSettle();

      expect(find.text('Home Page'), findsOneWidget);
    });

    testWidgets('pops normally when a previous page exists on stack', (
      WidgetTester tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, _) => Scaffold(
              body: ElevatedButton(
                onPressed: () => context.push('/subpage'),
                child: const Text('Push'),
              ),
            ),
          ),
          GoRoute(
            path: '/subpage',
            builder: (_, __) => const Scaffold(
              body: AppBackButton(fallbackLocation: '/other'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      // Push /subpage
      await tester.tap(find.text('Push'));
      await tester.pumpAndSettle();

      expect(find.byType(AppBackButton), findsOneWidget);

      // Tap back button - should pop back to /
      await tester.tap(find.byType(AppBackButton));
      await tester.pumpAndSettle();

      expect(find.text('Push'), findsOneWidget);
    });

    testWidgets('executes custom onPressed when provided', (
      WidgetTester tester,
    ) async {
      var pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppBackButton(
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(AppBackButton));
      expect(pressed, isTrue);
    });
  });
}
