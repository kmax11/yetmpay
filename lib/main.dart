import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'features/auth/auth_notifier.dart';
import 'features/charging/payment_notifier.dart';
import 'features/registration/registration_notifier.dart';
import 'features/terminal/terminal_notifier.dart';
import 'features/transactions/transaction_notifier.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
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
}
