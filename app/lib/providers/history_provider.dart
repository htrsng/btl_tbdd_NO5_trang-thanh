// lib/providers/history_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/skin_analysis_model.dart';

// Sử dụng StateProvider để dữ liệu có thể được thay đổi (ví dụ: xóa)
final historyProvider = StateProvider<List<SkinAnalysis>>((ref) {
  // Dữ liệu giả. Sau này, bạn có thể thay thế logic này bằng việc
  // đọc dữ liệu từ SharedPreferences hoặc Hive.
  return [
    SkinAnalysis.empty().copyWith(
        skinScore: 7.5,
        skinType: 'Da dầu',
        date: DateTime.now().subtract(const Duration(days: 60))),
    SkinAnalysis.empty().copyWith(
        skinScore: 8.2,
        skinType: 'Da hỗn hợp',
        date: DateTime.now().subtract(const Duration(days: 30))),
    SkinAnalysis.empty().copyWith(
        skinScore: 8.5,
        skinType: 'Da thường',
        date: DateTime.now().subtract(const Duration(days: 7))),
  ];
});
