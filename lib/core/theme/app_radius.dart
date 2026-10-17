import 'package:flutter/material.dart';

/// Border-radius tokens from Figma.
abstract final class AppRadius {
  // ── Raw values ──────────────────────────────────────────────────────────────
  static const double full = 9999.0;
  static const double cardLarge = 16.0;
  static const double buttonPrimary = 14.0;
  static const double buttonSmall = 12.0;
  static const double input = 12.0;
  static const double badge = 8.0;
  static const double badgeSmall = 6.0;

  /// Face-scan dark viewport frame.
  static const double viewport = 36.0;

  /// Scan corner bracket radius.
  static const double bracket = 12.0;

  /// Oval scan animation radius.
  static const double ovalScan = 72.0;

  // ── BorderRadius helpers ────────────────────────────────────────────────────
  static BorderRadius get pillAll => BorderRadius.circular(full);
  static BorderRadius get cardLargeAll => BorderRadius.circular(cardLarge);
  static BorderRadius get buttonPrimaryAll => BorderRadius.circular(buttonPrimary);
  static BorderRadius get buttonSmallAll => BorderRadius.circular(buttonSmall);
  static BorderRadius get inputAll => BorderRadius.circular(input);
  static BorderRadius get inputBR => inputAll;
  static BorderRadius get cardBR => cardLargeAll;
  static BorderRadius get buttonPrimaryBR => buttonPrimaryAll;
  static BorderRadius get badgeAll => BorderRadius.circular(badge);
  static BorderRadius get badgeSmallAll => BorderRadius.circular(badgeSmall);
  static BorderRadius get viewportAll => BorderRadius.circular(viewport);
  static BorderRadius get bracketAll => BorderRadius.circular(bracket);
  static BorderRadius get ovalScanAll => BorderRadius.circular(ovalScan);
}

