import 'package:flutter/foundation.dart';

// ── Approval data ──────────────────────────────────────────────────────────────

/// Immutable snapshot attached to the [awaitingApproval] state.
///
/// [amountSantim] is the transaction value in Ethiopian santim (1 ETB = 100).
/// [maskedBuyerName] is returned by the mock biometric service (e.g. "Selam D.").
/// Never contains a photo, full name, or account number.
@immutable
class ApprovalData {
  const ApprovalData({
    required this.transactionId,
    required this.amountSantim,
    required this.shopName,
    required this.maskedBuyerName,
    required this.expiresAt,
  });

  final String transactionId;
  final int amountSantim;
  final String shopName;
  final String maskedBuyerName;
  final DateTime expiresAt;

  double get amountEtb => amountSantim / 100.0;

  /// True if this approval window is still open.
  bool get isValid => DateTime.now().isBefore(expiresAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApprovalData &&
          transactionId == other.transactionId &&
          amountSantim == other.amountSantim;

  @override
  int get hashCode => Object.hash(transactionId, amountSantim);
}

// ── Consent record ─────────────────────────────────────────────────────────────

/// Written to the transaction repository after a buyer approves or rejects.
/// Never includes a face image.
@immutable
class ConsentRecord {
  const ConsentRecord({
    required this.transactionId,
    required this.recordedAt,
    required this.amountSantim,
    required this.approved,
  });

  final String transactionId;
  final DateTime recordedAt;
  final int amountSantim;
  final bool approved;

  Map<String, dynamic> toJson() => {
        'transaction_id': transactionId,
        'recorded_at': recordedAt.toIso8601String(),
        'amount_santim': amountSantim,
        'approved': approved,
      };
}

// ── Payment states ─────────────────────────────────────────────────────────────

/// Full lifecycle of a payment, including the customer-approval step.
///
/// Flow:
///   capturing → verifying → awaitingApproval
///     → (pinRequired if amount ≥ [PaymentNotifier.pinLimitSantim])
///     → processing → success | declined
enum PaymentStatus {
  /// Merchant is typing the amount on the keypad.
  idle,
  /// Amount has been entered; ready to scan.
  capturing,
  /// Face scan is in progress.
  verifying,
  /// Biometric matched; waiting for the customer to tap Approve on their phone.
  awaitingApproval,
  /// Amount is above the high-value limit; PIN entry required before processing.
  pinRequired,
  /// Ledger is settling; do not navigate away.
  processing,
  /// Transaction completed and settled.
  success,
  /// Transaction rejected by bank, timeout, or customer "Not me".
  declined,
  /// OTP challenge issued (fallback path).
  otpNeeded,
}

// ── Notifier ───────────────────────────────────────────────────────────────────

/// Manages amount entry, rail selection, and the full payment state machine.
class PaymentNotifier extends ChangeNotifier {
  /// Transactions above this amount (in santim) require PIN confirmation.
  /// Default: 100 000 santim = 1 000 ETB.
  static const int pinLimitSantim = 100000;

  /// Approval window duration before auto-cancel.
  static const Duration approvalTimeout = Duration(seconds: 30);

  // ── Private state ────────────────────────────────────────────────────────────

  PaymentStatus _status = PaymentStatus.idle;
  String _amount = '0';
  int _selectedRailIndex = 0;
  String? _declineReason;
  String _recipientPhone = '91 450 8821';
  ApprovalData? _pendingApproval;

  // ── Public getters ───────────────────────────────────────────────────────────

  PaymentStatus get status => _status;
  String get amount => _amount;
  int get selectedRailIndex => _selectedRailIndex;
  String? get declineReason => _declineReason;
  String get recipientPhone => _recipientPhone;

  /// Non-null only while status is [PaymentStatus.awaitingApproval] or
  /// [PaymentStatus.pinRequired].
  ApprovalData? get pendingApproval => _pendingApproval;

  static const List<String> railNames = [
    'Telebirr SuperApp',
    'CBE Birr',
    'Awash Bank',
    'Amole',
  ];

  String get selectedRailName {
    if (_selectedRailIndex >= 0 && _selectedRailIndex < railNames.length) {
      return railNames[_selectedRailIndex];
    }
    return 'Telebirr SuperApp';
  }

  double get numericAmount => double.tryParse(_amount) ?? 0.0;

  /// Amount in santim (int), used for approval comparisons.
  int get amountSantim => (numericAmount * 100).round();

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

  // ── Keypad input ─────────────────────────────────────────────────────────────

  void onKey(String key) {
    if (key == '.') {
      if (_amount.contains('.')) return;
      _amount = '$_amount.';
    } else {
      if (_amount.contains('.')) {
        final decimals = _amount.split('.')[1];
        if (decimals.length >= 2) return;
      }
      final wholePart = _amount.split('.')[0];
      if (!_amount.contains('.') && wholePart.length >= 8) return;

      if (_amount == '0') {
        _amount = key;
      } else {
        _amount = '$_amount$key';
      }
    }
    // If merchant changes the amount while an approval is pending, clear it.
    _invalidateApprovalIfAmountChanged();
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
    _invalidateApprovalIfAmountChanged();
    notifyListeners();
  }

  void clearAmount() {
    _amount = '0';
    _status = PaymentStatus.idle;
    _pendingApproval = null;
    notifyListeners();
  }

  // ── Rail selection ───────────────────────────────────────────────────────────

  void selectRail(int index) {
    _selectedRailIndex = index;
    notifyListeners();
  }

  // ── State machine ────────────────────────────────────────────────────────────

  /// Start face scan verification.
  void startVerifying() {
    _status = PaymentStatus.verifying;
    notifyListeners();
  }

  /// Called by the face-scan screen once biometrics pass.
  ///
  /// The mock service returns only a masked buyer name (e.g. "Selam D.") —
  /// never a full name, photo, or account number.
  ///
  /// If the amount changed since any prior approval was created (e.g. user
  /// went back to charging), the old approval is cleared automatically.
  void enterAwaitingApproval({
    required String maskedBuyerName,
    required String shopName,
    required String transactionId,
  }) {
    final expiresAt = DateTime.now().add(approvalTimeout);
    _pendingApproval = ApprovalData(
      transactionId: transactionId,
      amountSantim: amountSantim,
      shopName: shopName,
      maskedBuyerName: maskedBuyerName,
      expiresAt: expiresAt,
    );
    _status = PaymentStatus.awaitingApproval;
    notifyListeners();
  }

  /// Customer tapped "Approve" on the approval screen.
  ///
  /// If the amount is above [pinLimitSantim], transitions to [pinRequired].
  /// Otherwise goes directly to [processing].
  ///
  /// [approvalData] must match [pendingApproval] — if it does not (amount
  /// changed or different transaction id), the call is silently ignored.
  void approve(ApprovalData approvalData) {
    if (_pendingApproval != approvalData) return;
    if (!approvalData.isValid) {
      _cancelDueToTimeout();
      return;
    }

    if (approvalData.amountSantim >= pinLimitSantim) {
      _status = PaymentStatus.pinRequired;
    } else {
      _status = PaymentStatus.processing;
    }
    notifyListeners();
  }

  /// PIN was confirmed on the PIN screen; proceed to processing.
  void confirmPin() {
    if (_status != PaymentStatus.pinRequired) return;
    _status = PaymentStatus.processing;
    notifyListeners();
  }

  /// Customer tapped "Not me" — cancel and return to terminal.
  ///
  /// Logs a rejected consent record (done via callback passed by the screen
  /// so the notifier does not depend on TransactionNotifier).
  void notMe() {
    _declineReason = 'Customer rejected: Not me';
    _pendingApproval = null;
    _status = PaymentStatus.declined;
    notifyListeners();
  }

  /// Approval window expired; auto-cancel.
  void _cancelDueToTimeout() {
    _declineReason = 'Approval timeout — customer did not respond';
    _pendingApproval = null;
    _status = PaymentStatus.declined;
    notifyListeners();
  }

  /// If the merchant edits the amount while an approval is pending,
  /// that approval is invalidated.
  void _invalidateApprovalIfAmountChanged() {
    if (_pendingApproval != null &&
        _pendingApproval!.amountSantim != amountSantim) {
      _pendingApproval = null;
    }
  }

  /// Simulate biometric verification → processing → success/declined.
  Future<void> processPayment() async {
    _status = PaymentStatus.processing;
    notifyListeners();

    await Future<void>.delayed(const Duration(seconds: 2));

    _status = PaymentStatus.success;
    notifyListeners();
  }

  void markSuccess() {
    _pendingApproval = null;
    _status = PaymentStatus.success;
    notifyListeners();
  }

  void decline(String reason) {
    _declineReason = reason;
    _pendingApproval = null;
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
    _pendingApproval = null;
    notifyListeners();
  }
}
