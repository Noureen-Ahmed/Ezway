import 'package:flutter/material.dart';

const _navy = Color(0xFF002147);
const _gold = Color(0xFFFDC800);
const _darkBg = Color(0xFF0D1117);
const _darkSurface = Color(0xFF161B22);
const _darkNavBar = Color(0xFF0D1B2A);

class AppTheme {
  static const Color navy = _navy;
  static const Color gold = _gold;

  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _navy,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: _navy,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: _navy,
          unselectedItemColor: Color(0xFF9CA3AF),
          elevation: 8,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _navy,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        cardTheme: const CardThemeData(color: Colors.white),
      );

  static ThemeData get dark => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _navy,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: _darkBg,
        appBarTheme: const AppBarTheme(
          backgroundColor: _darkNavBar,
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: _darkNavBar,
          selectedItemColor: _gold,
          unselectedItemColor: Color(0xFF6B7280),
          elevation: 8,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _navy,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        cardTheme: const CardThemeData(color: _darkSurface),
        dialogTheme: const DialogThemeData(
          backgroundColor: _darkSurface,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          contentTextStyle: TextStyle(color: Color(0xFFD1D5DB)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF1C2333),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2D3748)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2D3748)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _navy, width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
          hintStyle: const TextStyle(color: Color(0xFF6B7280)),
        ),
        popupMenuTheme: const PopupMenuThemeData(
          color: _darkSurface,
          textStyle: TextStyle(color: Colors.white),
        ),
        dividerColor: const Color(0xFF2D3748),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.white,
          iconColor: Color(0xFF9CA3AF),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(Colors.white),
          trackColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected) ? _gold : const Color(0xFF374151)),
        ),
      );
}
