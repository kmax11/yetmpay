import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/icons/app_icons.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_card.dart';
import '../auth/auth_notifier.dart';
import '../terminal/terminal_notifier.dart';

/// Settings & Profile Screen (Figma node 4-489).
///
/// Branch 2 of the StatefulShellRoute navigation shell.
/// Manages settlement rails, terminal language/audio toggles, support escalation,
/// hardware security trust badges, and session logout.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isEnglish = true;
  bool _audioAnnouncement = true;
  bool _autoPromptReceipt = true;

  @override
  Widget build(BuildContext context) {
    final terminal = context.watch<TerminalNotifier>();
    final auth = context.read<AuthNotifier>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadH,
            vertical: AppSpacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Header Row ───────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppStrings.settingsTitle} POS-4082',
                        style: AppTextStyles.heading1.copyWith(
                          color: AppColors.darkText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        terminal.merchantName,
                        style: AppTextStyles.bodyXS.copyWith(
                          color: AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          AppIcons.notifications,
                          size: 20,
                          color: AppColors.subtleMuted,
                        ),
                        onPressed: () {},
                      ),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'Y',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Merchant Profile Card ────────────────────────────────────
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen10,
                            borderRadius: AppRadius.badgeAll,
                          ),
                          child: const Icon(
                            AppIcons.store,
                            color: AppColors.primaryGreen,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      terminal.merchantName,
                                      style: AppTextStyles.heading2.copyWith(
                                        color: AppColors.darkText,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.railSuccessBg,
                                      borderRadius: AppRadius.pillAll,
                                    ),
                                    child: Text(
                                      AppStrings.activePOS,
                                      style: AppTextStyles.semiBoldBadge.copyWith(
                                        color: AppColors.railSuccessText,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    AppIcons.locationPin,
                                    size: 13,
                                    color: AppColors.mutedText,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    terminal.merchantLocation,
                                    style: AppTextStyles.bodyXS.copyWith(
                                      color: AppColors.mutedText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Divider(color: AppColors.divider, height: 1),
                    const SizedBox(height: AppSpacing.sm),

                    // Terminal MID Chip with Copy
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: AppRadius.badgeSmallAll,
                            border: Border.all(color: AppColors.borderLight),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'MID ${terminal.terminalId}',
                                style: AppTextStyles.monoSmall.copyWith(
                                  color: AppColors.darkText,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              InkWell(
                                onTap: () {
                                  Clipboard.setData(
                                    ClipboardData(text: terminal.terminalId),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Terminal MID copied!'),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: const Icon(
                                  AppIcons.copy,
                                  size: 13,
                                  color: AppColors.subtleMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          terminal.terminalNumber,
                          style: AppTextStyles.bodyXXS.copyWith(
                            color: AppColors.mutedText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Section 1: Settlement & Rails ────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.settlementRailsSection,
                    style: AppTextStyles.capsLabelSemiBold.copyWith(
                      color: AppColors.subtleMuted,
                    ),
                  ),
                  Text(
                    AppStrings.realTimeRTGS,
                    style: AppTextStyles.bodyXXS.copyWith(
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: [
                    _buildSettingsRow(
                      title: AppStrings.payoutAccount,
                      subtitle: AppStrings.payoutAccountSub,
                      trailing: const Icon(
                        AppIcons.chevronRight,
                        size: 18,
                        color: AppColors.textPlaceholder,
                      ),
                      onTap: () {},
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    _buildSettingsRow(
                      title: AppStrings.connectedBanks,
                      subtitle: AppStrings.connectedBanksSub,
                      trailing: const Icon(
                        AppIcons.chevronRight,
                        size: 18,
                        color: AppColors.textPlaceholder,
                      ),
                      onTap: () {},
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    _buildSettingsRow(
                      title: AppStrings.transactionLimit,
                      subtitle: AppStrings.transactionLimitSub,
                      trailing: const Icon(
                        AppIcons.chevronRight,
                        size: 18,
                        color: AppColors.textPlaceholder,
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Section 2: Terminal Preferences ──────────────────────────
              Text(
                AppStrings.terminalPreferencesSection,
                style: AppTextStyles.capsLabelSemiBold.copyWith(
                  color: AppColors.subtleMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: [
                    _buildSettingsRow(
                      title: AppStrings.languageLabel,
                      subtitle: AppStrings.languageSub,
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppRadius.pillAll,
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _isEnglish = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _isEnglish
                                      ? AppColors.primaryGreen
                                      : Colors.transparent,
                                  borderRadius: AppRadius.pillAll,
                                ),
                                child: Text(
                                  AppStrings.langEnglish,
                                  style: AppTextStyles.semiBoldBadge.copyWith(
                                    color: _isEnglish
                                        ? AppColors.white
                                        : AppColors.mutedText,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _isEnglish = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: !_isEnglish
                                      ? AppColors.primaryGreen
                                      : Colors.transparent,
                                  borderRadius: AppRadius.pillAll,
                                ),
                                child: Text(
                                  AppStrings.langAmharic,
                                  style: AppTextStyles.semiBoldBadge.copyWith(
                                    color: !_isEnglish
                                        ? AppColors.white
                                        : AppColors.mutedText,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    _buildSettingsRow(
                      title: AppStrings.audioAnnouncement,
                      subtitle: AppStrings.audioAnnouncementSub,
                      trailing: Switch(
                        value: _audioAnnouncement,
                        activeTrackColor: AppColors.primaryGreen,
                        onChanged: (val) =>
                            setState(() => _audioAnnouncement = val),
                      ),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    _buildSettingsRow(
                      title: AppStrings.autoPromptReceipt,
                      subtitle: AppStrings.autoPromptReceiptSub,
                      trailing: Switch(
                        value: _autoPromptReceipt,
                        activeTrackColor: AppColors.primaryGreen,
                        onChanged: (val) =>
                            setState(() => _autoPromptReceipt = val),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Section 3: Support & Device Trust ────────────────────────
              Text(
                AppStrings.supportDeviceSection,
                style: AppTextStyles.capsLabelSemiBold.copyWith(
                  color: AppColors.subtleMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Column(
                  children: [
                    _buildSettingsRow(
                      title: AppStrings.helpMerchantSupport,
                      subtitle: AppStrings.helpMerchantSupportSub,
                      trailing: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Dialing toll-free 8821...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(AppIcons.call, size: 14),
                        label: Text(
                          AppStrings.callNow,
                          style: AppTextStyles.semiBoldBadge.copyWith(
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryGreen,
                          side: const BorderSide(color: AppColors.primaryGreen),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.pillAll,
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    _buildSettingsRow(
                      title: AppStrings.securityEncryption,
                      subtitle: AppStrings.securityEncryptionSub,
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.railSuccessBg,
                          borderRadius: AppRadius.pillAll,
                        ),
                        child: Text(
                          AppStrings.securityVerified,
                          style: AppTextStyles.semiBoldBadge.copyWith(
                            color: AppColors.railSuccessText,
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: AppColors.divider, height: 1),
                    _buildSettingsRow(
                      title: AppStrings.yetmpayPOSCore,
                      subtitle: AppStrings.posCoreSub,
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppRadius.pillAll,
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Text(
                          AppStrings.posCoreVersion,
                          style: AppTextStyles.monoSmall.copyWith(
                            fontSize: 10,
                            color: AppColors.mutedText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Logout Button ────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await auth.logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  icon: const Icon(
                    AppIcons.logout,
                    size: 18,
                    color: AppColors.errorRed,
                  ),
                  label: Text(
                    AppStrings.logOutTerminal,
                    style: AppTextStyles.semiBoldMedium.copyWith(
                      color: AppColors.errorRed,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.errorRedBorder),
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.buttonPrimaryAll,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              Center(
                child: Text(
                  AppStrings.logoutCaption,
                  style: AppTextStyles.bodyXXS.copyWith(
                    color: AppColors.slatePlaceholder,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsRow({
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.semiBoldMedium.copyWith(
                      color: AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyXS.copyWith(
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
