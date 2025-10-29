import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';

// [CẢI TIẾN] - Chuyển sang ConsumerWidget
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=500&q=80'),
            ),
            const SizedBox(height: 12),
            const Text('User Name',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text('user@email.com',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
            const SizedBox(height: 30),
            const Divider(),

            _buildProfileMenuItem(
              icon: Icons.person_outline,
              title: l10n.editProfile,
              onTap: () {},
            ),
            _buildProfileMenuItem(
              icon: Icons.notifications_none_outlined,
              title: l10n.notifications,
              onTap: () {},
            ),

            _buildProfileMenuItem(
              icon: Icons.language_outlined,
              title:
                  "Ngôn ngữ / Language",
              onTap: () {
                _showLanguageDialog(context, ref);
              },
            ),

            _buildProfileMenuItem(
              icon: Icons.info_outline,
              title: l10n.aboutUs,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (ctx) => AboutUsScreen(l10n: l10n)),
                );
              },
            ),
            const Divider(),
            _buildProfileMenuItem(
              icon: Icons.logout,
              title: l10n.logout,
              textColor: Colors.red,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Chọn ngôn ngữ / Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Tiếng Việt'),
                onTap: () {
                  ref
                      .read(localeProvider.notifier)
                      .setLocale(const Locale('vi'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: const Text('English'),
                onTap: () {
                  ref
                      .read(localeProvider.notifier)
                      .setLocale(const Locale('en'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget helper không cần truyền context nữa
  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color textColor = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}

// Màn hình "Về chúng tôi" được cập nhật để nhận l10n
class AboutUsScreen extends StatelessWidget {
  final AppLocalizations l10n;
  const AboutUsScreen({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutUs)),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Ứng dụng SkinAI',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text(
                'Dự án được phát triển bởi [Tên nhóm/Tên của bạn].\n\n'
                'Chúng tôi mong muốn mang lại một giải pháp tiện lợi để mọi người có thể hiểu rõ hơn về làn da của mình và tìm ra chu trình chăm sóc phù hợp nhất.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
