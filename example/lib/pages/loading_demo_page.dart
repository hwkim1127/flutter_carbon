import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonLoading component.
class LoadingDemoPage extends StatefulWidget {
  const LoadingDemoPage({super.key});

  @override
  State<LoadingDemoPage> createState() => _LoadingDemoPageState();
}

class _LoadingDemoPageState extends State<LoadingDemoPage> {
  bool _isLoadingOverlay = false;
  bool _isInlineLoading = false;

  Future<void> _simulateLoading() async {
    setState(() {
      _isInlineLoading = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isInlineLoading = false;
    });
  }

  Future<void> _simulateOverlayLoading() async {
    setState(() {
      _isLoadingOverlay = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isLoadingOverlay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DemoPageTemplate(
          title: 'Loading',
          description:
              'Loading indicators show that content is being loaded or an action is being processed.',
          sections: [
            DemoSection(
              title: 'Default Loading Spinner',
              description: 'Standard loading spinner',
              builder: (context) => const Center(child: CarbonLoading()),
            ),
            DemoSection(
              title: 'Small Loading Spinner',
              description: 'Compact loading spinner for inline use',
              builder: (context) => const Center(
                child: CarbonLoading(size: CarbonLoadingSize.small),
              ),
            ),
            DemoSection(
              title: 'Loading with Description',
              description: 'Loading spinner with descriptive text',
              builder: (context) => const Center(
                child: CarbonLoading(
                  description: 'Loading data...',
                  withOverlay: false,
                ),
              ),
            ),
            DemoSection(
              title: 'Inline Loading',
              description: 'Loading indicator used inline with content',
              builder: (context) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: _isInlineLoading ? null : _simulateLoading,
                    child: const Text('Trigger Inline Loading'),
                  ),
                  const SizedBox(height: 16),
                  if (_isInlineLoading)
                    const CarbonInlineLoading(
                      status: CarbonInlineLoadingStatus.active,
                      description: 'Loading content...',
                    )
                  else
                    const CarbonInlineLoading(
                      status: CarbonInlineLoadingStatus.finished,
                      description: 'Content loaded',
                    ),
                ],
              ),
            ),
            DemoSection(
              title: 'Inline Loading States',
              description: 'Different states of inline loading indicator',
              builder: (context) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CarbonInlineLoading(
                    status: CarbonInlineLoadingStatus.inactive,
                    description: 'Inactive state',
                  ),
                  const SizedBox(height: 16),
                  const CarbonInlineLoading(
                    status: CarbonInlineLoadingStatus.active,
                    description: 'Loading in progress...',
                  ),
                  const SizedBox(height: 16),
                  const CarbonInlineLoading(
                    status: CarbonInlineLoadingStatus.finished,
                    description: 'Successfully completed',
                  ),
                  const SizedBox(height: 16),
                  const CarbonInlineLoading(
                    status: CarbonInlineLoadingStatus.error,
                    description: 'An error occurred',
                  ),
                ],
              ),
            ),
            DemoSection(
              title: 'Overlay Loading',
              description:
                  'Full-screen loading overlay (click button to trigger)',
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: _isLoadingOverlay ? null : _simulateOverlayLoading,
                  child: const Text('Show Loading Overlay'),
                ),
              ),
            ),
            DemoSection(
              title: 'Loading in Cards',
              description: 'Loading states within card components',
              builder: (context) => Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: context.carbon.layer.borderSubtle01,
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CarbonLoading(
                            size: CarbonLoadingSize.small,
                            withOverlay: false,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Loading card content...',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: context.carbon.layer.borderSubtle01,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Card Title',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: context.carbon.text.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Some loaded content here.',
                            style: TextStyle(
                              fontSize: 14,
                              color: context.carbon.text.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (_isLoadingOverlay)
          Scaffold(
            backgroundColor: CarbonPalette.overlay,
            body: Center(
              child: const CarbonLoading(
                description: 'Processing... Please wait.',
                withOverlay: true,
              ),
            ),
          ),
      ],
    );
  }
}
