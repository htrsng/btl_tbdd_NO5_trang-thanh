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
              Tab(icon: const Icon(Icons.shopping_bag_outlined), text: l10n.productsTab),
              Tab(icon: const Icon(Icons.self_improvement), text: l10n.lifestyleTab),
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

  Widget _buildHabitsTab(BuildContext context, SkinAnalysis analysis, AppLocalizations l10n) {
    // ... code giữ nguyên
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
                Text(entry.key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...entry.value.map((tip) => ListTile(
                  leading: Icon(Icons.check_circle_outline, color: Theme.of(context).colorScheme.primary),
                  title: Text(tip),
                  contentPadding: EdgeInsets.zero,
                )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProductsTab(BuildContext context, SkinAnalysis analysis, AppLocalizations l10n) {
    // ... code giữ nguyên
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
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
                child: _ProductSuggestionCard(product: products[index]),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
          child: ElevatedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.featureInProgress))),
            icon: const Icon(Icons.shopping_cart_outlined),
            label: Text(l10n.findProductsButton),
          ),
        )
      ],
    );
  }

  Widget _buildLifestyleTab(BuildContext context, SkinAnalysis analysis, AppLocalizations l10n) {
    // ... code giữ nguyên
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Text('Gợi ý về lối sống, chế độ ăn uống, và các bài viết hữu ích sẽ được hiển thị ở đây.', textAlign: TextAlign.center),
      ),
    );
  }
}

// [SỬA LỖI TẠI ĐÂY] - Cung cấp lại đầy đủ định nghĩa cho class _ProductSuggestionCard
class _ProductSuggestionCard extends StatelessWidget {
  final ProductSuggestion product;

  // Constructor đúng để nhận tham số 'product'
  const _ProductSuggestionCard({required this.product});

  // Hàm 'build' đã bị thiếu
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
                product.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stack) => const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
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
                    product.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    product.brand,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  Text(
                    product.reason,
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