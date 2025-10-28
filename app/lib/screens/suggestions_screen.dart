import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
// Replaced carousel_slider with built-in PageView for cross-platform compatibility
import '../providers/app_state_provider.dart'; // Để lấy analysis

class SuggestionsScreen extends ConsumerWidget {
  const SuggestionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysis = ref.watch(appStateProvider).analysis;

    if (analysis == null) {
      return const Scaffold(
        body: Center(child: Text('Chạy phân tích ở Home trước nhé!')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Gợi Ý Cá Nhân Hóa')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Thói quen cải thiện
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Thói quen hàng ngày',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...analysis.improvements.entries.map(
              (e) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text(e.key),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: e.value
                        .map(
                          (tip) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text('• $tip'),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Sản phẩm gợi ý (carousel)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Sản phẩm phù hợp',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items:
                  analysis.products['general']
                      ?.map(
                        (product) => Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.shopping_bag,
                                size: 50,
                                color: Colors.green,
                              ),
                              Text(product),
                              const Text(
                                'Giá random: 200k - 500k',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList() ??
                  [],
            ),

            const SizedBox(height: 16),

            // Nút mua hàng mock
            ElevatedButton.icon(
              onPressed: () => print('Mở Shopee link: ${analysis.products}'),
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Mua ngay trên Shopee'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
