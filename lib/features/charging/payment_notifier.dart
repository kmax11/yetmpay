import 'package:flutter/foundation.dart';

/// Payment lifecycle states.
enum PaymentStatus {
  idle,
  capturing,
  verifying,
  processing,
  success,
  declined,
  otpNeeded,
}

/// Manages amount entry, rail selection, and the payment state machine.
class PaymentNotifier extends ChangeNotifier {
  PaymentStatus _status = PaymentStatus.idle;
  String _amount = '0';
  int _selectedRailIndex = 0;
  String? _declineReason;
  String _recipientPhone = '91 450 8821';

  PaymentStatus get status => _status;
  String get amount => _amount;
  int get selectedRailIndex => _selectedRailIndex;
  String? get declineReason => _declineReason;
  String get recipientPhone => _recipientPhone;

  void updateRecipientPhone(String v) {
    _recipientPhone = v;
    notifyListeners();
  }

  /// Formatted display amount (e.g. "1,250.00").
  String get displayAmount {
    final parsed = double.tryParse(_amount) ?? 0;
    if (parsed == 0) return '0.00';
    final parts = _amount.split('.');
    final whole = parts[0];
    final decimal = parts.length > 1 ? parts[1].padRight(2, '0') : '00';

    // Add comma separators to whole part.
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
      buffer.write(whole[i]);
    }
    return '$buffer.$decimal';
  }

  /// Whether a valid non-zero amount is entered.
  bool get hasAmount {
    final parsed = double.tryParse(_amount) ?? 0;
    return parsed > 0;
  }

  // ── Keypad input ─────────────────────────────────────────────────────────

  void onKey(String key) {
    if (key == '.') {
      if (_amount.contains('.')) return;
      _amount = '$_amount.';
    } else {
      // Max 2 decimal places.
      if (_amount.contains('.')) {
        final decimals = _amount.split('.')[1];
        if (decimals.length >= 2) return;
      }
      // Max 8 digits before decimal.
      final wholePart = _amount.split('.')[0];
      if (!_amount.contains('.') && wholePart.length >= 8) return;

      if (_amount == '0') {
        _amount = key;
      } else {
        _amount = '$_amount$key';
      }
    }
    _status = PaymentStatus.capturing;
    notifyListeners();
  }

  void onDelete() {
    if (_amount.length <= 1) {
      _amount = '0';
    } else {
      _amount = _amount.substring(0, _amount.length - 1);
    }
    if (_amount == '0') {
      _status = PaymentStatus.idle;
    }
    notifyListeners();
  }

  void clearAmount() {
    _amount = '0';
    _status = PaymentStatus.idle;
    notifyListeners();
  }

  // ── Rail selection ───────────────────────────────────────────────────────

  void selectRail(int index) {
    _selectedRailIndex = index;
    notifyListeners();
  }

  // ── State machine ────────────────────────────────────────────────────────

  /// Start face scan verification.
  void startVerifying() {
    _status = PaymentStatus.verifying;
    notifyListeners();
  }

  /// Simulate biometric verification → processing → success/declined.
  Future<void> processPayment() async {
    _status = PaymentStatus.processing;
    notifyListeners();

    await Future<void>.delayed(const Duration(seconds: 2));

    // Demo: always succeed.
    _status = PaymentStatus.success;
    notifyListeners();
  }

  void decline(String reason) {
    _declineReason = reason;
    _status = PaymentStatus.declined;
    notifyListeners();
  }

  void requestOtp() {
    _status = PaymentStatus.otpNeeded;
    notifyListeners();
  }

  /// Reset to idle for a new transaction.
  void reset() {
    _amount = '0';
    _status = PaymentStatus.idle;
    _declineReason = null;
    notifyListeners();
  }
}

