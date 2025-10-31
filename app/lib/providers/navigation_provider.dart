import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider này giữ index của tab đang được chọn trên MainScreen.
// Mặc định là 0 (Trang chủ).
final mainTabIndexProvider = StateProvider<int>((ref) => 0);
final suggestionsTabIndexProvider = StateProvider<int>((ref) => 0);
