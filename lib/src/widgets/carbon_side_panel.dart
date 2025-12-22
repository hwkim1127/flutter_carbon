import 'package:flutter/material.dart';

import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../theme/carbon_theme_data.dart';

/// Side panel size variants from Carbon Design System.
enum CarbonSidePanelSize {
  /// Extra small - 16rem (256px)
  xs(256),

  /// Small - 20rem (320px)
  sm(320),

  /// Medium - 28rem (448px)
  md(448),

  /// Large - 36rem (576px)
  lg(576),

  /// Extra large - 42rem (672px)
  xl(672);

  const CarbonSidePanelSize(this.width);

  /// Width in pixels for this size variant.
  final double width;
}

/// Side panel placement (left or right edge).
enum CarbonSidePanelPlacement {
  /// Slide in from the left edge.
  left,

  /// Slide in from the right edge.
  right,
}

/// A Carbon Design System side panel component.
///
/// Side panels slide in from the left or right edge of the screen and are used
/// for secondary tasks, settings, or detailed information.
///
/// Example:
/// ```dart
/// CarbonSidePanel.show(
///   context: context,
///   title: 'Settings',
///   subtitle: 'Manage your preferences',
///   size: CarbonSidePanelSize.md,
///   builder: (context) => SettingsContent(),
///   onSubmit: () {
///     // Save settings
///     Navigator.of(context).pop();
///   },
/// );
/// ```
class CarbonSidePanel extends StatelessWidget {
  /// Creates a Carbon side panel.
  const CarbonSidePanel({
    super.key,
    this.title,
    this.subtitle,
    this.label,
    this.size = CarbonSidePanelSize.md,
    this.placement = CarbonSidePanelPlacement.right,
    this.showCloseButton = true,
    this.actions,
    required this.child,
    this.onClose,
  });

  /// Panel title text.
  final String? title;

  /// Panel subtitle text (appears below title).
  final String? subtitle;

  /// Panel label text (appears above title).
  final String? label;

  /// Size variant of the panel.
  final CarbonSidePanelSize size;

  /// Which edge the panel slides from.
  final CarbonSidePanelPlacement placement;

  /// Whether to show the close button in the header.
  final bool showCloseButton;

  /// Action buttons (typically Cancel and Submit).
  final List<Widget>? actions;

  /// Panel content.
  final Widget child;

  /// Callback when the panel is closed.
  final VoidCallback? onClose;

  /// Shows a side panel as a modal overlay.
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? subtitle,
    String? label,
    CarbonSidePanelSize size = CarbonSidePanelSize.md,
    CarbonSidePanelPlacement placement = CarbonSidePanelPlacement.right,
    bool showCloseButton = true,
    List<Widget>? actions,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return Navigator.of(context).push<T>(
      _CarbonSidePanelRoute<T>(
        builder: builder,
        title: title,
        subtitle: subtitle,
        label: label,
        size: size,
        placement: placement,
        showCloseButton: showCloseButton,
        actions: actions,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final carbon = theme.extension<CarbonThemeData>()!;
    final sidePanelTheme = carbon.sidePanel;

    return Material(
      color: sidePanelTheme.background,
      elevation: 16,
      child: SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(context, sidePanelTheme),

            // Divider
            Divider(
              height: 1,
              thickness: 1,
              color: sidePanelTheme.dividerColor,
            ),

            // Content
            Expanded(child: child),

            // Actions
            if (actions != null && actions!.isNotEmpty) ...[
              Divider(
                height: 1,
                thickness: 1,
                color: sidePanelTheme.dividerColor,
              ),
              _buildActions(sidePanelTheme),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CarbonSidePanelThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (label != null) ...[
                  Text(
                    label!,
                    style: TextStyle(
                      color: theme.labelColor,
                      fontSize: 12,
                      height: 1.33333,
                      letterSpacing: 0.32,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(
                      color: theme.titleColor,
                      fontSize: 20,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (subtitle != null) const SizedBox(height: 8),
                ],
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: theme.subtitleColor,
                      fontSize: 14,
                      height: 1.42857,
                      letterSpacing: 0.16,
                    ),
                  ),
              ],
            ),
          ),
          if (showCloseButton) ...[
            const SizedBox(width: 16),
            IconButton(
              icon: Icon(Icons.close, color: theme.iconColor),
              onPressed: () {
                onClose?.call();
                Navigator.of(context).pop();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(CarbonSidePanelThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (int i = 0; i < actions!.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            actions![i],
          ],
        ],
      ),
    );
  }
}

/// Route for displaying a side panel with slide animation.
class _CarbonSidePanelRoute<T> extends PageRoute<T> {
  _CarbonSidePanelRoute({
    required this.builder,
    this.title,
    this.subtitle,
    this.label,
    this.size = CarbonSidePanelSize.md,
    this.placement = CarbonSidePanelPlacement.right,
    this.showCloseButton = true,
    this.actions,
    this.barrierDismissible = true,
  });

  final WidgetBuilder builder;
  final String? title;
  final String? subtitle;
  final String? label;
  final CarbonSidePanelSize size;
  final CarbonSidePanelPlacement placement;
  final bool showCloseButton;
  final List<Widget>? actions;

  @override
  final bool barrierDismissible;

  @override
  Color? get barrierColor {
    final BuildContext? context = navigator?.context;
    if (context == null) return CarbonPalette.overlay;
    final theme = Theme.of(context);
    final carbon = theme.extension<CarbonThemeData>();
    return carbon?.sidePanel.overlayColor ?? CarbonPalette.overlay;
  }

  @override
  String? get barrierLabel => 'Side Panel';

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => CarbonMotion.durationModerate02;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return CarbonSidePanel(
      title: title,
      subtitle: subtitle,
      label: label,
      size: size,
      placement: placement,
      showCloseButton: showCloseButton,
      actions: actions,
      child: builder(context),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final theme = Theme.of(context);
    final carbon = theme.extension<CarbonThemeData>()!;

    final slideAnimation = Tween<Offset>(
      begin: Offset(
        placement == CarbonSidePanelPlacement.right ? 1.0 : -1.0,
        0,
      ),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

    return Stack(
      children: [
        // Overlay
        FadeTransition(
          opacity: animation,
          child: GestureDetector(
            onTap:
                barrierDismissible ? () => Navigator.of(context).pop() : null,
            child: Container(color: carbon.sidePanel.overlayColor),
          ),
        ),

        // Panel
        Align(
          alignment: placement == CarbonSidePanelPlacement.right
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          child: SlideTransition(position: slideAnimation, child: child),
        ),
      ],
    );
  }
}
