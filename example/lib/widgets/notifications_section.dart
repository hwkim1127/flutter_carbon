import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

/// Showcase for Carbon notification widgets and Material SnackBar integration.
class CarbonNotificationsSection extends StatefulWidget {
  const CarbonNotificationsSection({super.key});

  @override
  State<CarbonNotificationsSection> createState() =>
      _CarbonNotificationsSectionState();
}

class _CarbonNotificationsSectionState
    extends State<CarbonNotificationsSection> {
  bool _showInlineInfo = true;
  bool _showInlineSuccess = true;
  bool _showInlineWarning = true;
  bool _showInlineError = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Carbon Inline Notifications
        const Text(
          'Carbon Inline Notifications (Persistent, In-Layout)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Use for important messages within content area. User must dismiss.',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 16),

        if (_showInlineInfo)
          CarbonInlineNotification(
            kind: CarbonNotificationKind.info,
            title: 'Info Notification',
            subtitle: 'This is an informational message with details.',
            onClose: () => setState(() => _showInlineInfo = false),
            actions: [
              TextButton(onPressed: () {}, child: const Text('Action')),
            ],
          ),
        if (_showInlineInfo) const SizedBox(height: 8),

        if (_showInlineSuccess)
          CarbonInlineNotification(
            kind: CarbonNotificationKind.success,
            title: 'Success',
            subtitle: 'Your changes have been saved successfully.',
            onClose: () => setState(() => _showInlineSuccess = false),
          ),
        if (_showInlineSuccess) const SizedBox(height: 8),

        if (_showInlineWarning)
          CarbonInlineNotification(
            kind: CarbonNotificationKind.warning,
            title: 'Warning',
            subtitle: 'Please review your settings before continuing.',
            onClose: () => setState(() => _showInlineWarning = false),
          ),
        if (_showInlineWarning) const SizedBox(height: 8),

        if (_showInlineError)
          CarbonInlineNotification(
            kind: CarbonNotificationKind.error,
            title: 'Error',
            subtitle: 'Failed to connect to the server. Please try again.',
            onClose: () => setState(() => _showInlineError = false),
            actions: [TextButton(onPressed: () {}, child: const Text('Retry'))],
          ),

        const SizedBox(height: 24),

        // Carbon Toast
        const Text(
          'Carbon Toast Notifications (Temporary, Overlay)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Use for non-critical, temporary messages. Auto-dismiss.',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 16),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () {
                showCarbonToast(
                  context,
                  kind: CarbonNotificationKind.info,
                  title: 'Info toast',
                  subtitle: 'Temporary message',
                );
              },
              child: const Text('Show Info Toast'),
            ),
            ElevatedButton(
              onPressed: () {
                showCarbonToast(
                  context,
                  kind: CarbonNotificationKind.success,
                  title: 'Success!',
                  subtitle: 'Operation completed',
                );
              },
              child: const Text('Show Success Toast'),
            ),
            ElevatedButton(
              onPressed: () {
                showCarbonToast(
                  context,
                  kind: CarbonNotificationKind.warning,
                  title: 'Warning',
                  subtitle: 'Check your input',
                );
              },
              child: const Text('Show Warning Toast'),
            ),
            ElevatedButton(
              onPressed: () {
                showCarbonToast(
                  context,
                  kind: CarbonNotificationKind.error,
                  title: 'Error occurred',
                  subtitle: 'Please try again',
                );
              },
              child: const Text('Show Error Toast'),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Material SnackBar
        const Text(
          'Material SnackBar (Simple, Bottom)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Use for simple, transient messages. Lightly themed.',
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 16),

        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('This is a Material SnackBar'),
                action: SnackBarAction(label: 'Undo', onPressed: () {}),
              ),
            );
          },
          child: const Text('Show Material SnackBar'),
        ),
      ],
    );
  }
}
