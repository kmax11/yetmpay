import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme.dart';

/// Root application widget configuring MaterialApp.router and light theme.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'YETMPAY',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
