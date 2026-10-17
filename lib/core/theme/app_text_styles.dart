import 'package:flutter/material.dart';

/// Typography tokens from Figma.
///
/// All fonts are bundled in assets/fonts/.
/// Flutter height = lineHeight / fontSize.
/// Flutter letterSpacing = figmaEm * fontSize (converted to px already below).
abstract final class AppTextStyles {
  // ── Display ─────────────────────────────────────────────────────────────────

  /// Sora Bold 48 | lh 48 | ls −0.0083em → −0.4px
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Sora',
    fontWeight: FontWeight.w700,
    fontSize: 48,
    height: 1.0,          // 48/48
    letterSpacing: -0.4,  // −0.0083 * 48 ≈ −0.4
  );

  // ── Headings ────────────────────────────────────────────────────────────────

  /// Sora Bold 32 | lh 40 | ls −0.025em → −0.8px
  static const TextStyle headingXL = TextStyle(
    fontFamily: 'Sora',
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 1.25,         // 40/32
    letterSpacing: -0.8,  // −0.025 * 32
  );

  /// Sora SemiBold 24 | lh 30 | ls −0.025em → −0.6px
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'Sora',
    fontWeight: FontWeight.w600,
    fontSize: 24,
    height: 1.25,         // 30/24
    letterSpacing: -0.6,  // −0.025 * 24
  );

  /// Sora SemiBold 17 | lh 25.5
  static const TextStyle heading2 = TextStyle(
    fontFamily: 'Sora',
    fontWeight: FontWeight.w600,
    fontSize: 17,
    height: 1.5,          // 25.5/17
  );

  /// Sora SemiBold 16 | lh 24
  static const TextStyle heading3 = TextStyle(
    fontFamily: 'Sora',
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.5,          // 24/16
  );

  /// Sora SemiBold 15 | lh 22.5
  static const TextStyle headingSmall = TextStyle(
    fontFamily: 'Sora',
    fontWeight: FontWeight.w600,
    fontSize: 15,
    height: 1.5,          // 22.5/15
  );

  /// Sora SemiBold 18 | lh 24.75 | ls −0.025em → −0.45px
  static const TextStyle tagline = TextStyle(
    fontFamily: 'Sora',
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 1.375,        // 24.75/18
    letterSpacing: -0.45, // −0.025 * 18
  );

  // ── Body ────────────────────────────────────────────────────────────────────

  /// Inter Regular 15 | lh 22.5
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 15,
    height: 1.5,          // 22.5/15
  );

  /// Inter Regular 14 | lh 22.75
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.625,        // 22.75/14
  );

  /// Inter Regular 13 | lh 19.5
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 1.5,          // 19.5/13
  );

  /// Inter Regular 12 | lh 18
  static const TextStyle bodyXS = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.5,          // 18/12
  );

  /// Inter Regular 11 | lh 16.5
  static const TextStyle bodyXXS = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    fontSize: 11,
    height: 1.5,          // 16.5/11
  );

  // ── Labels ──────────────────────────────────────────────────────────────────

  /// Inter Medium 15 | lh 22.5
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 1.5,
  );

  /// Inter Medium 13 | lh 19.5
  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 13,
    height: 1.5,
  );

  /// Inter Medium 12 | lh 18
  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.5,
  );

  /// Inter Medium 11 | lh 16.5
  static const TextStyle labelXS = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 11,
    height: 1.5,
  );

  /// Inter Medium 11 | lh 11 — tab bar labels.
  static const TextStyle labelXXS = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 11,
    height: 1.0,          // 11/11
  );

  // ── SemiBold body variants ───────────────────────────────────────────────────

  /// Inter SemiBold 15 | lh 22.5
  static const TextStyle semiBoldLarge = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 15,
    height: 1.5,
  );

  /// Inter SemiBold 13 | lh 19.5
  static const TextStyle semiBoldMedium = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 13,
    height: 1.5,
  );

  /// Inter SemiBold 12 | lh 18
  static const TextStyle semiBoldSmall = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 12,
    height: 1.5,
  );

  /// Inter SemiBold 11 | lh 16.5
  static const TextStyle semiBoldXS = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 11,
    height: 1.5,
  );

  /// Inter SemiBold 9 | lh 13.5 — bank badge abbreviations.
  static const TextStyle semiBoldBadge = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 9,
    height: 1.5,          // 13.5/9
  );

  // ── Caps labels ─────────────────────────────────────────────────────────────

  /// Inter Medium 11 | ls 0.05em → 0.55px | UPPERCASE
  static const TextStyle capsLabel = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 11,
    letterSpacing: 0.55,  // 0.05 * 11
  );

  /// Inter SemiBold 11 | ls 0.05em → 0.55px | UPPERCASE
  static const TextStyle capsLabelSemiBold = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 11,
    letterSpacing: 0.55,
  );

  // ── Mono ────────────────────────────────────────────────────────────────────

  /// Liberation Mono Regular 15
  static const TextStyle monoLarge = TextStyle(
    fontFamily: 'LiberationMono',
    fontWeight: FontWeight.w400,
    fontSize: 15,
  );

  /// Liberation Mono Regular 12 | lh 18
  static const TextStyle monoMedium = TextStyle(
    fontFamily: 'LiberationMono',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.5,          // 18/12
  );

  /// Liberation Mono Bold 13 | lh 19.5 | ls 0.05em → 0.65px
  static const TextStyle monoSmall = TextStyle(
    fontFamily: 'LiberationMono',
    fontWeight: FontWeight.w700,
    fontSize: 13,
    height: 1.5,          // 19.5/13
    letterSpacing: 0.65,  // 0.05 * 13
  );

  /// Liberation Mono Bold 10 | lh 15 | ls 0.1em → 1px | UPPERCASE
  static const TextStyle monoLIVE = TextStyle(
    fontFamily: 'LiberationMono',
    fontWeight: FontWeight.w700,
    fontSize: 10,
    height: 1.5,          // 15/10
    letterSpacing: 1.0,   // 0.1 * 10
  );

  // ── Buttons ─────────────────────────────────────────────────────────────────

  /// Inter Medium 15 | lh 22.5
  static const TextStyle buttonPrimary = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 1.5,
  );

  /// Sora SemiBold 16 | lh 24
  static const TextStyle buttonCharge = TextStyle(
    fontFamily: 'Sora',
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.5,          // 24/16
  );
}

