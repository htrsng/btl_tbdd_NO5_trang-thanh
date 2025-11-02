import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/skin_analysis_model.dart';
import '../../providers/navigation_provider.dart';
import '../../l10n/app_localizations.dart';

class AnalysisPanelContent extends ConsumerWidget {
  final SkinAnalysis analysis;
  const AnalysisPanelContent({required this.analysis, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scoreText = analysis.skinScore.toStringAsFixed(1);
    final skinType =
        analysis.skinType.isNotEmpty ? analysis.skinType : 'Chưa xác định';

    return Column(
      children: [
        // Tay nắm kéo
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.0)),
          ),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopInfoCard(context, scoreText, skinType, l10n),
              const SizedBox(height: 24),
              _buildImprovementTeaser(context, l10n),
              const SizedBox(height: 24),
              _buildProductTeaser(context, ref, l10n),
              const SizedBox(height: 24),
              const Divider(height: 24),
              Text(
                l10n.detailedAnalysis,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              _buildGridInfoCards(context),
              const SizedBox(height: 24),
              _buildCtaSection(context, l10n),
              const SizedBox(height: 24),
              _buildDisclaimerBox(context, l10n),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  // --- CÁC WIDGET CON ĐƯỢC CẬP NHẬT VÀ THÊM MỚI ---

  Widget _buildTopInfoCard(BuildContext context, String scoreText,
      String skinType, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text(l10n.skinScore,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text(scoreText,
                      style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                ])),
            const VerticalDivider(
                width: 1, thickness: 1, indent: 10, endIndent: 10),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text(l10n.skinType,
                      style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text(
                    skinType,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ])),
          ],
        ),
      ),
    );
  }

  Widget _buildImprovementTeaser(BuildContext context, AppLocalizations l10n) {
    final improvementTips =
        analysis.improvements.values.expand((tips) => tips).take(2).toList();
    if (improvementTips.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.habitsTab,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...improvementTips.map((tip) => ListTile(
              leading: Icon(Icons.check_circle_outline,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(tip),
              dense: true,
              contentPadding: EdgeInsets.zero,
            )),
      ],
    );
  }

  Widget _buildProductTeaser(
      BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final products = analysis.products;
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.productsTab,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                ref.read(suggestionsTabIndexProvider.notifier).state = 1;
                ref.read(mainTabIndexProvider.notifier).state = 1;
              },
              child: const Text("Nhiều hơn >>"),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: products
              .take(3)
              .map((product) => _buildMiniProductCard(product))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildMiniProductCard(ProductSuggestion product) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12)),
            child: Image.network(product.image,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => const Icon(Icons.image)),
          ),
          const SizedBox(height: 8),
          Text(product.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildGridInfoCards(BuildContext context) {
    final List<Map<String, String>> issueDetails = [
      {'label': 'Mụn', 'key': 'acne'},
      {'label': 'Lỗ chân lông', 'key': 'pores'},
      {'label': 'Sắc tố', 'key': 'pigmentation'},
      {'label': 'Nếp nhăn', 'key': 'wrinkles'},
      {'label': 'Kết cấu da', 'key': 'texture'},
      {'label': 'Mẩn đỏ', 'key': 'redness'},
    ];

    return GridView.builder(
      itemCount: issueDetails.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, i) {
        final detail = issueDetails[i];
        final score = _getScoreValue(detail['key']!);
        return _buildInfoCard(detail['label']!, score);
      },
    );
  }

  int _getScoreValue(String key) {
    switch (key) {
      case 'acne':
        return analysis.analysis.acne;
      case 'pores':
        return analysis.analysis.pores;
      case 'pigmentation':
        return analysis.analysis.pigmentation;
      case 'wrinkles':
        return analysis.analysis.wrinkles;
      case 'texture':
        return analysis.analysis.texture;
      case 'redness':
        return analysis.analysis.redness;
      default:
        return 0;
    }
  }

  Widget _buildInfoCard(String title, int score) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.5,
                  color: Colors.black87)),
          const Spacer(),
          Center(
            child: Text(
              score.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  color: Colors.black87),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text('/10',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  // [SỬA LỖI] - Thêm xử lý null (??) cho các giá trị từ l10n
  Widget _buildCtaSection(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        _buildCtaCard(
          context: context,
          icon: Icons.smart_toy_outlined,
          title: l10n.chatWithAI, // Lỗi ở đây
          subtitle: l10n.chatWithAISubtitle, // Lỗi ở đây
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l10n.featureInProgress)));
          },
        ),
        const SizedBox(height: 12),
        _buildCtaCard(
          context: context,
          icon: Icons.health_and_safety_outlined,
          title: l10n.connectExpert, // Lỗi ở đây
          subtitle: l10n.connectExpertSubtitle, // Lỗi ở đây
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l10n.featureInProgress)));
          },
        ),
      ],
    );
  }

  // Widget con cho thẻ CTA
  Widget _buildCtaCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: Colors.grey.shade200, width: 1.2),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8)
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style:
                          TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // [SỬA LỖI] - Thêm xử lý null (??) cho các giá trị từ l10n
  Widget _buildDisclaimerBox(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.yellow.withAlpha(50),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded,
              color: Colors.orange.shade700, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.disclaimerTitle, // Lỗi ở đây
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade900)),
                const SizedBox(height: 4),
                Text(l10n.disclaimerBody, // Lỗi ở đây
                    style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 13,
                        height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
