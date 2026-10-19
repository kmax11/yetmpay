import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/icons/app_icons.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/app_text_link_button.dart';
import '../charging/payment_notifier.dart';
import '../terminal/terminal_notifier.dart';
import '../transactions/transaction_notifier.dart';

/// Approval Screen — shown to the merchant after a successful biometric scan.
///
/// Displays: shop name, amount, masked buyer name (e.g. "Selam D."),
/// a live countdown timer, an Approve button, and a "Not me" button.
///
/// On approval → [PaymentStatus.processing] → `/payment-success`
/// On "Not me" → [PaymentStatus.declined] → `/terminal`
/// On timeout  → [PaymentStatus.declined] → `/terminal`
///
/// If the amount is ≥ [PaymentNotifier.pinLimitSantim], approval triggers
/// [PaymentStatus.pinRequired] and the PIN overlay is shown in-place.
class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen>
    with SingleTickerProviderStateMixin {
  Timer? _countdownTimer;
  int _secondsLeft = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // PIN entry state (shown when pinRequired)
  final List<String> _pin = [];
  static const int _pinLength = 4;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _startCountdown());
  }

  void _startCountdown() {
    final approval =
        context.read<PaymentNotifier>().pendingApproval;
    if (approval == null) {
      _returnToTerminal();
      return;
    }

    final remaining =
        approval.expiresAt.difference(DateTime.now()).inSeconds.clamp(0, 9999);
    setState(() => _secondsLeft = remaining);

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      final payment = context.read<PaymentNotifier>();
      if (payment.status != PaymentStatus.awaitingApproval &&
          payment.status != PaymentStatus.pinRequired) {
        t.cancel();
        return;
      }
      setState(() {
        _secondsLeft = (_secondsLeft - 1).clamp(0, 9999);
      });
      if (_secondsLeft <= 0) {
        t.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    final payment = context.read<PaymentNotifier>();
    final approval = payment.pendingApproval;
    if (approval != null) {
      context.read<TransactionNotifier>().saveConsentRecord(
            ConsentRecord(
              transactionId: approval.transactionId,
              recordedAt: DateTime.now(),
              amountSantim: approval.amountSantim,
              approved: false,
            ),
          );
    }
    payment.decline(AppStrings.approvalTimedOut);
    _returnToTerminal();
  }

  void _handleApprove() {
    final payment = context.read<PaymentNotifier>();
    final approval = payment.pendingApproval;
    if (approval == null) return;

    // Save consent record before transitioning.
    context.read<TransactionNotifier>().saveConsentRecord(
          ConsentRecord(
            transactionId: approval.transactionId,
            recordedAt: DateTime.now(),
            amountSantim: approval.amountSantim,
            approved: true,
          ),
        );

    payment.approve(approval);
    // If pin is now required, the build method shows the PIN overlay;
    // otherwise navigate to processing.
    if (payment.status == PaymentStatus.processing) {
      _navigateToProcessing(payment, approval);
    }
    // pinRequired → widget rebuilds showing PIN entry.
  }

  void _handleNotMe() {
    final payment = context.read<PaymentNotifier>();
    final approval = payment.pendingApproval;
    if (approval != null) {
      context.read<TransactionNotifier>().saveConsentRecord(
            ConsentRecord(
              transactionId: approval.transactionId,
              recordedAt: DateTime.now(),
              amountSantim: approval.amountSantim,
              approved: false,
            ),
          );
    }
    payment.notMe();
    _returnToTerminal();
  }

  void _handlePinKey(String digit) {
    if (_pin.length >= _pinLength) return;
    setState(() => _pin.add(digit));
    HapticFeedback.selectionClick();
  }

  void _handlePinDelete() {
    if (_pin.isEmpty) return;
    setState(() => _pin.removeLast());
  }

  void _handlePinConfirm() {
    if (_pin.length < _pinLength) return;
    final payment = context.read<PaymentNotifier>();
    final approval = payment.pendingApproval;
    payment.confirmPin();
    if (payment.status == PaymentStatus.processing && approval != null) {
      _navigateToProcessing(payment, approval);
    }
  }

  void _navigateToProcessing(PaymentNotifier payment, ApprovalData approval) {
    _countdownTimer?.cancel();
    // Record the transaction and navigate.
    final amount = approval.amountSantim / 100.0;
    final rail = payment.selectedRailName;
    final phone = payment.recipientPhone;
    payment.markSuccess();
    context.read<TransactionNotifier>().recordTransaction(
          amount: amount,
          rail: rail,
          customerName: approval.maskedBuyerName,
          maskedAccount: phone.isNotEmpty ? '+251 $phone' : '+251 91 ••• 8821',
          channel: '$rail Biometric Face',
        );
    context.read<TerminalNotifier>().recordSettledSale(amount);
    context.go('/payment-success');
  }

  void _returnToTerminal() {
    _countdownTimer?.cancel();
    if (mounted) context.go('/terminal');
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final payment = context.watch<PaymentNotifier>();
    final approval = payment.pendingApproval;

    if (approval == null) {
      // Approval was cleared (e.g. amount changed) — go back.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _returnToTerminal(),
      );
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isPinRequired = payment.status == PaymentStatus.pinRequired;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadH,
            vertical: AppSpacing.md,
          ),
          child: isPinRequired
              ? _buildPinView(approval)
              : _buildApprovalView(approval),
        ),
      ),
    );
  }

  // ── Approval view ──────────────────────────────────────────────────────────

  Widget _buildApprovalView(ApprovalData approval) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),

        // ── Header ──────────────────────────────────────────────────────────
        Center(
          child: ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen10,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryGreen.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                AppIcons.shieldCheck,
                size: 36,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        Center(
          child: Text(
            AppStrings.approvalTitle,
            style: AppTextStyles.heading1.copyWith(color: AppColors.darkText),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Center(
          child: _CountdownPill(secondsLeft: _secondsLeft),
        ),
        const SizedBox(height: AppSpacing.xxxl),

        // ── Detail Card ──────────────────────────────────────────────────────
        AppCard(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            children: [
              _buildDetailRow(
                label: AppStrings.approvalShopLabel,
                value: approval.shopName,
                valueStyle: AppTextStyles.semiBoldMedium
                    .copyWith(color: AppColors.darkText),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Divider(color: AppColors.divider, height: 1),
              ),
              _buildDetailRow(
                label: AppStrings.approvalAmountLabel,
                value: '${_formatAmount(approval.amountEtb)} ETB',
                valueStyle: AppTextStyles.heading2.copyWith(
                  color: AppColors.primaryGreen,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Divider(color: AppColors.divider, height: 1),
              ),
              _buildDetailRow(
                label: AppStrings.approvalBuyerLabel,
                value: approval.maskedBuyerName,
                valueStyle: AppTextStyles.semiBoldMedium
                    .copyWith(color: AppColors.darkText),
                trailingIcon: AppIcons.checkCircle,
                trailingColor: AppColors.railGreen,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // ── Approve Button ───────────────────────────────────────────────────
        AppPrimaryButton(
          label: AppStrings.approvalApproveBtn,
          trailingIcon: AppIcons.arrowRight,
          onPressed: _handleApprove,
        ),
        const SizedBox(height: AppSpacing.md),

        // ── Not Me Button ────────────────────────────────────────────────────
        OutlinedButton(
          onPressed: _handleNotMe,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.errorRed,
            backgroundColor: AppColors.white,
            side: const BorderSide(color: AppColors.errorRedBorder),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.buttonPrimaryBR,
            ),
            minimumSize: const Size(double.infinity, 52),
          ),
          child: Text(
            AppStrings.approvalNotMeBtn,
            style: AppTextStyles.semiBoldLarge
                .copyWith(color: AppColors.errorRed),
          ),
        ),

        const Spacer(),

        // ── Privacy Note ─────────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(AppIcons.lock, size: 13, color: AppColors.mutedText),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                AppStrings.approvalPrivacyNote,
                style: AppTextStyles.bodyXXS.copyWith(
                  color: AppColors.mutedText,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  // ── PIN view ───────────────────────────────────────────────────────────────

  Widget _buildPinView(ApprovalData approval) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),

        Center(
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen10,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              AppIcons.lock,
              size: 28,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        Center(
          child: Text(
            AppStrings.approvalPinTitle,
            style: AppTextStyles.heading1.copyWith(color: AppColors.darkText),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Center(
          child: Text(
            AppStrings.approvalPinSub,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mutedText),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // ── Amount reminder ──────────────────────────────────────────────────
        Center(
          child: Text(
            '${_formatAmount(approval.amountEtb)} ETB',
            style: AppTextStyles.headingXL
                .copyWith(color: AppColors.primaryGreen),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // ── PIN dots ─────────────────────────────────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_pinLength, (i) {
            final filled = i < _pin.length;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: filled ? AppColors.primaryGreen : AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: filled
                        ? AppColors.primaryGreen
                        : AppColors.borderDefault,
                    width: 1.5,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.xxxl),

        // ── PIN keypad ───────────────────────────────────────────────────────
        _buildPinKeypad(),
        const SizedBox(height: AppSpacing.xl),

        // ── Confirm ──────────────────────────────────────────────────────────
        AppPrimaryButton(
          label: AppStrings.approvalPinConfirm,
          onPressed: _pin.length == _pinLength ? _handlePinConfirm : null,
        ),
        const SizedBox(height: AppSpacing.sm),

        AppTextLinkButton(
          text: AppStrings.approvalPinCancel,
          onPressed: _handleNotMe,
        ),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildPinKeypad() {
    const keys = [
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      '',  '0', '<',
    ];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 2.4,
      children: keys.map((k) {
        if (k.isEmpty) return const SizedBox.shrink();
        if (k == '<') {
          return _PinKey(
            child: const Icon(AppIcons.backspace,
                size: 20, color: AppColors.subtleMuted),
            onTap: _handlePinDelete,
          );
        }
        return _PinKey(
          child: Text(k,
              style: AppTextStyles.heading2.copyWith(
                  color: AppColors.darkText)),
          onTap: () => _handlePinKey(k),
        );
      }).toList(),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _buildDetailRow({
    required String label,
    required String value,
    required TextStyle valueStyle,
    IconData? trailingIcon,
    Color? trailingColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.capsLabel.copyWith(
            color: AppColors.mutedText,
            fontSize: 10,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: valueStyle),
            if (trailingIcon != null) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(trailingIcon, size: 16, color: trailingColor),
            ],
          ],
        ),
      ],
    );
  }

  static String _formatAmount(double val) {
    final parts = val.toStringAsFixed(2).split('.');
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return '${parts[0].replaceAll(reg, ',')}.${parts[1]}';
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────────

class _CountdownPill extends StatelessWidget {
  const _CountdownPill({required this.secondsLeft});
  final int secondsLeft;

  @override
  Widget build(BuildContext context) {
    final isUrgent = secondsLeft <= 10;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isUrgent ? AppColors.errorRedBg : AppColors.railSuccessBg,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: isUrgent
              ? AppColors.errorRedBorder
              : AppColors.railGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            AppIcons.info,
            size: 13,
            color: isUrgent ? AppColors.errorRed : AppColors.railSuccessText,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '${AppStrings.approvalExpiresLabel} '
            '$secondsLeft'
            '${AppStrings.approvalSecondsSuffix}',
            style: AppTextStyles.labelSmall.copyWith(
              color:
                  isUrgent ? AppColors.errorRed : AppColors.railSuccessText,
            ),
          ),
        ],
      ),
    );
  }
}

class _PinKey extends StatelessWidget {
  const _PinKey({required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: AppRadius.inputBR,
      child: InkWell(
        borderRadius: AppRadius.inputBR,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.inputBR,
            border: Border.all(color: AppColors.borderDefault),
          ),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
