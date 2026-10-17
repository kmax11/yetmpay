import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/icons/app_icons.dart';
import '../../core/strings/app_strings.dart';
import '../../core/theme/theme.dart';
import '../../core/widgets/app_back_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_input_field.dart';
import '../../core/widgets/app_primary_button.dart';
import '../../core/widgets/app_text_link_button.dart';
import 'auth_notifier.dart';

/// Merchant Login Screen with demo login support and lockout handling.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final auth = context.read<AuthNotifier>();
    final success = await auth.login(
      _identifierController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      context.go('/terminal');
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthNotifier>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadH,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Navigation Bar ────────────────────────────────────────
              const AppBackButton(),
              const SizedBox(height: AppSpacing.xxl),

              // ── Header Title & Subtitle ───────────────────────────────────
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen10,
                  borderRadius: AppRadius.badgeAll,
                ),
                child: const Center(
                  child: Icon(
                    AppIcons.store,
                    color: AppColors.primaryGreen,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                AppStrings.loginTitle,
                style: AppTextStyles.heading1.copyWith(
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.loginSub,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.mutedText,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Lockout Warning Banner ───────────────────────────────────
              if (auth.isLockedOut) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: AppRadius.inputAll,
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(AppIcons.lock, size: 20, color: Colors.red.shade700),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          '${AppStrings.lockedOut} ${auth.lockoutRemaining} ${AppStrings.seconds}.',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.red.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ] else if (auth.errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: AppRadius.inputAll,
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(AppIcons.info, size: 20, color: Colors.amber.shade800),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          auth.errorMessage!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // ── Form Card ─────────────────────────────────────────────────
              AppCard(
                child: Column(
                  children: [
                    AppInputField(
                      controller: _identifierController,
                      label: AppStrings.fieldEmail,
                      hint: '0911234567 or shop@example.com',
                      leadingIcon: AppIcons.store,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    AppInputField(
                      controller: _passwordController,
                      label: AppStrings.fieldPassword,
                      hint: '••••••••',
                      leadingIcon: AppIcons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    Align(
                      alignment: Alignment.centerRight,
                      child: AppTextLinkButton(
                        text: AppStrings.forgotPassword,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),

              // ── Login Button ──────────────────────────────────────────────
              AppPrimaryButton(
                label: AppStrings.loginButton,
                trailingIcon: AppIcons.arrowRight,
                isLoading: auth.status == AuthStatus.loading,
                onPressed: auth.isLockedOut ? null : _handleLogin,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Demo Note ─────────────────────────────────────────────────
              Center(
                child: Text(
                  AppStrings.demoNote,
                  style: AppTextStyles.bodyXS.copyWith(
                    color: AppColors.mutedText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

