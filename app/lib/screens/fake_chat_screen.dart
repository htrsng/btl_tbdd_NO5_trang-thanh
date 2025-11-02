import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';

class FakeChatScreen extends ConsumerWidget {
  const FakeChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chatWithAITitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Tin nhắn "mồi" từ Bot
                _ChatBubble(
                  text: l10n.chatInitialMessage,
                  isFromUser: false,
                  // [CẢI TIẾN] - Sử dụng màu từ theme
                  color: theme.colorScheme.primary.withAlpha(30),
                  textColor: theme.textTheme.bodyLarge?.color ?? Colors.black87,
                ),
              ],
            ),
          ),

          // Thanh nhập liệu bị vô hiệu hóa
          _buildFakeInput(context, l10n),
        ],
      ),
    );
  }

  // Widget con cho thanh nhập liệu
  Widget _buildFakeInput(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border:
            Border(top: BorderSide(color: Colors.grey.shade300, width: 1.0)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: l10n.chatPlaceholder,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.send, color: Colors.grey.shade400),
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget con cho bong bóng chat
class _ChatBubble extends StatelessWidget {
  final String text;
  final bool isFromUser;
  final Color color;
  final Color textColor;

  const _ChatBubble({
    required this.text,
    required this.isFromUser,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isFromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(text, style: TextStyle(color: textColor, height: 1.4)),
      ),
    );
  }
}
