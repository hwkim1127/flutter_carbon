import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

class ModalDemoPage extends StatelessWidget {
  const ModalDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Modal',
      description:
          'Modals interrupt users with content that requires action. Use sparingly as they are disruptive.',
      sections: [
        DemoSection(
          title: 'Passive Modal',
          description: 'Displays information without requiring action.',
          builder: (context) => ElevatedButton(
            onPressed: () {
              CarbonModal.passive(
                context,
                title: 'Passive Modal',
                content: const Text(
                  'This is a passive modal. It provides information but doesn\'t require any action from the user.',
                ),
              );
            },
            child: const Text('Show Passive Modal'),
          ),
        ),
        DemoSection(
          title: 'Transactional Modal',
          description: 'Requires user to complete a task.',
          builder: (context) => ElevatedButton(
            onPressed: () async {
              final result = await CarbonModal.transactional(
                context,
                title: 'Save Changes?',
                content: const Text(
                  'You have unsaved changes. Do you want to save them before closing?',
                ),
                primaryButtonText: 'Save',
                secondaryButtonText: 'Discard',
              );

              if (result == true && context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Changes saved')));
              }
            },
            child: const Text('Show Transactional Modal'),
          ),
        ),
        DemoSection(
          title: 'Danger Modal',
          description: 'Used for destructive actions that cannot be undone.',
          builder: (context) => ElevatedButton(
            onPressed: () async {
              final result = await CarbonModal.danger(
                context,
                title: 'Delete Account?',
                content: const Text(
                  'This action cannot be undone. Your account and all associated data will be permanently deleted.',
                ),
                primaryButtonText: 'Delete',
                secondaryButtonText: 'Cancel',
              );

              if (result == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deleted')),
                );
              }
            },
            child: const Text('Show Danger Modal'),
          ),
        ),
        DemoSection(
          title: 'Input Modal',
          description: 'Contains form inputs for user data entry.',
          builder: (context) => ElevatedButton(
            onPressed: () async {
              final name = await CarbonModal.input(
                context,
                title: 'Enter Name',
                label: 'Name',
                hintText: 'Enter your name',
                primaryButtonText: 'Submit',
                secondaryButtonText: 'Cancel',
              );

              if (name != null && name.isNotEmpty && context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Hello, $name!')));
              }
            },
            child: const Text('Show Input Modal'),
          ),
        ),
        DemoSection(
          title: 'Custom Modal',
          description: 'Use passive modal with custom content.',
          builder: (context) => ElevatedButton(
            onPressed: () {
              CarbonModal.passive(
                context,
                title: 'Custom Content',
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.rocket_launch, size: 48),
                    const SizedBox(height: 16),
                    const Text(
                      'This modal has custom content!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(value: 0.7),
                    const SizedBox(height: 8),
                    const Text('70% Complete'),
                  ],
                ),
              );
            },
            child: const Text('Show Custom Modal'),
          ),
        ),
      ],
    );
  }
}
