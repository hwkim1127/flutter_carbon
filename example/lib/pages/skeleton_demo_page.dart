import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonSkeleton component.
class SkeletonDemoPage extends StatefulWidget {
  const SkeletonDemoPage({super.key});

  @override
  State<SkeletonDemoPage> createState() => _SkeletonDemoPageState();
}

class _SkeletonDemoPageState extends State<SkeletonDemoPage> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Skeleton',
      description:
          'Skeleton states are used as a progressive loading state to indicate that content is being loaded.',
      sections: [
        DemoSection(
          title: 'Text Skeleton',
          description: 'Loading placeholder for text content',
          builder: (context) =>
              CarbonSkeleton.text(lines: 3, lineHeight: 16, spacing: 8),
        ),
        DemoSection(
          title: 'Heading Skeleton',
          description: 'Loading placeholder for heading text',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CarbonSkeleton(width: 250, height: 24),
              const SizedBox(height: 16),
              CarbonSkeleton.text(lines: 2, lineHeight: 16, spacing: 8),
            ],
          ),
        ),
        DemoSection(
          title: 'Rectangle Skeleton',
          description: 'Loading placeholder for images or cards',
          builder: (context) => const CarbonSkeleton.rectangle(
            width: double.infinity,
            height: 200,
          ),
        ),
        DemoSection(
          title: 'Circle Skeleton',
          description: 'Loading placeholder for circular images or avatars',
          builder: (context) => const Row(
            children: [
              CarbonSkeleton.circle(size: 48),
              SizedBox(width: 16),
              CarbonSkeleton.circle(size: 64),
              SizedBox(width: 16),
              CarbonSkeleton.circle(size: 96),
            ],
          ),
        ),
        DemoSection(
          title: 'Card Skeleton',
          description: 'Complete card loading state',
          builder: (context) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: context.carbon.layer.borderSubtle01),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    CarbonSkeleton.circle(size: 48),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CarbonSkeleton(width: 120, height: 16),
                          SizedBox(height: 8),
                          CarbonSkeleton(width: 80, height: 14),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const CarbonSkeleton.rectangle(
                  width: double.infinity,
                  height: 150,
                ),
                const SizedBox(height: 16),
                CarbonSkeleton.text(lines: 3, lineHeight: 14, spacing: 8),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'List Skeleton',
          description: 'Loading state for lists',
          builder: (context) => Column(
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    const CarbonSkeleton.circle(size: 40),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CarbonSkeleton.text(
                        lines: 2,
                        lineHeight: 14,
                        spacing: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        DemoSection(
          title: 'Toggle Content Loading',
          description: 'Switch between skeleton and actual content',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = !_isLoading;
                  });
                },
                child: Text(_isLoading ? 'Load Content' : 'Show Skeleton'),
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CarbonSkeleton(width: 200, height: 24),
                    const SizedBox(height: 16),
                    CarbonSkeleton.text(lines: 3, lineHeight: 14, spacing: 8),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Content Title',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.carbon.text.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'This is the actual content that was loaded. It replaces the skeleton loading state once the data is available.',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.carbon.text.textPrimary,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        DemoSection(
          title: 'Skeleton Without Animation',
          description: 'Static skeleton without shimmer effect',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CarbonSkeleton(width: 200, height: 24, animate: false),
              const SizedBox(height: 12),
              CarbonSkeleton.text(
                lines: 2,
                lineHeight: 16,
                spacing: 8,
                animate: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
