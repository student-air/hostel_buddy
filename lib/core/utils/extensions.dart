import 'package:flutter/material.dart';

/// BuildContext shortcuts — theme, screen size, and navigation-free
/// snackbars used throughout the app.
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;
}

/// String helpers — capitalization and initials for avatar placeholders.
extension StringExtensions on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get initials {
    final parts = trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  bool get isValidEmail =>
      RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(trim());
}

/// Number helpers — currency formatting for prices and bid amounts.
extension NumExtensions on num {
  /// e.g. 14500 -> "Rs 14,500"
  String get asCurrency {
    final str = toInt().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return 'Rs $buffer';
  }
}

/// DateTime helpers — used for bid countdown timers ("Ends in 6h").
extension DateTimeExtensions on DateTime {
  String get timeUntil {
    final diff = difference(DateTime.now());
    if (diff.isNegative) return 'Ended';
    if (diff.inDays > 0) return 'Ends in ${diff.inDays}d';
    if (diff.inHours > 0) return 'Ends in ${diff.inHours}h';
    if (diff.inMinutes > 0) return 'Ends in ${diff.inMinutes}m';
    return 'Ending now';
  }

  String get timeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
