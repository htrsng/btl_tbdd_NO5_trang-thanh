// "Bộ điều khiển từ xa". Nó cho phép các màn hình con (như ResultsStep) "ra lệnh" cho các màn hình cha (như MainScreen hoặc SuggestionsScreen) chuyển tab.
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainTabIndexProvider = StateProvider<int>((ref) => 0);
final suggestionsTabIndexProvider = StateProvider<int>((ref) => 0);
