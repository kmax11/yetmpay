import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:Yetmpay/app.dart';
import 'package:Yetmpay/core/strings/app_strings.dart';
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
}
