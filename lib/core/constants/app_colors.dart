import 'package:flutter/material.dart';

/// Hostel Buddy — Maroon / Burgundy palette + teal accent.
/// Values pulled from the approved UI mockup.
class AppColors {
  AppColors._();

  // Primary (maroon)
  static const Color primary = Color(0xFF6B0E24);
  static const Color primaryDark = Color(0xFF4A0A1E);
  static const Color primaryDeep = Color(0xFF3C0515);

  // Accent (teal / cyan — CTAs, links on dark screens)
  static const Color accent = Color(0xFF0D9488);
  static const Color accentDark = Color(0xFF0F766E);
  static const Color accentLight = Color(0xFF14B8A6);

  // Gradient stops used on Splash / Auth / Role Selection headers
  static const Color gradientStart = Color(0xFF8B1538);
  static const Color gradientMid = Color(0xFF5C0E24);
  static const Color gradientEnd = Color(0xFF4A0A1E);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [gradientStart, gradientMid, gradientEnd],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDeep],
  );

  // Backgrounds
  static const Color scaffoldBackground = Color(0xFFFCF5FD);
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF33041A);
  static const Color textSecondary = Color(0xFFA97887);
  static const Color textMuted = Color(0xFFC6A0B2);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Borders / dividers
  static const Color border = Color(0xFFEED9E6);
  static const Color divider = Color(0xFFF6E7F0);

  // Tags / chips
  static const Color tagBackground = Color(0xFFFBE4EF);
  static const Color tagText = Color(0xFF6E1330);

  // Placeholder / skeleton blocks (image shimmer)
  static const Color placeholderStart = Color(0xFFF1DEE9);
  static const Color placeholderEnd = Color(0xFFF6E7F0);

  // Status
  static const Color notificationDot = Color(0xFFE8736C);
  static const Color success = Color(0xFF3EA66B);
  static const Color error = Color(0xFFD1435B);
  static const Color warning = Color(0xFFE0A33C);

  // Auth dark-screen glass fields
  static const Color glassFill = Color(0x33FFFFFF);
  static const Color glassBorder = Color(0x40FFFFFF);
  static const Color glassHint = Color(0x99FFFFFF);
}
