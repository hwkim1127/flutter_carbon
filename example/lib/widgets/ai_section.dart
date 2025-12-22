import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

class CarbonAISection extends StatelessWidget {
  const CarbonAISection({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [carbon.ai.aiAuraStart, carbon.ai.aiAuraEnd],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Aura & Popover',
                style: TextStyle(
                  color: carbon.text.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: carbon.ai.aiPopoverBackground,
                  boxShadow: [
                    BoxShadow(
                      color: carbon.ai.aiPopoverShadowOuter01,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(color: carbon.ai.aiBorderStrong),
                ),
                child: Column(
                  children: [
                    Text(
                      'AI Generated Content',
                      style: TextStyle(color: carbon.text.textPrimary),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 8,
                            color: carbon.ai.aiSkeletonElementBackground,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 8,
                            color: carbon.ai.aiSkeletonElementBackground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
