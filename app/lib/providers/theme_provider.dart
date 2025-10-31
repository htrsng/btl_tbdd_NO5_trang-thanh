// [SỬA LỖI TẠI ĐÂY] - Thêm dòng import quan trọng này
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _themePrefKey = 'appThemeMode';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_themePrefKey) ?? 'light';
    state = themeName == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    if (state == themeMode) return;

    state = themeMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _themePrefKey, themeMode == ThemeMode.dark ? 'dark' : 'light');
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
