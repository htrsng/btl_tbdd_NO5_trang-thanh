import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Thêm import
import '../providers/navigation_provider.dart'; // Import provider mới
import 'home_screen.dart';
import 'suggestions_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import '../widgets/bottom_tab_bar.dart';

// [CẢI TIẾN] - Chuyển sang ConsumerStatefulWidget để có thể dùng 'ref'
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  // Biến state không còn cần thiết nữa, chúng ta sẽ dùng provider.
  // int _currentIndex = 0;

  static const List<Widget> _tabs = [
    HomeScreen(),
    SuggestionsScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // [CẢI TIẾN] - Lắng nghe sự thay đổi từ provider
    final currentIndex = ref.watch(mainTabIndexProvider);

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _tabs),
      bottomNavigationBar: BottomTabBar(
        currentIndex: currentIndex,
        // Khi người dùng nhấn tab, cập nhật lại provider
        onTap: (index) => ref.read(mainTabIndexProvider.notifier).state = index,
      ),
    );
  }
}
