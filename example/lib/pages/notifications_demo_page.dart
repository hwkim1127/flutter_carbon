import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for CarbonInlineNotification component.
class NotificationsDemoPage extends StatefulWidget {
  const NotificationsDemoPage({super.key});

  @override
  State<NotificationsDemoPage> createState() => _NotificationsDemoPageState();
}

class _NotificationsDemoPageState extends State<NotificationsDemoPage> {
  bool _showInline = true;

  void _showToastNotification(
    BuildContext context,
    CarbonNotificationKind kind,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CarbonInlineNotification(
          kind: kind,
          title: 'Toast notification',
          subtitle: 'This is a toast notification message.',
          lowContrast: true,
          onClose: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.all(0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Notifications',
      description:
          'Notifications provide feedback to users about system status, user actions, or important information.',
      sections: [
        DemoSection(
          title: 'Inline Notifications',
          description: 'Notifications embedded in the page content',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_showInline) ...[
                CarbonInlineNotification(
                  kind: CarbonNotificationKind.info,
                  title: 'Info notification',
                  subtitle:
                      'This is an informational message with additional details.',
                  onClose: () {
                    setState(() {
                      _showInline = false;
                    });
                  },
                ),
                const SizedBox(height: 8),
                CarbonInlineNotification(
                  kind: CarbonNotificationKind.success,
                  title: 'Success notification',
                  subtitle: 'Your changes have been successfully saved.',
                  onClose: () {},
                ),
                const SizedBox(height: 8),
                CarbonInlineNotification(
                  kind: CarbonNotificationKind.warning,
                  title: 'Warning notification',
                  subtitle:
                      'This action may have unintended consequences. Please review before proceeding.',
                  onClose: () {},
                ),
                const SizedBox(height: 8),
                CarbonInlineNotification(
                  kind: CarbonNotificationKind.error,
                  title: 'Error notification',
                  subtitle:
                      'An error occurred while processing your request. Please try again.',
                  onClose: () {},
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showInline = true;
                    });
                  },
                  child: const Text('Show Inline Notifications'),
                ),
              ],
            ],
          ),
        ),
        DemoSection(
          title: 'Low Contrast Notifications',
          description: 'Notifications with reduced visual prominence',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonInlineNotification(
                kind: CarbonNotificationKind.info,
                title: 'Low contrast info',
                subtitle: 'Less visually prominent notification.',
                lowContrast: true,
                onClose: () {},
              ),
              const SizedBox(height: 8),
              CarbonInlineNotification(
                kind: CarbonNotificationKind.success,
                title: 'Low contrast success',
                subtitle: 'Subtler success indication.',
                lowContrast: true,
                onClose: () {},
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Notifications with Actions',
          description: 'Notifications with interactive action buttons',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonInlineNotification(
                kind: CarbonNotificationKind.info,
                title: 'Update available',
                subtitle:
                    'A new version of the application is available. Would you like to update now?',
                actions: [
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Updating...')),
                      );
                    },
                    child: const Text('Update now'),
                  ),
                ],
                onClose: () {},
              ),
              const SizedBox(height: 8),
              CarbonInlineNotification(
                kind: CarbonNotificationKind.warning,
                title: 'Session expiring soon',
                subtitle: 'Your session will expire in 5 minutes.',
                actions: [
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Session extended')),
                      );
                    },
                    child: const Text('Extend session'),
                  ),
                ],
                onClose: () {},
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Toast Notifications',
          description:
              'Temporary notifications that appear as overlays (click buttons to show)',
          builder: (context) => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                onPressed: () {
                  _showToastNotification(context, CarbonNotificationKind.info);
                },
                child: const Text('Show Info Toast'),
              ),
              ElevatedButton(
                onPressed: () {
                  _showToastNotification(
                    context,
                    CarbonNotificationKind.success,
                  );
                },
                child: const Text('Show Success Toast'),
              ),
              ElevatedButton(
                onPressed: () {
                  _showToastNotification(
                    context,
                    CarbonNotificationKind.warning,
                  );
                },
                child: const Text('Show Warning Toast'),
              ),
              ElevatedButton(
                onPressed: () {
                  _showToastNotification(context, CarbonNotificationKind.error);
                },
                child: const Text('Show Error Toast'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Title-Only Notifications',
          description: 'Compact notifications with title only',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarbonInlineNotification(
                kind: CarbonNotificationKind.success,
                title: 'File uploaded successfully',
                onClose: () {},
              ),
              const SizedBox(height: 8),
              CarbonInlineNotification(
                kind: CarbonNotificationKind.error,
                title: 'Connection failed',
                onClose: () {},
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Non-dismissible Notifications',
          description: 'Notifications that cannot be closed by the user',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CarbonInlineNotification(
                kind: CarbonNotificationKind.warning,
                title: 'Maintenance mode',
                subtitle:
                    'The system is currently in maintenance mode. Some features may be unavailable.',
                showCloseButton: false,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
