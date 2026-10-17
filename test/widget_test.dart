import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:yetpay/app.dart';
import 'package:yetpay/core/strings/app_strings.dart';
import 'package:yetpay/features/auth/auth_notifier.dart';
import 'package:yetpay/features/charging/payment_notifier.dart';
import 'package:yetpay/features/registration/registration_notifier.dart';
import 'package:yetpay/features/terminal/terminal_notifier.dart';

void main() {
  testWidgets('App smoke test - verifies GetStartedScreen renders',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthNotifier()),
          ChangeNotifierProvider(create: (_) => RegistrationNotifier()),
          ChangeNotifierProvider(create: (_) => TerminalNotifier()),
          ChangeNotifierProvider(create: (_) => PaymentNotifier()),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(AppStrings.getStarted), findsOneWidget);
    expect(find.text(AppStrings.tagline), findsOneWidget);
  });
}
