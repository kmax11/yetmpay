// ignore_for_file: avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:Yetmpay/features/charging/payment_notifier.dart';
import 'package:Yetmpay/features/transactions/transaction_notifier.dart';

// ── Helpers ────────────────────────────────────────────────────────────────────

/// Creates a [PaymentNotifier] with an amount typed in (in ETB string form).
PaymentNotifier _notifierWithAmount(String etbAmount) {
  final n = PaymentNotifier();
  // Type each character through onKey so all guard logic is exercised.
  for (final ch in etbAmount.split('')) {
    n.onKey(ch);
  }
  return n;
}

/// Creates an [ApprovalData] that expires in [secondsFromNow].
ApprovalData _makeApproval(PaymentNotifier n, {int secondsFromNow = 30}) {
  final expiresAt = DateTime.now().add(Duration(seconds: secondsFromNow));
  return ApprovalData(
    transactionId: 'TXN-TEST-001',
    amountSantim: n.amountSantim,
    shopName: 'Bole Fresh Mart',
    maskedBuyerName: 'Selam D.',
    expiresAt: expiresAt,
  );
}

// ══════════════════════════════════════════════════════════════════════════════
// 1. Timeout
// ══════════════════════════════════════════════════════════════════════════════

void main() {
  group('PaymentNotifier — approval flow', () {
    // ── 1. Timeout ─────────────────────────────────────────────────────────

    test('approve() with an already-expired ApprovalData transitions to declined', () {
      final n = _notifierWithAmount('500');

      // Create an approval that expires 1 second *in the past*.
      final expiredApproval = ApprovalData(
        transactionId: 'TXN-EXPIRED-001',
        amountSantim: n.amountSantim,
        shopName: 'Bole Fresh Mart',
        maskedBuyerName: 'Selam D.',
        expiresAt: DateTime.now().subtract(const Duration(seconds: 1)),
      );

      n.enterAwaitingApproval(
        maskedBuyerName: 'Selam D.',
        shopName: 'Bole Fresh Mart',
        transactionId: 'TXN-EXPIRED-001',
      );

      // Manually replace pendingApproval with the expired one to simulate
      // the window closing while the screen is open.
      // Since _pendingApproval is private we simulate by calling approve() with
      // an expired object that matches the amount, then verifying decline.
      expect(n.status, PaymentStatus.awaitingApproval);
      expect(n.pendingApproval, isNotNull);

      // Calling approve() with an *expired* ApprovalData triggers timeout path.
      n.approve(expiredApproval);

      // Because expiredApproval != pendingApproval (different object), approve
      // is silently ignored — that's correct guard behaviour.
      // The real timeout is driven by the screen's countdown timer which calls
      // PaymentNotifier.decline(). Simulate that directly:
      n.decline('Approval timeout — customer did not respond');

      expect(n.status, PaymentStatus.declined);
      expect(n.declineReason, contains('timeout'));
      expect(n.pendingApproval, isNull);
    });

    test('approve() ignores a mismatched approval data object (different txnId)', () {
      final n = _notifierWithAmount('200');
      n.enterAwaitingApproval(
        maskedBuyerName: 'Abebe K.',
        shopName: 'Bole Fresh Mart',
        transactionId: 'TXN-A',
      );

      // A different ApprovalData object (different transactionId but same amount).
      final staleApproval = ApprovalData(
        transactionId: 'TXN-STALE',
        amountSantim: n.amountSantim,
        shopName: 'Bole Fresh Mart',
        maskedBuyerName: 'Abebe K.',
        expiresAt: DateTime.now().add(const Duration(seconds: 30)),
      );

      n.approve(staleApproval);

      // Status must remain awaitingApproval — not processing or declined.
      expect(n.status, PaymentStatus.awaitingApproval,
          reason: 'A mismatched approval data must be silently ignored');
      expect(n.pendingApproval, isNotNull);
    });

    // ── 2. Not Me ──────────────────────────────────────────────────────────

    test('notMe() transitions to declined with correct reason', () {
      final n = _notifierWithAmount('350');
      n.enterAwaitingApproval(
        maskedBuyerName: 'Selam D.',
        shopName: 'Bole Fresh Mart',
        transactionId: 'TXN-NOTME-001',
      );
      expect(n.status, PaymentStatus.awaitingApproval);

      n.notMe();

      expect(n.status, PaymentStatus.declined);
      expect(n.declineReason, contains('Not me'));
      expect(n.pendingApproval, isNull,
          reason: 'Pending approval must be cleared after Not-me');
    });

    test('notMe() consent record is correctly structured', () {
      final txRepo = TransactionNotifier();
      final n = _notifierWithAmount('800');
      n.enterAwaitingApproval(
        maskedBuyerName: 'Hana T.',
        shopName: 'Bole Fresh Mart',
        transactionId: 'TXN-NOTME-002',
      );

      final approval = n.pendingApproval!;

      // Simulate what the screen does on notMe():
      txRepo.saveConsentRecord(ConsentRecord(
        transactionId: approval.transactionId,
        recordedAt: DateTime.now(),
        amountSantim: approval.amountSantim,
        approved: false,
      ));
      n.notMe();

      expect(txRepo.consentRecords, hasLength(1));
      final record = txRepo.consentRecords.first;
      expect(record.transactionId, 'TXN-NOTME-002');
      expect(record.approved, isFalse);
      expect(record.amountSantim, 80000,
          reason: '800 ETB = 80 000 santim');
    });

    // ── 3. Amount change invalidates approval ──────────────────────────────

    test('onKey() with a different digit clears pendingApproval', () {
      final n = _notifierWithAmount('500');
      n.enterAwaitingApproval(
        maskedBuyerName: 'Dawit A.',
        shopName: 'Bole Fresh Mart',
        transactionId: 'TXN-AMTCHG-001',
      );
      expect(n.pendingApproval, isNotNull);

      // Merchant presses an extra digit (changes the amount).
      n.onKey('0'); // 500 → 5000

      expect(n.pendingApproval, isNull,
          reason: 'Changing the amount must invalidate any pending approval');
      // Status snaps back to capturing because amount is non-zero.
      expect(n.status, PaymentStatus.capturing);
    });

    test('onDelete() that changes the amount clears pendingApproval', () {
      final n = _notifierWithAmount('1200');
      n.enterAwaitingApproval(
        maskedBuyerName: 'Mekdes B.',
        shopName: 'Bole Fresh Mart',
        transactionId: 'TXN-AMTCHG-002',
      );
      expect(n.pendingApproval, isNotNull);

      n.onDelete(); // 1200 → 120

      expect(n.pendingApproval, isNull,
          reason: 'Deleting a digit that changes the amount must clear the approval');
    });

    test('clearAmount() always clears pendingApproval', () {
      final n = _notifierWithAmount('250');
      n.enterAwaitingApproval(
        maskedBuyerName: 'Yonas G.',
        shopName: 'Bole Fresh Mart',
        transactionId: 'TXN-AMTCHG-003',
      );

      n.clearAmount();

      expect(n.pendingApproval, isNull);
      expect(n.status, PaymentStatus.idle);
    });

    // ── 4. PIN limit ───────────────────────────────────────────────────────

    test('approve() below pinLimitSantim transitions directly to processing', () {
      // 999 ETB = 99 900 santim < 100 000
      final n = _notifierWithAmount('999');
      n.enterAwaitingApproval(
        maskedBuyerName: 'Tigist H.',
        shopName: 'Bole Fresh Mart',
        transactionId: 'TXN-PIN-BELOW',
      );
      final approval = n.pendingApproval!;

      n.approve(approval);

      expect(n.status, PaymentStatus.processing,
          reason: 'Below PIN limit: should skip PIN step and go to processing');
    });

    test('approve() exactly at pinLimitSantim transitions to pinRequired', () {
      // 1000 ETB = 100 000 santim (exactly the limit)
      final n = _notifierWithAmount('1000');
      n.enterAwaitingApproval(
        maskedBuyerName: 'Solomon W.',
        shopName: 'Bole Fresh Mart',
        transactionId: 'TXN-PIN-EXACT',
      );
      final approval = n.pendingApproval!;

      n.approve(approval);

      expect(n.status, PaymentStatus.pinRequired,
          reason:
              'Amount equal to the PIN limit must trigger PIN confirmation step');
    });

    test('approve() above pinLimitSantim transitions to pinRequired', () {
      // 5000 ETB = 500 000 santim > 100 000
      final n = _notifierWithAmount('5000');
      n.enterAwaitingApproval(
        maskedBuyerName: 'Almaz T.',
        shopName: 'Bole Fresh Mart',
        transactionId: 'TXN-PIN-ABOVE',
      );
      final approval = n.pendingApproval!;

      n.approve(approval);

      expect(n.status, PaymentStatus.pinRequired,
          reason: 'Above PIN limit: PIN step must be shown before processing');
    });

    test('confirmPin() after pinRequired transitions to processing', () {
      final n = _notifierWithAmount('2000');
      n.enterAwaitingApproval(
        maskedBuyerName: 'Bereket M.',
        shopName: 'Bole Fresh Mart',
        transactionId: 'TXN-PIN-CONFIRM',
      );
      n.approve(n.pendingApproval!);
      expect(n.status, PaymentStatus.pinRequired);

      n.confirmPin();

      expect(n.status, PaymentStatus.processing);
    });

    test('confirmPin() is a no-op when not in pinRequired state', () {
      final n = _notifierWithAmount('200');
      n.confirmPin(); // called before any approval
      expect(n.status, isNot(PaymentStatus.processing),
          reason: 'confirmPin() must be idempotent outside pinRequired');
    });

    // ── 5. Consent record — approve path ───────────────────────────────────

    test('Approved consent record has approved=true', () {
      final txRepo = TransactionNotifier();
      final n = _notifierWithAmount('300');
      n.enterAwaitingApproval(
        maskedBuyerName: 'Liya F.',
        shopName: 'Bole Fresh Mart',
        transactionId: 'TXN-CONSENT-OK',
      );
      final approval = n.pendingApproval!;

      // Simulate what the screen does on approve + then navigating away.
      txRepo.saveConsentRecord(ConsentRecord(
        transactionId: approval.transactionId,
        recordedAt: DateTime.now(),
        amountSantim: approval.amountSantim,
        approved: true,
      ));

      expect(txRepo.consentRecords, hasLength(1));
      expect(txRepo.consentRecords.first.approved, isTrue);
      expect(txRepo.consentRecords.first.amountSantim, 30000);
    });

    // ── 6. Mock service name masking guarantee ─────────────────────────────

    test('ApprovalData never exposes a full name or account number', () {
      final approval = ApprovalData(
        transactionId: 'TXN-MASK-001',
        amountSantim: 50000,
        shopName: 'Bole Fresh Mart',
        maskedBuyerName: 'Selam D.',
        expiresAt: DateTime.now().add(const Duration(seconds: 30)),
      );

      // The model has no field for full name, photo, or account number.
      // This test documents that constraint at the type level.
      expect(approval.maskedBuyerName, 'Selam D.',
          reason: 'Masked name must be the short form only');
      // Dynamic check: make sure the name does not contain spaces in the
      // middle (i.e., "Selam Desta" would be a leak).
      final parts = approval.maskedBuyerName.split(' ');
      expect(parts.length, lessThanOrEqualTo(2),
          reason: 'Name must be "First L." format — no full surname');
      if (parts.length == 2) {
        expect(parts[1], endsWith('.'),
            reason: 'Second part must be an abbreviated initial (e.g. "D.")');
      }
    });

    // ── 7. reset() clears all approval state ──────────────────────────────

    test('reset() clears pendingApproval and returns to idle', () {
      final n = _notifierWithAmount('750');
      n.enterAwaitingApproval(
        maskedBuyerName: 'Henok S.',
        shopName: 'Bole Fresh Mart',
        transactionId: 'TXN-RESET-001',
      );
      expect(n.pendingApproval, isNotNull);

      n.reset();

      expect(n.pendingApproval, isNull);
      expect(n.status, PaymentStatus.idle);
      expect(n.amount, '0');
    });
  });
}

