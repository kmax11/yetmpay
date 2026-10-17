import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_radius.dart';

/// Builds the app-wide [ThemeData] from design tokens.
abstract final class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primaryGreen,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primaryGreen10,
      onPrimaryContainer: AppColors.primaryGreen,
      secondary: AppColors.railGreen,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.railSuccessBg,
      onSecondaryContainer: AppColors.railSuccessText,
      tertiary: AppColors.mutedText,
      onTertiary: AppColors.white,
      error: Colors.red,
      onError: AppColors.white,
      surface: AppColors.surface,
      onSurface: AppColors.bodyText,
      surfaceContainerHighest: AppColors.surface2,
      outline: AppColors.borderDefault,
      outlineVariant: AppColors.borderLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // ── Scaffold ──────────────────────────────────────────────────────────
      scaffoldBackgroundColor: AppColors.background,

      // ── Fonts ─────────────────────────────────────────────────────────────
      fontFamily: 'Inter',

      // ── AppBar ────────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.darkText,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.heading2.copyWith(
          color: AppColors.darkText,
        ),
      ),

      // ── Elevated button ───────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.white,
          textStyle: AppTextStyles.buttonPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.buttonPrimaryAll,
          ),
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
        ),
      ),

      // ── Text button ───────────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
          textStyle: AppTextStyles.labelLarge,
        ),
      ),

      // ── Outlined button ───────────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryGreen,
          side: const BorderSide(color: AppColors.borderDefault),
          textStyle: AppTextStyles.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.buttonPrimaryAll,
          ),
        ),
      ),

      // ── Input decoration ─────────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        hintStyle: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.slatePlaceholder,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.inputAll,
          borderSide: const BorderSide(color: AppColors.borderDefault),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputAll,
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputAll,
          borderSide: const BorderSide(
            color: AppColors.primaryGreen,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputAll,
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputAll,
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),

      // ── Card ─────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.cardLargeAll,
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ── Bottom navigation ─────────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.mutedText,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTextStyles.labelXXS,
        unselectedLabelStyle: AppTextStyles.labelXXS,
        elevation: 0,
      ),

      // ── Text theme (Material slots → our tokens) ──────────────────────────
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: AppColors.darkText,
        ),
        headlineLarge: AppTextStyles.headingXL.copyWith(
          color: AppColors.darkText,
        ),
        headlineMedium: AppTextStyles.heading1.copyWith(
          color: AppColors.darkText,
        ),
        headlineSmall: AppTextStyles.heading2.copyWith(
          color: AppColors.darkText,
        ),
        titleLarge: AppTextStyles.heading3.copyWith(
          color: AppColors.darkText,
        ),
        titleMedium: AppTextStyles.headingSmall.copyWith(
          color: AppColors.darkText,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.bodyText,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.bodyText,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.mutedText,
        ),
        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: AppColors.bodyText,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: AppColors.mutedText,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: AppColors.mutedText,
        ),
      ),
    );
  }
}

