import 'package:flutter/material.dart';

class BottomTabBar extends StatelessWidget {
  // [SỬA LỖI TẠI ĐÂY] - Thêm các biến để nhận dữ liệu
  final int currentIndex;
  final ValueChanged<int> onTap; // Kiểu dữ liệu cho một hàm callback

  // [SỬA LỖI TẠI ĐÂY] - Định nghĩa constructor để nhận các tham số có tên
  const BottomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Simple locale-aware helper: prefer Vietnamese when locale.languageCode == 'vi'
    String t(String en, String vi) {
      try {
        final code = Localizations.localeOf(context).languageCode;
        return code == 'vi' ? vi : en;
      } catch (_) {
        return en;
      }
    }

    return BottomNavigationBar(
      currentIndex: currentIndex, // Sử dụng biến được truyền vào
      onTap: onTap, // Sử dụng hàm callback được truyền vào
      // Các thuộc tính màu sắc, font chữ sẽ tự động lấy từ AppTheme
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: t('Home', 'Trang chủ'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.lightbulb_outline),
          activeIcon: const Icon(Icons.lightbulb),
          label: t('Suggestions', 'Gợi ý'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.history_outlined),
          activeIcon: const Icon(Icons.history),
          label: t('History', 'Lịch sử'),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline),
          activeIcon: const Icon(Icons.person),
          label: t('Profile', 'Hồ sơ'),
        ),
      ],
    );
  }
}
