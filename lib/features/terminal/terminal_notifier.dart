import 'package:flutter/foundation.dart';

/// Terminal / merchant state shown on the Terminal screen.
class TerminalNotifier extends ChangeNotifier {
  // ── Demo merchant data ─────────────────────────────────────────────────────
  final String merchantName = 'Bole Fresh Mart';
  final String merchantLocation = 'Addis Ababa, Bole Sub-City';
  final String terminalId = 'YM-004821';
  final String terminalNumber = 'Merchant Terminal #04';
  final String payoutRail = 'Telebirr Instant';
  final String payoutPhone = '+251 91 ••• 8821';
  final String merchantInitials = 'BM';

  bool _isOnline = true;
  final double _todaySettled = 14820.00;
  final int _settledSales = 38;
  bool _idCopied = false;

  bool get isOnline => _isOnline;
  double get todaySettled => _todaySettled;
  int get settledSales => _settledSales;
  bool get idCopied => _idCopied;

  void copyTerminalId() {
    _idCopied = true;
    notifyListeners();
    Future<void>.delayed(const Duration(seconds: 2), () {
      _idCopied = false;
      notifyListeners();
    });
  }

  void setOnline(bool v) {
    _isOnline = v;
    notifyListeners();
  }
}

