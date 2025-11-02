import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// - Dùng const để quản lý "magic strings"
const String _themePrefKey = 'appThemeMode';

//- Tạo một provider riêng chỉ để cung cấp SharedPreferences
// Điều này giúp tách biệt logic khởi tạo khỏi logic nghiệp vụ.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

// Provider chính của chúng ta
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  // Lắng nghe SharedPreferences provider
  final prefs = ref.watch(sharedPreferencesProvider);
  // Chỉ tạo Notifier khi SharedPreferences đã sẵn sàng
  return prefs.when(
    data: (prefsInstance) => ThemeNotifier(prefsInstance),
    // Trong khi chờ, hoặc nếu có lỗi, dùng một Notifier tạm với giá trị mặc định
    loading: () => ThemeNotifier(null),
    error: (_, __) => ThemeNotifier(null),
  );
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  //- Nhận SharedPreferences từ bên ngoài thay vì tự tạo
  final SharedPreferences? _prefs;

  ThemeNotifier(this._prefs) : super(ThemeMode.light) {
    _loadTheme();
  }

  void _loadTheme() {
    if (_prefs == null) return;
    final themeName = _prefs!.getString(_themePrefKey) ?? 'light';
    state = themeName == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    if (_prefs == null || state == themeMode) return;

    state = themeMode;
    await _prefs!.setString(
        _themePrefKey, themeMode == ThemeMode.dark ? 'dark' : 'light');
  }

  // - Thêm hàm toggle tiện lợi
  Future<void> toggleTheme() async {
    final newTheme = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setTheme(newTheme);
  }
}
