import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/main_screen.dart';
import 'utils/app_theme.dart'; // Đảm bảo đường dẫn này đúng (utils hoặc untils)
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart'; // <-- 1. Import provider quản lý ngôn ngữ

// [CẢI TIẾN #1] - Chuyển main thành hàm bất đồng bộ (async)
Future<void> main() async {
  // Đảm bảo rằng tất cả các "binding" của Flutter đã được khởi tạo xong
  // trước khi chạy ứng dụng. Rất quan trọng cho các plugin.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

// [CẢI TIẾN #2] - Chuyển sang ConsumerWidget để có thể dùng 'ref'
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // [CẢI TIẾN #3] - Lắng nghe sự thay đổi ngôn ngữ từ provider
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'SkinAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      // --- Phần đa ngôn ngữ đã được kết nối ---
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale, // <-- Sử dụng locale động từ provider
      // ------------------------------------

      home: const MainScreen(),
    );
  }
}
