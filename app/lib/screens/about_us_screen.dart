// Trang hiển thị thông tin nhóm và giảng viên (đáp ứng yêu cầu đề tài).
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutUs)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo hoặc Icon ứng dụng
              Icon(
                Icons.spa_outlined, // Bạn có thể thay bằng logo
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),

              // Tên ứng dụng
              Text(
                l10n.appName,
                style: textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Mục tiêu dự án
              Text(
                l10n.aboutUsBody,
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 32),

              // Thông tin GVHD
              Text(
                l10n.aboutUsLecturer,
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Thông tin thành viên
              Text(
                l10n.aboutUsStudent1,
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.aboutUsStudent2,
                style: textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
