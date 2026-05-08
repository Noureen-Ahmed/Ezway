import 'package:flutter/material.dart';

extension AppThemeX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get cardBg => isDark ? const Color(0xFF161B22) : Colors.white;
  Color get pageBg => isDark ? const Color(0xFF0D1117) : const Color(0xFFF8F9FA);
  Color get navyOrWhite => isDark ? Colors.white : const Color(0xFF002147);
  Color get mutedText => isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
  Color get borderCol => isDark ? const Color(0xFF2D3748) : const Color(0xFFE5E7EB);
  Color get inputFill => isDark ? const Color(0xFF1C2333) : const Color(0xFFF9FAFB);
}
