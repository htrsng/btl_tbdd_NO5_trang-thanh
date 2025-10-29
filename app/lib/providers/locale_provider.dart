import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Key để lưu ngôn ngữ trong SharedPreferences
const String _languagePrefKey = 'appLanguageCode';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('vi')) {
    // Mặc định là tiếng Việt
    _loadLocale();
  }

  // Đọc ngôn ngữ đã lưu khi khởi động
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languagePrefKey) ?? 'vi';
    state = Locale(languageCode);
  }

  // Đặt và lưu ngôn ngữ mới
  Future<void> setLocale(Locale locale) async {
    if (state == locale) return; // Không làm gì nếu ngôn ngữ không đổi

    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languagePrefKey, locale.languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
