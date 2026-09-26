import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_colors.dart';

/// App-wide snackbar — same look everywhere (teal, rounded, bottom).
/// Use [AppSnackbar.success], [.error], [.info], [.warning] instead of Get.snackbar.
class AppSnackbar {
  AppSnackbar._();

  static const _margin = EdgeInsets.all(16);
  static const _radius = 12.0;
  static const _duration = Duration(seconds: 3);

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    IconData? icon,
  }) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: _margin,
      borderRadius: _radius,
      duration: _duration,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutCubic,
      reverseAnimationCurve: Curves.easeInCubic,
      animationDuration: const Duration(milliseconds: 350),
      icon: icon != null ? Icon(icon, color: Colors.white, size: 22) : null,
      shouldIconPulse: false,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      titleText: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.3,
        ),
      ),
    );
  }

  /// Default / info — teal accent (same as Forgot password)
  static void info(String title, String message) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.accent,
      icon: Icons.info_outline_rounded,
    );
  }

  /// Success — teal accent
  static void success(String title, String message) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.accent,
      icon: Icons.check_circle_outline_rounded,
    );
  }

  /// Error — red
  static void error(String title, String message) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline_rounded,
    );
  }

  /// Warning — amber
  static void warning(String title, String message) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.warning,
      icon: Icons.warning_amber_rounded,
    );
  }
}
