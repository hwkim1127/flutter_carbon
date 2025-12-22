import 'package:flutter/material.dart';

@immutable
class CarbonChatThemeData extends ThemeExtension<CarbonChatThemeData> {
  final Color chatPromptBackground;
  final Color chatPromptBorderStart;
  final Color chatPromptBorderEnd;
  final Color chatPromptText;
  final Color chatBubbleUser;
  final Color chatBubbleUserText;
  final Color chatBubbleAgent;
  final Color chatBubbleAgentText;
  final Color chatBubbleBorder;
  final Color chatAvatarBot;
  final Color chatAvatarAgent;
  final Color chatAvatarUser;
  final Color chatShellBackground;
  final Color chatHeaderBackground;
  final Color chatHeaderText;
  final Color chatButton;
  final Color chatButtonHover;
  final Color chatButtonTextHover;
  final Color chatButtonActive;
  final Color chatButtonSelected;
  final Color chatButtonTextSelected;

  const CarbonChatThemeData({
    required this.chatPromptBackground,
    required this.chatPromptBorderStart,
    required this.chatPromptBorderEnd,
    required this.chatPromptText,
    required this.chatBubbleUser,
    required this.chatBubbleUserText,
    required this.chatBubbleAgent,
    required this.chatBubbleAgentText,
    required this.chatBubbleBorder,
    required this.chatAvatarBot,
    required this.chatAvatarAgent,
    required this.chatAvatarUser,
    required this.chatShellBackground,
    required this.chatHeaderBackground,
    required this.chatHeaderText,
    required this.chatButton,
    required this.chatButtonHover,
    required this.chatButtonTextHover,
    required this.chatButtonActive,
    required this.chatButtonSelected,
    required this.chatButtonTextSelected,
  });

  @override
  CarbonChatThemeData copyWith({
    Color? chatPromptBackground,
    Color? chatPromptBorderStart,
    Color? chatPromptBorderEnd,
    Color? chatPromptText,
    Color? chatBubbleUser,
    Color? chatBubbleUserText,
    Color? chatBubbleAgent,
    Color? chatBubbleAgentText,
    Color? chatBubbleBorder,
    Color? chatAvatarBot,
    Color? chatAvatarAgent,
    Color? chatAvatarUser,
    Color? chatShellBackground,
    Color? chatHeaderBackground,
    Color? chatHeaderText,
    Color? chatButton,
    Color? chatButtonHover,
    Color? chatButtonTextHover,
    Color? chatButtonActive,
    Color? chatButtonSelected,
    Color? chatButtonTextSelected,
  }) {
    return CarbonChatThemeData(
      chatPromptBackground: chatPromptBackground ?? this.chatPromptBackground,
      chatPromptBorderStart:
          chatPromptBorderStart ?? this.chatPromptBorderStart,
      chatPromptBorderEnd: chatPromptBorderEnd ?? this.chatPromptBorderEnd,
      chatPromptText: chatPromptText ?? this.chatPromptText,
      chatBubbleUser: chatBubbleUser ?? this.chatBubbleUser,
      chatBubbleUserText: chatBubbleUserText ?? this.chatBubbleUserText,
      chatBubbleAgent: chatBubbleAgent ?? this.chatBubbleAgent,
      chatBubbleAgentText: chatBubbleAgentText ?? this.chatBubbleAgentText,
      chatBubbleBorder: chatBubbleBorder ?? this.chatBubbleBorder,
      chatAvatarBot: chatAvatarBot ?? this.chatAvatarBot,
      chatAvatarAgent: chatAvatarAgent ?? this.chatAvatarAgent,
      chatAvatarUser: chatAvatarUser ?? this.chatAvatarUser,
      chatShellBackground: chatShellBackground ?? this.chatShellBackground,
      chatHeaderBackground: chatHeaderBackground ?? this.chatHeaderBackground,
      chatHeaderText: chatHeaderText ?? this.chatHeaderText,
      chatButton: chatButton ?? this.chatButton,
      chatButtonHover: chatButtonHover ?? this.chatButtonHover,
      chatButtonTextHover: chatButtonTextHover ?? this.chatButtonTextHover,
      chatButtonActive: chatButtonActive ?? this.chatButtonActive,
      chatButtonSelected: chatButtonSelected ?? this.chatButtonSelected,
      chatButtonTextSelected:
          chatButtonTextSelected ?? this.chatButtonTextSelected,
    );
  }

  @override
  CarbonChatThemeData lerp(
    ThemeExtension<CarbonChatThemeData>? other,
    double t,
  ) {
    if (other is! CarbonChatThemeData) return this;
    return CarbonChatThemeData(
      chatPromptBackground: Color.lerp(
        chatPromptBackground,
        other.chatPromptBackground,
        t,
      )!,
      chatPromptBorderStart: Color.lerp(
        chatPromptBorderStart,
        other.chatPromptBorderStart,
        t,
      )!,
      chatPromptBorderEnd: Color.lerp(
        chatPromptBorderEnd,
        other.chatPromptBorderEnd,
        t,
      )!,
      chatPromptText: Color.lerp(chatPromptText, other.chatPromptText, t)!,
      chatBubbleUser: Color.lerp(chatBubbleUser, other.chatBubbleUser, t)!,
      chatBubbleUserText: Color.lerp(
        chatBubbleUserText,
        other.chatBubbleUserText,
        t,
      )!,
      chatBubbleAgent: Color.lerp(chatBubbleAgent, other.chatBubbleAgent, t)!,
      chatBubbleAgentText: Color.lerp(
        chatBubbleAgentText,
        other.chatBubbleAgentText,
        t,
      )!,
      chatBubbleBorder: Color.lerp(
        chatBubbleBorder,
        other.chatBubbleBorder,
        t,
      )!,
      chatAvatarBot: Color.lerp(chatAvatarBot, other.chatAvatarBot, t)!,
      chatAvatarAgent: Color.lerp(chatAvatarAgent, other.chatAvatarAgent, t)!,
      chatAvatarUser: Color.lerp(chatAvatarUser, other.chatAvatarUser, t)!,
      chatShellBackground: Color.lerp(
        chatShellBackground,
        other.chatShellBackground,
        t,
      )!,
      chatHeaderBackground: Color.lerp(
        chatHeaderBackground,
        other.chatHeaderBackground,
        t,
      )!,
      chatHeaderText: Color.lerp(chatHeaderText, other.chatHeaderText, t)!,
      chatButton: Color.lerp(chatButton, other.chatButton, t)!,
      chatButtonHover: Color.lerp(chatButtonHover, other.chatButtonHover, t)!,
      chatButtonTextHover: Color.lerp(
        chatButtonTextHover,
        other.chatButtonTextHover,
        t,
      )!,
      chatButtonActive: Color.lerp(
        chatButtonActive,
        other.chatButtonActive,
        t,
      )!,
      chatButtonSelected: Color.lerp(
        chatButtonSelected,
        other.chatButtonSelected,
        t,
      )!,
      chatButtonTextSelected: Color.lerp(
        chatButtonTextSelected,
        other.chatButtonTextSelected,
        t,
      )!,
    );
  }
}
