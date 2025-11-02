import 'package:flutter/material.dart';
import 'app_colors.dart'; // Đảm bảo file này tồn tại

class AppTheme {
  AppTheme._();

  // --- GIAO DIỆN SÁNG ---
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: AppColors.background, // Nền trắng ngà

    // [SỬA LỖI #2] - Thêm 'const'
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background, // AppBar phẳng, tiệp màu nền
      elevation: 0, // Bỏ bóng mờ
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    // [SỬA LỖI #1] - Đổi 'CardTheme' thành 'CardThemeData'
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: Colors.grey.shade200, width: 1.0),
      ),
      shadowColor: AppColors.primaryBlue.withAlpha(20),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
    ),

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.accentPink,
      // [SỬA LỖI #3] - Xóa bỏ thuộc tính 'background' đã cũ
      surface: AppColors.surface,
    ),
  );

  // --- GIAO DIỆN TỐI ---
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryBlue,
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: Colors.grey,
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryBlue,
      secondary: AppColors.accentPink,
      surface: Color(0xFF1E1E1E),
    ),
  );
}
