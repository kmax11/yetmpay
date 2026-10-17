import 'package:flutter/material.dart';

/// Design tokens — colors from Figma.
abstract final class AppColors {
  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF6F7F8);
  static const Color surface = Color(0xFFF1F5F9);
  static const Color surface2 = Color(0xFFF8FAFC);
  static const Color divider = Color(0xFFF1F3F5);

  // ── Primary ─────────────────────────────────────────────────────────────────
  static const Color primaryGreen = Color(0xFF0B5D3B);
  static const Color primaryGreen10 = Color(0x1A0B5D3B); // rgba(11,93,59,0.10)

  // ── Text ────────────────────────────────────────────────────────────────────
  static const Color darkText = Color(0xFF0F172A);
  static const Color bodyText = Color(0xFF1E293B);
  static const Color mutedText = Color(0xFF64748B);
  static const Color subtleMuted = Color(0xFF475569);
  static const Color slatePlaceholder = Color(0xFF94A3B8);
  static const Color slate300 = Color(0xFF334155);

  // ── Borders ─────────────────────────────────────────────────────────────────
  static const Color borderDefault = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color border60 = Color(0x99E2E8F0); // rgba(226,232,240,0.6)

  // ── White ───────────────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);

  // ── Rail / Scan status ──────────────────────────────────────────────────────
  static const Color railGreen = Color(0xFF10B981);
  static const Color railSuccessBg = Color(0xFFECFDF5);
  static const Color railSuccessText = Color(0xFF047857);
  static const Color scanLive = Color(0xFF10B981);
  static const Color scanLiveText = Color(0xFF6EE7B7);

  // ── Progress bar ────────────────────────────────────────────────────────────
  static const Color progressBarBg = Color(0xFFE9ECEF);

  // ── Bank badges ─────────────────────────────────────────────────────────────
  static const Color cbeBadgeBg = Color(0xFF591C63);
  static const Color cbeBadgeText = Color(0xFFFCDD09);

  static const Color awashBadgeBg = Color(0xFF17479E);
  static const Color awashBadgeText = Color(0xFFF5A81D);

  static const Color dashenBadgeBg = Color(0xFF002B49);
  static const Color dashenBadgeText = Color(0xFFE5A823);

  static const Color boaBadgeBg = Color(0xFFF5B324);
  static const Color boaBadgeText = Color(0xFF000000);

  // ── Bank pills (splash / select) ─────────────────────────────────────────────
  static const Color cbePill = Color(0xFFF2A900);
  static const Color awashPill = Color(0xFF0284C7);
  static const Color dashenPill = Color(0xFF0D9488);
}

