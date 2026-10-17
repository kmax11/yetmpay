import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/theme.dart';
import '../icons/app_icons.dart';
import '../strings/app_strings.dart';

/// Shell scaffold with a bottom navigation bar for the Terminal/Charging tabs.
///
/// Used inside a [StatefulShellRoute] — receives the [StatefulNavigationShell]
/// to switch between branches.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _tabs = [
    (icon: AppIcons.terminal, label: AppStrings.tabTerminal),
    (icon: AppIcons.transactions, label: AppStrings.tabTransactions),
    (icon: AppIcons.settings, label: AppStrings.tabSettings),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}

