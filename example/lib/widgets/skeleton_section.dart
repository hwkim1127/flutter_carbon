import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

class CarbonSkeletonSection extends StatelessWidget {
  const CarbonSkeletonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skeleton Loaders (Animated)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Example 1: Rectangle skeletons
        const Text('Rectangle variants:', style: TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        const CarbonSkeleton.rectangle(width: 200, height: 24),
        const SizedBox(height: 12),

        // Example 2: Text skeleton (multiple lines)
        const Text('Text skeleton (3 lines):', style: TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        CarbonSkeleton.text(
          lines: 3,
          lineHeight: 16,
          spacing: 8,
          lastLineWidth: 0.6,
        ),
        const SizedBox(height: 12),

        // Example 3: Circle skeleton (avatar)
        const Text('Circle skeleton (avatar):', style: TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        Row(
          children: const [
            CarbonSkeleton.circle(size: 48),
            SizedBox(width: 16),
            CarbonSkeleton.circle(size: 64),
            SizedBox(width: 16),
            CarbonSkeleton.circle(size: 32),
          ],
        ),
        const SizedBox(height: 12),

        // Example 4: Card skeleton
        const Text('Card skeleton:', style: TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CarbonSkeleton.circle(size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: CarbonSkeleton.text(
                  lines: 2,
                  lineHeight: 14,
                  spacing: 6,
                  lastLineWidth: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Example 5: Non-animated skeleton
        const Text('Static (no animation):', style: TextStyle(fontSize: 12)),
        const SizedBox(height: 8),
        const CarbonSkeleton.rectangle(width: 150, height: 20, animate: false),
      ],
    );
  }
}
