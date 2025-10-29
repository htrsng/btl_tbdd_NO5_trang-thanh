import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/skin_analysis_model.dart';
import '../providers/app_state_provider.dart';
import '../l10n/app_localizations.dart';

class SuggestionsScreen extends ConsumerWidget {
  const SuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysis = ref.watch(appStateProvider).analysis;
    final l10n = AppLocalizations.of(context)!;

    if (analysis == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.suggestionsTab)),
        body: Center(child: Text(l10n.performAnalysisFirst)),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.suggestionsTitle),
          bottom: TabBar(
            tabs: [
              Tab(icon: const Icon(Icons.spa_outlined), text: l10n.habitsTab),
              Tab(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  text: l10n.productsTab),
              Tab(
                  icon: const Icon(Icons.self_improvement),
                  text: l10n.lifestyleTab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHabitsTab(context, analysis, l10n),
            _buildProductsTab(context, analysis, l10n),
            _buildLifestyleTab(context, analysis, l10n),
          ],
        ),
      ),
    );
  }

  // --- WIDGET CON CHO TỪNG TAB ---

  Widget _buildHabitsTab(
      BuildContext context, SkinAnalysis analysis, AppLocalizations l10n) {
    final improvements = analysis.improvements;
    if (improvements.isEmpty) {
      return Center(child: Text(l10n.noHabitSuggestions));
    }

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: improvements.entries.map((entry) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.key,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...entry.value.map((tip) => Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("• "),
                            Expanded(child: Text(tip))
                          ]),
                    )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProductsTab(
      BuildContext context, SkinAnalysis analysis, AppLocalizations l10n) {
    final List<ProductSuggestion> products = analysis.products;

    if (products.isEmpty) {
      return Center(child: Text(l10n.noProductSuggestions));
    }

    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.8),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
                // Truyền trực tiếp đối tượng ProductSuggestion vào Card
                child: _ProductSuggestionCard(product: product),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          child: ElevatedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(l10n.featureInProgress))),
            icon: const Icon(Icons.shopping_cart_outlined),
            label: Text(l10n.findProductsButton),
          ),
        )
      ],
    );
  }

  Widget _buildLifestyleTab(
      BuildContext context, SkinAnalysis analysis, AppLocalizations l10n) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Text(
            'Gợi ý về lối sống, chế độ ăn uống, và các bài viết hữu ích sẽ được hiển thị ở đây.',
            textAlign: TextAlign.center),
      ),
    );
  }
}

// Widget riêng cho thẻ sản phẩm, giờ đây nhận vào một đối tượng ProductSuggestion
class _ProductSuggestionCard extends StatelessWidget {
  // [SỬA LỖI] - Thay đổi kiểu dữ liệu từ Map sang ProductSuggestion
  final ProductSuggestion product;

  const _ProductSuggestionCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              color: Colors.grey.shade100,
              child: Image.network(
                product.image, // <-- Truy cập trực tiếp, an toàn
                fit: BoxFit.contain,
                errorBuilder: (context, error, stack) => const Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    product.name, // <-- Truy cập trực tiếp
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.brand, // <-- Truy cập trực tiếp
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  Text(
                    product.reason, // <-- Truy cập trực tiếp
                    style: const TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
