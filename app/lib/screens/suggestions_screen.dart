import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/skin_analysis_model.dart';
import '../providers/app_state_provider.dart';
import '../providers/navigation_provider.dart'; // Import provider điều hướng
import '../l10n/app_localizations.dart';

// [CẢI TIẾN #1] - Chuyển sang ConsumerStatefulWidget để quản lý TabController
class SuggestionsScreen extends ConsumerStatefulWidget {
  const SuggestionsScreen({super.key});

  @override
  ConsumerState<SuggestionsScreen> createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends ConsumerState<SuggestionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Lắng nghe sự thay đổi từ provider để chuyển tab bằng code
    // Điều này giúp nút "Nhiều hơn >>" từ ResultsStep hoạt động
    ref.listenManual(suggestionsTabIndexProvider, (previous, next) {
      if (_tabController.index != next) {
        _tabController.animateTo(next);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analysis = ref.watch(appStateProvider).analysis;
    final l10n = AppLocalizations.of(context)!;

    if (analysis == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.suggestionsTab)),
        body: Center(child: Text(l10n.performAnalysisFirst)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.suggestionsTitle),
        bottom: TabBar(
          controller: _tabController, // Sử dụng controller của chúng ta
          tabs: [
            Tab(icon: const Icon(Icons.spa_outlined), text: l10n.habitsTab),
            Tab(icon: const Icon(Icons.shopping_bag_outlined), text: l10n.productsTab),
            Tab(icon: const Icon(Icons.self_improvement), text: l10n.lifestyleTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHabitsTab(context, analysis, l10n),
          _buildProductsTab(context, analysis, l10n),
          _buildLifestyleTab(context, analysis, l10n),
        ],
      ),
    );
  }

  // --- WIDGET CON CHO TỪNG TAB ---

  Widget _buildHabitsTab(BuildContext context, SkinAnalysis analysis, AppLocalizations l10n) {
    final improvements = analysis.improvements;
    if (improvements.isEmpty) return Center(child: Text(l10n.noHabitSuggestions));

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
    final List<ProductSuggestion> products = analysis.products;
    if (products.isEmpty) return Center(child: Text(l10n.noProductSuggestions));
    
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

  // [CẢI TIẾN #2] - Nâng cấp tab Lối sống
  Widget _buildLifestyleTab(BuildContext context, SkinAnalysis analysis, AppLocalizations l10n) {
    final tips = [
      {'title': l10n.lifestyleTip1Title, 'subtitle': l10n.lifestyleTip1Subtitle, 'image': 'https://images.unsplash.com/photo-1548883354-94bcfe321c25?w=500&q=80'},
      {'title': l10n.lifestyleTip2Title, 'subtitle': l10n.lifestyleTip2Subtitle, 'image': 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=500&q=80'},
      {'title': l10n.lifestyleTip3Title, 'subtitle': l10n.lifestyleTip3Subtitle, 'image': 'https://images.unsplash.com/photo-1596701062351-8c2c141e1b9c?w=500&q=80'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: tips.length,
      itemBuilder: (context, index) {
        return _LifestyleTipCard(
          title: tips[index]['title']!,
          subtitle: tips[index]['subtitle']!,
          imageUrl: tips[index]['image']!,
        );
      },
    );
  }
}

// Widget con cho thẻ sản phẩm (giữ nguyên)
class _ProductSuggestionCard extends StatelessWidget { /* ... */ }

// [THÊM MỚI] - Widget con cho thẻ mẹo lối sống
class _LifestyleTipCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const _LifestyleTipCard({required this.title, required this.subtitle, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16.0),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade700, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}