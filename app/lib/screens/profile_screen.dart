import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import 'about_us_screen.dart'; // Import file mới

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  // Helper để lấy tên ngôn ngữ hiện tại
  String _getCurrentLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'vi': return 'Tiếng Việt';
      case 'en': return 'English';
      default: return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = ref.watch(localeProvider);
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Phần thông tin người dùng
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1580489944761-15a19d654956?w=500&q=80'),
            ),
          ),
          const SizedBox(height: 12),
          const Center(child: Text('User Name', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
          Center(child: Text('user@email.com', style: TextStyle(fontSize: 16, color: Colors.grey.shade600))),
          const SizedBox(height: 24),

          // Card Cài đặt ứng dụng
          Card(
            child: Column(
              children: [
                // [CẢI TIẾN] - Mục chọn ngôn ngữ
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(l10n.language),
                  trailing: Text(
                    _getCurrentLanguageName(currentLocale),
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  onTap: () => _showLanguageDialog(context, ref, l10n),
                ),
                const Divider(height: 1),
                // [CẢI TIẾN] - Mục Chế độ tối
                SwitchListTile(
                  secondary: const Icon(Icons.brightness_6_outlined),
                  title: Text(l10n.darkMode),
                  value: currentTheme == ThemeMode.dark,
                  onChanged: (isDark) {
                    ref.read(themeProvider.notifier).setTheme(isDark ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Card Thông tin khác
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.aboutUs),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutUsScreen())),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Nút Đăng xuất
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
            onTap: () {
              // TODO: Thêm logic đăng xuất
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Tiếng Việt'),
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(const Locale('vi'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}