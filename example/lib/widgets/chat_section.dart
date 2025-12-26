import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

class CarbonChatSection extends StatelessWidget {
  const CarbonChatSection({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Column(
      children: [
        _ChatBubble(
          text: 'Hello! How can I help you?',
          bg: carbon.chat.chatBubbleAgent,
          textColor: carbon.chat.chatBubbleAgentText,
          isUser: false,
          avatarColor: carbon.chat.chatAvatarAgent,
        ),
        const SizedBox(height: 16),
        _ChatBubble(
          text: 'Show me the Carbon Chat tokens.',
          bg: carbon.chat.chatBubbleUser,
          textColor: carbon.chat.chatBubbleUserText,
          isUser: true,
          avatarColor: carbon.chat.chatAvatarUser,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: carbon.chat.chatPromptBackground,
            border: Border(
              top: BorderSide(color: carbon.chat.chatPromptBorderStart),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.add, color: carbon.text.iconPrimary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Type a message...',
                  style: TextStyle(color: carbon.chat.chatPromptText),
                ),
              ),
              Icon(Icons.send, color: carbon.chat.chatButton),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String text;
  final Color bg;
  final Color textColor;
  final bool isUser;
  final Color avatarColor;

  const _ChatBubble({
    required this.text,
    required this.bg,
    required this.textColor,
    required this.isUser,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isUser) ...[
          CircleAvatar(
            backgroundColor: avatarColor,
            radius: 16,
            child: const Icon(Icons.smart_toy, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
        ],
        Container(
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(maxWidth: 250),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
              bottomRight: isUser ? Radius.zero : const Radius.circular(16),
            ),
          ),
          child: Text(text, style: TextStyle(color: textColor)),
        ),
        if (isUser) ...[
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: avatarColor,
            radius: 16,
            child: const Icon(Icons.person, size: 16, color: Colors.white),
          ),
        ],
      ],
    );
  }
}
