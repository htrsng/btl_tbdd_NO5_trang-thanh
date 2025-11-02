import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // === Bảng màu Pastel Mới ===

  // Màu Xanh/Tím chủ đạo (Từ IntroStep của bạn)
  static const Color primaryBlue = Color(0xFF5080BE);
  static const Color primaryLavender = Color(0xFFC6DEF6);

  // Màu Hồng/Nude nhấn (Từ bảng màu pastel)
  static const Color accentPink = Color(0xFFE6F5FA); // Mã màu này là màu hồng
  static const Color accentPinkLight =
      Color(0xFFF7D8E4); // Lấy từ mã màu thực tế của ảnh

  // Màu Nền (Rất quan trọng!)
  // Thay vì trắng tinh (0xFFFFFFFF), chúng ta dùng một màu trắng ngà/xám cực nhạt.
  // Đây là bí quyết để làm cho giao diện trông "cao cấp" và dịu mắt.
  static const Color background = Color(0xFFF8F9FE);
  static const Color surface = Colors.white; // Màu cho các thẻ Card

  // Màu Chữ
  static const Color textPrimary =
      Color(0xFF333333); // Than chì (đẹp hơn đen tuyền)
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textLight = Color(0xFFB8B8B8);

  // Màu Gradient (Từ IntroStep của bạn)
  static const Gradient primaryGradient = LinearGradient(
    colors: [primaryLavender, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
