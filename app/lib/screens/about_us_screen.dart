import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutUs)),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(
          // ... (Dán nội dung Column từ file profile cũ của bạn vào đây)
        ),
      ),
    );
  }
}