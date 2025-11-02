import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';

class FakeExpertScreen extends ConsumerWidget {
  const FakeExpertScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.expertBookingTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=500&q=80'),
            ),
            const SizedBox(height: 16),
            Text(l10n.expertName,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(l10n.expertSpecialty,
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.primary)),
            const SizedBox(height: 24),
            Text(l10n.expertBio,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(height: 1.5, color: Colors.grey.shade700)),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              icon: const Icon(Icons.calendar_month_outlined),
              label: Text(l10n.bookAppointmentButton),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.featureInProgress)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
