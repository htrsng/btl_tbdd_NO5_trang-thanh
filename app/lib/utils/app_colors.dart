import 'package:flutter/material.dart';

// Lớp này chứa tất cả các hằng số màu sắc cho ứng dụng SkinAI.
class AppColors {
  // Constructor riêng tư để ngăn việc tạo instance của lớp này.
  AppColors._();

  // --- Bảng màu Pastel chính từ ảnh ---
  static const Color lightestBlue = Color(0xFFE0F2FC);
  static const Color periwinkle = Color(0xFFC6DEF6);
  static const Color steelBlue = Color(0xFF5080BE);

  // Các màu hồng này được lấy mẫu trực quan từ ảnh để đảm bảo chính xác.
  static const Color lightPink = Color(0xFFF7D8E4);
  static const Color mediumPink = Color(0xFFE6C7D6);

  // --- Màu sắc theo ngữ nghĩa (Semantic Colors) ---
  // Chúng ta gán các màu trong bảng màu vào các vai trò cụ thể.

  /// Màu chính cho các hành động quan trọng, AppBar, nút bấm.
  static const Color primary = steelBlue;

  /// Màu nhấn, dùng cho các thành phần phụ hoặc khi cần làm nổi bật.
  static const Color accent = lightPink;

  /// Màu nền chính của các màn hình.
  static const Color background = Color(0xFFFEFEFE); // Một màu trắng rất nhẹ

  /// Màu nền cho các thành phần như Card, Dialog.
  static const Color surface = Colors.white;

  /// Màu cho các văn bản chính.
  static const Color textPrimary = Color(0xFF333333);

  /// Màu cho các văn bản phụ, mô tả.
  static const Color textSecondary = Color(0xFF6C757D);

  /// Màu cho trạng thái thành công.
  static const Color success = Color(0xFF28A745);

  /// Màu cho trạng thái lỗi, cảnh báo.
  static const Color error = Color(0xFFDC3545);
}
