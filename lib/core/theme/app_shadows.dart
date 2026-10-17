import 'package:flutter/material.dart';

/// Shadow tokens from Figma.
abstract final class AppShadows {
  /// Subtle card lift — offset (0,1), blur 2.
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0D000000), // rgba(0,0,0,0.05)
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  /// Bottom-nav / header separator — offset (0,−1), blur 6.
  static const List<BoxShadow> headerShadow = [
    BoxShadow(
      color: Color(0x08000000), // rgba(0,0,0,0.03)
      offset: Offset(0, -1),
      blurRadius: 6,
    ),
  ];

  /// Green inner ring — primary-green 10%, spread 4.
  static const List<BoxShadow> innerRing = [
    BoxShadow(
      color: Color(0x1A0B5D3B), // rgba(11,93,59,0.10)
      spreadRadius: 4,
    ),
  ];

  /// Deep dark shadow — offset (0,25), blur 50, spread −12.
  static const List<BoxShadow> darkShadow = [
    BoxShadow(
      color: Color(0x40000000), // rgba(0,0,0,0.25)
      offset: Offset(0, 25),
      blurRadius: 50,
      spreadRadius: -12,
    ),
  ];
}

