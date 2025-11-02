import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_state_provider.dart';
import '../../l10n/app_localizations.dart';

class IntroStep extends ConsumerStatefulWidget {
  const IntroStep({super.key});

  @override
  ConsumerState<IntroStep> createState() => _IntroStepState();
}

class _IntroStepState extends ConsumerState<IntroStep> {
  int _currentPage = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<Map<String, String>> introSlidesData = [
      {
        "animation": "animations/face_scan.json",
        "title": l10n.introSlide1Title,
        "subtitle": l10n.introSlide1Subtitle
      },
      {
        "animation": "animations/skincare_routine.json",
        "title": l10n.introSlide2Title,
        "subtitle": l10n.introSlide2Subtitle
      },
      {
        "animation": "animations/health_check.json",
        "title": l10n.introSlide3Title,
        "subtitle": l10n.introSlide3Subtitle
      }
    ];

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: introSlidesData.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final slide = introSlidesData[index];
              return _buildSlide(context, slide['animation']!, slide['title']!,
                  slide['subtitle']!);
            },
          ),
        ),
        _buildPageIndicator(introSlidesData.length),
        _buildStartButton(context, ref, l10n),
      ],
    );
  }

  // --- CÁC WIDGET CON ĐƯỢC TÁCH RA ---

  Widget _buildSlide(BuildContext context, String animationPath, String title,
      String subtitle) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          animationPath,
          width: 250,
          height: 250,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [
                  theme.colorScheme.secondary,
                  theme.colorScheme.primary.withAlpha(178)
                ]),
              ),
              child: const Icon(Icons.spa, color: Colors.white, size: 70),
            );
          },
        ),
        const SizedBox(height: 32),
        Text(title,
            textAlign: TextAlign.center,
            style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(subtitle,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                  color: textTheme.bodyMedium?.color?.withAlpha(204),
                  height: 1.4)),
        ),
      ],
    );
  }

  Widget _buildPageIndicator(int pageCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          height: 8.0,
          width: _currentPage == index ? 24.0 : 8.0,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  Widget _buildStartButton(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 24, 24.0, 48.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: theme.colorScheme.primary,
        ),
        onPressed: () => ref.read(appStateProvider.notifier).setStep(1),
        child: Text(l10n.introStartButton,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
      ),
    );
  }
}
