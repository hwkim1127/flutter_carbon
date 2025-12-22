import 'package:flutter/material.dart';

import '../foundation/motion.dart';
import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';

/// Carbon Design System notification severity levels.
enum CarbonNotificationKind { error, success, warning, info }

/// Carbon Design System inline notification widget.
///
/// Inline notifications are used to communicate information within the content
/// area. They are persistent and require user action to dismiss.
///
/// Example:
/// ```dart
/// CarbonInlineNotification(
///   kind: CarbonNotificationKind.success,
///   title: 'Success',
///   subtitle: 'Your changes have been saved.',
///   onClose: () => setState(() => showNotification = false),
/// )
/// ```
class CarbonInlineNotification extends StatelessWidget {
  /// The notification severity/type.
  final CarbonNotificationKind kind;

  /// The main notification title.
  final String title;

  /// Optional subtitle/description.
  final String? subtitle;

  /// Optional actions to display.
  final List<Widget>? actions;

  /// Called when the close button is pressed.
  final VoidCallback? onClose;

  /// Whether to show the close button.
  final bool showCloseButton;

  /// Whether to use low contrast variant.
  final bool lowContrast;

  const CarbonInlineNotification({
    super.key,
    required this.kind,
    required this.title,
    this.subtitle,
    this.actions,
    this.onClose,
    this.showCloseButton = true,
    this.lowContrast = false,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    // Get colors based on kind
    final backgroundColor = _getBackgroundColor(carbon);
    final iconColor = _getIconColor(carbon);
    final icon = _getIcon();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(left: BorderSide(color: iconColor, width: 3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  title,
                  style: TextStyle(
                    color: carbon.text.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Subtitle
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: carbon.text.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],

                // Actions
                if (actions != null && actions!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(spacing: 8, runSpacing: 8, children: actions!),
                ],
              ],
            ),
          ),

          // Close button
          if (showCloseButton && onClose != null) ...[
            const SizedBox(width: 16),
            InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.zero,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  color: carbon.text.iconPrimary,
                  size: 16,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor(CarbonThemeData carbon) {
    switch (kind) {
      case CarbonNotificationKind.error:
        return carbon.notification.notificationBackgroundError;
      case CarbonNotificationKind.success:
        return carbon.notification.notificationBackgroundSuccess;
      case CarbonNotificationKind.warning:
        return carbon.notification.notificationBackgroundWarning;
      case CarbonNotificationKind.info:
        return carbon.notification.notificationBackgroundInfo;
    }
  }

  Color _getIconColor(CarbonThemeData carbon) {
    switch (kind) {
      case CarbonNotificationKind.error:
        return carbon.status.statusRed;
      case CarbonNotificationKind.success:
        return carbon.status.statusGreen;
      case CarbonNotificationKind.warning:
        return carbon.status.statusYellow;
      case CarbonNotificationKind.info:
        return carbon.status.statusBlue;
    }
  }

  IconData _getIcon() {
    switch (kind) {
      case CarbonNotificationKind.error:
        return Icons.error;
      case CarbonNotificationKind.success:
        return Icons.check_circle;
      case CarbonNotificationKind.warning:
        return Icons.warning;
      case CarbonNotificationKind.info:
        return Icons.info;
    }
  }
}

/// Shows a Carbon-styled toast notification as an overlay.
///
/// Toast notifications appear at the top-right of the screen and auto-dismiss.
/// Use for non-critical, temporary messages.
///
/// Example:
/// ```dart
/// showCarbonToast(
///   context,
///   kind: CarbonNotificationKind.success,
///   title: 'File uploaded',
///   subtitle: 'document.pdf',
///   duration: Duration(seconds: 3),
/// );
/// ```
void showCarbonToast(
  BuildContext context, {
  required CarbonNotificationKind kind,
  required String title,
  String? subtitle,
  Duration duration = const Duration(seconds: 3),
  VoidCallback? onClose,
}) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => _CarbonToast(
      kind: kind,
      title: title,
      subtitle: subtitle,
      onClose: () {
        overlayEntry.remove();
        onClose?.call();
      },
    ),
  );

  overlay.insert(overlayEntry);

  // Auto-dismiss after duration
  Future.delayed(duration, () {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
}

/// Internal widget for toast notifications.
class _CarbonToast extends StatefulWidget {
  final CarbonNotificationKind kind;
  final String title;
  final String? subtitle;
  final VoidCallback onClose;

  const _CarbonToast({
    required this.kind,
    required this.title,
    this.subtitle,
    required this.onClose,
  });

  @override
  State<_CarbonToast> createState() => _CarbonToastState();
}

class _CarbonToastState extends State<_CarbonToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: CarbonMotion.durationFast02,
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleClose() async {
    await _controller.reverse();
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: CarbonInlineNotification(
              kind: widget.kind,
              title: widget.title,
              subtitle: widget.subtitle,
              onClose: _handleClose,
              showCloseButton: true,
            ),
          ),
        ),
      ),
    );
  }
}
