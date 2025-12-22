import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

class TearsheetDemoPage extends StatelessWidget {
  const TearsheetDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Tearsheet',
      description:
          'Tearsheets are full-height panels that slide in from the bottom. Use for complex workflows or detailed information.',
      sections: [
        DemoSection(
          title: 'Basic Tearsheet',
          description: 'Simple tearsheet with title and content.',
          builder: (context) => ElevatedButton(
            onPressed: () {
              CarbonTearsheet.show(
                context: context,
                title: 'Tearsheet Title',
                description: 'This is a description of the tearsheet',
                builder: (context) => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'This is the content of the tearsheet. '
                    'Tearsheets slide in from the bottom and are full-height.',
                  ),
                ),
              );
            },
            child: const Text('Show Basic Tearsheet'),
          ),
        ),
        DemoSection(
          title: 'With Label',
          description: 'Tearsheet with label above title.',
          builder: (context) => ElevatedButton(
            onPressed: () {
              CarbonTearsheet.show(
                context: context,
                label: 'STEP 1 OF 3',
                title: 'Create Resource',
                description: 'Enter the details for your new resource',
                builder: (context) => ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  children: const [
                    TextField(
                      decoration: InputDecoration(labelText: 'Resource Name'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    ),
                  ],
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Continue'),
                  ),
                ],
              );
            },
            child: const Text('Show with Label'),
          ),
        ),
        DemoSection(
          title: 'Wide Tearsheet',
          description: 'Wider tearsheet (960px) for more complex content.',
          builder: (context) => ElevatedButton(
            onPressed: () {
              CarbonTearsheet.show(
                context: context,
                title: 'Wide Tearsheet',
                description: 'This tearsheet has more horizontal space',
                width: CarbonTearsheetWidth.wide,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Column 1',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Content for column 1'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Column 2',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Content for column 2'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Submit'),
                  ),
                ],
              );
            },
            child: const Text('Show Wide Tearsheet'),
          ),
        ),
        DemoSection(
          title: 'With Header Actions',
          description: 'Wide tearsheet with actions in the header (wide only).',
          builder: (context) => ElevatedButton(
            onPressed: () {
              CarbonTearsheet.show(
                context: context,
                title: 'Document Editor',
                description: 'Edit your document',
                width: CarbonTearsheetWidth.wide,
                headerActions: [
                  IconButton(
                    icon: const Icon(Icons.print),
                    onPressed: () {},
                    tooltip: 'Print',
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {},
                    tooltip: 'Share',
                  ),
                ],
                builder: (context) => const Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(
                    decoration: InputDecoration(labelText: 'Document content'),
                    maxLines: 10,
                  ),
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Save'),
                  ),
                ],
              );
            },
            child: const Text('Show with Header Actions'),
          ),
        ),
        DemoSection(
          title: 'With Influencer Section',
          description: 'Wide tearsheet with side influencer panel (wide only).',
          builder: (context) => ElevatedButton(
            onPressed: () {
              CarbonTearsheet.show(
                context: context,
                title: 'Configure Deployment',
                description: 'Set up your deployment configuration',
                width: CarbonTearsheetWidth.wide,
                influencer: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Tips',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('• Choose a region close to your users'),
                    const SizedBox(height: 8),
                    const Text('• Enable auto-scaling for production'),
                    const SizedBox(height: 8),
                    const Text('• Configure health checks'),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    const Text(
                      'Resources',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Documentation'),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Best Practices'),
                    ),
                  ],
                ),
                influencerPlacement: CarbonTearsheetInfluencerPlacement.right,
                builder: (context) => ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  children: const [
                    TextField(decoration: InputDecoration(labelText: 'Region')),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(labelText: 'Instance Type'),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(labelText: 'Environment'),
                    ),
                  ],
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Deploy'),
                  ),
                ],
              );
            },
            child: const Text('Show with Influencer'),
          ),
        ),
      ],
    );
  }
}
