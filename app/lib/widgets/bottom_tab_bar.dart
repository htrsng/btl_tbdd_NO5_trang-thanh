import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class BottomTabBar extends StatelessWidget {
  // Thêm các biến để nhận dữ liệu từ widget cha
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BottomNavigationBar(
      currentIndex: currentIndex, // Sử dụng biến được truyền vào
      onTap: onTap,             // Sử dụng hàm callback được truyền vào
      // Các thuộc tính màu sắc, font chữ sẽ tự động lấy từ AppTheme
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon: const Icon(Icons.home),
          label: l10n.homeTab,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.lightbulb_outline),
          activeIcon: const Icon(Icons.lightbulb),
          label: l10n.suggestionsTab,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.history_outlined),
          activeIcon: const Icon(Icons.history),
          label: l10n.historyTab,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline),
          activeIcon: const Icon(Icons.person),
          label: l10n.profileTab,
        ),
      ],
    );
  }
}