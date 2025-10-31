import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/skin_analysis_model.dart';
import '../../providers/navigation_provider.dart';

class AnalysisPanelContent extends ConsumerWidget {
  final SkinAnalysis analysis;

  const AnalysisPanelContent({required this.analysis, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              _buildTopInfoCard(context, scoreText, skinType),
              const SizedBox(height: 24),
              _buildImprovementTeaser(context),
              const SizedBox(height: 24),
              _buildProductTeaser(context, ref),
              const SizedBox(height: 24),
              const Divider(height: 24),
              const Text(
                "Phân tích chi tiết",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              _buildGridInfoCards(context),
            ],
          ),
        ),
      ],
    );
  }

  // --- WIDGET CON ĐÃ ĐƯỢC CẬP NHẬT ---

  Widget _buildTopInfoCard(
      BuildContext context, String scoreText, String skinType) {
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
            // Cột Điểm trung bình
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Điểm số da",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    scoreText,
                    style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ],
              ),
            ),
            const VerticalDivider(
                width: 1, thickness: 1, indent: 10, endIndent: 10),
            // Cột Loại da
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Loại da của bạn",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),

                  // [SỬA LỖI] - Hiển thị toàn bộ chuỗi skinType
                  Text(
                    skinType, // <-- Đã xóa .split(' ')[0]
                    textAlign: TextAlign.center,
                    maxLines: 2, // Cho phép hiển thị tối đa 2 dòng
                    overflow: TextOverflow.ellipsis, // Thêm dấu ... nếu quá dài
                    style: const TextStyle(
                      fontSize: 18, // Điều chỉnh font size cho phù hợp
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Các hàm còn lại giữ nguyên như cũ...
  Widget _buildImprovementTeaser(BuildContext context) {
    final improvementTips =
        analysis.improvements.values.expand((tips) => tips).take(2).toList();
    if (improvementTips.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Phương pháp cải thiện",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

  Widget _buildProductTeaser(BuildContext context, WidgetRef ref) {
    final products = analysis.products;
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Sản phẩm gợi ý",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                ref.read(mainTabIndexProvider.notifier).state = 1;
                ref.read(suggestionsTabIndexProvider.notifier).state = 1;
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
    final List<Map<String, dynamic>> issueDetails = [
      {'label': 'Mụn', 'key': 'acne', 'color': const Color(0xFFF44336)},
      {
        'label': 'Lỗ chân lông',
        'key': 'pores',
        'color': const Color(0xFF64B5F6)
      },
      {
        'label': 'Sắc tố',
        'key': 'pigmentation',
        'color': const Color(0xFFFF9800)
      },
      {
        'label': 'Nếp nhăn',
        'key': 'wrinkles',
        'color': const Color(0xFF673AB7)
      },
      {'label': 'Kết cấu da', 'key': 'texture', 'color': Colors.teal},
      {'label': 'Mẩn đỏ', 'key': 'redness', 'color': Colors.redAccent},
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
        final score = _getScoreValue(detail['key']);

        return buildInfoCard(
          detail['label'],
          score,
          detail['color'],
        );
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

  Widget buildInfoCard(String title, int score, Color dotColor) {
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
}
