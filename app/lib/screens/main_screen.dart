import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_screen.dart';
import 'suggestions_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import '../widgets/bottom_tab_bar.dart';

// Đây chính là TabScreen cũ của bạn, nhưng đã được sửa lỗi và nâng cấp
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // [SỬA LỖI] - Bỏ 'final' để biến này có thể thay đổi
  int _currentIndex = 0; 

  // Danh sách các màn hình không đổi
  static const List<Widget> _tabs = [
    HomeScreen(),
    SuggestionsScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  // Hàm callback để nhận index mới từ BottomTabBar
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _tabs),
      // [CẢI TIẾN] - Truyền state và callback xuống cho BottomTabBar
      bottomNavigationBar: BottomTabBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}