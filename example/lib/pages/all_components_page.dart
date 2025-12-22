import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/ai_section.dart';
import '../widgets/buttons_section.dart';
import '../widgets/chat_section.dart';
import '../widgets/content_switcher_section.dart';
import '../widgets/layering_section.dart';
import '../widgets/notifications_section.dart';
import '../widgets/section_header.dart';
import '../widgets/skeleton_section.dart';
import '../widgets/status_section.dart';
import '../widgets/syntax_section.dart';
import '../widgets/typography_section.dart';
import '../widgets/material_widgets_section.dart';
import '../widgets/new_carbon_widgets_section.dart';

/// The page displaying all Carbon components in one scrollable view.
class AllComponentsPage extends StatelessWidget {
  const AllComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Components'),
        elevation: 0,
        backgroundColor: carbon.layer.layer01,
        foregroundColor: carbon.text.textPrimary,
      ),
      backgroundColor: carbon.layer.layer01,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          SectionHeader(title: 'Typography'),
          CarbonTypographySection(),
          SizedBox(height: 24),
          SectionHeader(title: 'Buttons'),
          CarbonButtonsSection(),
          SizedBox(height: 24),
          SectionHeader(title: 'Content Switcher'),
          CarbonContentSwitcherSection(),
          SizedBox(height: 24),
          SectionHeader(title: 'Notifications'),
          CarbonNotificationsSection(),
          SizedBox(height: 24),
          SectionHeader(title: 'Status'),
          CarbonStatusSection(),
          SizedBox(height: 24),
          SectionHeader(title: 'Skeleton'),
          CarbonSkeletonSection(),
          SizedBox(height: 24),
          SectionHeader(title: 'Layering'),
          CarbonLayeringSection(),
          SizedBox(height: 24),
          SectionHeader(title: 'Chat'),
          CarbonChatSection(),
          SizedBox(height: 24),
          SectionHeader(title: 'AI'),
          CarbonAISection(),
          SizedBox(height: 24),
          SectionHeader(title: 'Syntax Highlighting'),
          CarbonSyntaxSection(),
          SizedBox(height: 24),
          SectionHeader(title: 'New Carbon Widgets'),
          NewCarbonWidgetsSection(),
          SizedBox(height: 24),
          SectionHeader(title: 'Material Integration'),
          MaterialWidgetsSection(),
        ],
      ),
    );
  }
}
