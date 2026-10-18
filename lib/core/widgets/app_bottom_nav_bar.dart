import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../theme/theme.dart';
import '../icons/app_icons.dart';
import '../strings/app_strings.dart';

/// Shell scaffold with a bottom navigation bar for the Terminal/Charging tabs.
///
/// Wraps the shell in a [PopScope] that shows an exit-confirmation dialog
/// when the Android back button is pressed from any root tab.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    (icon: AppIcons.terminal, label: AppStrings.tabTerminal),
    (icon: AppIcons.transactions, label: AppStrings.tabTransactions),
    (icon: AppIcons.settings, label: AppStrings.tabSettings),
  ];

  Future<void> _onPopInvoked(BuildContext context, bool didPop) async {
    if (didPop) return;
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.cardLarge),
        ),
        backgroundColor: AppColors.white,
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen10,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                AppIcons.logout,
                color: AppColors.primaryGreen,
                size: 26,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Exit YETMpay?',
              style: AppTextStyles.heading2.copyWith(color: AppColors.darkText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'You will be logged out of the merchant\nterminal session.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.mutedText,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
        actions: [
          // Cancel
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.darkText,
                side: const BorderSide(color: AppColors.borderDefault),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.buttonPrimary),
                ),
              ),
              child: Text(
                'Stay',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.darkText),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Exit
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorRed,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.buttonPrimary),
                ),
              ),
              child: Text(
                'Exit & Logout',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldExit == true && context.mounted) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) => _onPopInvoked(context, didPop),
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            border: const Border(
              top: BorderSide(color: AppColors.borderLight),
            ),
            boxShadow: AppShadows.headerShadow,
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_tabs.length, (i) {
                  final isActive = navigationShell.currentIndex == i;
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => navigationShell.goBranch(
                      i,
                      initialLocation: i == navigationShell.currentIndex,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _tabs[i].icon,
                            size: 22,
                            color: isActive
                                ? AppColors.primaryGreen
                                : AppColors.mutedText,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            _tabs[i].label,
                            style: AppTextStyles.labelXXS.copyWith(
                              color: isActive
                                  ? AppColors.primaryGreen
                                  : AppColors.mutedText,
                              fontWeight:
                                  isActive ? FontWeight.w600 : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
