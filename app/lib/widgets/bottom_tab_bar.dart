import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../providers/app_state_provider.dart'; // Not used currently

class BottomTabBar extends ConsumerWidget {
  const BottomTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = 0; // Hardcode tạm, sau dùng provider cho tab index

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        // Switch tab (sau dùng GoRouter hoặc provider)
        print('Switch to tab $index');
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Gợi ý'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Lịch sử'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Tài khoản'),
      ],
    );
  }
}
