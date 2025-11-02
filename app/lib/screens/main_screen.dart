import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Thêm import
import '../providers/navigation_provider.dart'; // 2. Import "bộ điều khiển"
import 'home_screen.dart';
import 'suggestions_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import '../widgets/bottom_tab_bar.dart';

// [CẢI TIẾN] - Chuyển sang ConsumerStatefulWidget
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  // Biến state cục bộ không còn cần thiết nữa.
  // int _currentIndex = 0;

  static const List<Widget> _tabs = [
    HomeScreen(),
    SuggestionsScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  // Hàm _onTabTapped cũng không còn cần thiết vì logic sẽ được xử lý trong build

  @override
  Widget build(BuildContext context) {
    // [CẢI TIẾN] - Lắng nghe sự thay đổi từ provider
    final currentIndex = ref.watch(mainTabIndexProvider);

    return Scaffold(
      // Sử dụng currentIndex từ provider
      body: IndexedStack(index: currentIndex, children: _tabs),

      bottomNavigationBar: BottomTabBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Khi người dùng nhấn tab, cập nhật lại provider
          ref.read(mainTabIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}
