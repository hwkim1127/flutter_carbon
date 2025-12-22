import 'package:flutter/material.dart';

import '../foundation/colors.dart';
import '../foundation/motion.dart';
import '../theme/carbon_theme_data.dart';

/// Tearsheet width variants from Carbon Design System.
enum CarbonTearsheetWidth {
  /// Narrow width - 512px
  narrow,

  /// Wide width - 960px
  wide,
}

/// Tearsheet influencer placement (left or right side).
enum CarbonTearsheetInfluencerPlacement {
  /// Left side of content
  left,

  /// Right side of content
  right,
}

/// Tearsheet influencer width variants.
enum CarbonTearsheetInfluencerWidth {
  /// Narrow influencer width
  narrow,

  /// Wide influencer width
  wide,
}

/// A Carbon Design System tearsheet component.
///
/// Tearsheets are full-height panels that slide in from the bottom of the screen
/// and are used for complex workflows or detailed information.
///
/// Example:
/// ```dart
/// CarbonTearsheet.show(
///   context: context,
///   title: 'Create new resource',
///   description: 'Configure your resource settings',
///   width: CarbonTearsheetWidth.wide,
///   builder: (context) => ResourceForm(),
///   actions: [
///     TextButton(
///       onPressed: () => Navigator.of(context).pop(),
///       child: Text('Cancel'),
///     ),
///     FilledButton(
///       onPressed: () {
///         // Save and close
///         Navigator.of(context).pop();
///       },
///       child: Text('Create'),
///     ),
///   ],
/// );
/// ```
class CarbonTearsheet extends StatelessWidget {
  /// Creates a Carbon tearsheet.
  const CarbonTearsheet({
    super.key,
    this.title,
    this.description,
    this.label,
    this.width = CarbonTearsheetWidth.narrow,
    this.showCloseButton = true,
    this.actions,
    this.headerActions,
    this.headerNavigation,
    this.influencer,
    this.influencerPlacement = CarbonTearsheetInfluencerPlacement.right,
    this.influencerWidth = CarbonTearsheetInfluencerWidth.narrow,
    required this.child,
    this.onClose,
  });

  /// Tearsheet title text.
  final String? title;

  /// Tearsheet description text (appears below title).
  final String? description;

  /// Tearsheet label text (appears above title).
  final String? label;

  /// Width variant of the tearsheet.
  final CarbonTearsheetWidth width;

  /// Whether to show the close button in the header.
  final bool showCloseButton;

  /// Action buttons at the bottom (max 4 buttons recommended).
  final List<Widget>? actions;

  /// Header actions (only shown for wide tearsheets).
  final List<Widget>? headerActions;

  /// Header navigation widget (only shown for wide tearsheets).
  final Widget? headerNavigation;

  /// Influencer section widget (side panel within tearsheet).
  final Widget? influencer;

  /// Placement of the influencer section.
  final CarbonTearsheetInfluencerPlacement influencerPlacement;

  /// Width of the influencer section.
  final CarbonTearsheetInfluencerWidth influencerWidth;

  /// Tearsheet content.
  final Widget child;

  /// Callback when the tearsheet is closed.
  final VoidCallback? onClose;

  /// Shows a tearsheet as a full-screen modal overlay.
  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    String? description,
    String? label,
    CarbonTearsheetWidth width = CarbonTearsheetWidth.narrow,
    bool showCloseButton = true,
    List<Widget>? actions,
    List<Widget>? headerActions,
    Widget? headerNavigation,
    Widget? influencer,
    CarbonTearsheetInfluencerPlacement influencerPlacement =
        CarbonTearsheetInfluencerPlacement.right,
    CarbonTearsheetInfluencerWidth influencerWidth =
        CarbonTearsheetInfluencerWidth.narrow,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return Navigator.of(context).push<T>(
      _CarbonTearsheetRoute<T>(
        builder: builder,
        title: title,
        description: description,
        label: label,
        width: width,
        showCloseButton: showCloseButton,
        actions: actions,
        headerActions: headerActions,
        headerNavigation: headerNavigation,
        influencer: influencer,
        influencerPlacement: influencerPlacement,
        influencerWidth: influencerWidth,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final carbon = theme.extension<CarbonThemeData>()!;
    final tearsheetTheme = carbon.tearsheet;

    final isWide = width == CarbonTearsheetWidth.wide;
    final hasInfluencer = influencer != null && isWide;

    return Material(
      color: tearsheetTheme.background,
      elevation: 16,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(0),
        topRight: Radius.circular(0),
      ),
      child: SizedBox(
        width: isWide ? 960 : 512,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            _buildHeader(context, tearsheetTheme, isWide),

            // Divider
            Divider(
              height: 1,
              thickness: 1,
              color: tearsheetTheme.dividerColor,
            ),

            // Body with optional influencer
            Flexible(
              fit: FlexFit.loose,
              child: hasInfluencer
                  ? _buildBodyWithInfluencer(tearsheetTheme)
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: child,
                    ),
            ),

            // Actions
            if (actions != null && actions!.isNotEmpty) ...[
              Divider(
                height: 1,
                thickness: 1,
                color: tearsheetTheme.dividerColor,
              ),
              _buildActions(tearsheetTheme, isWide),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    CarbonTearsheetThemeData theme,
    bool isWide,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title row with close button
          Row(
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
                      if (description != null) const SizedBox(height: 8),
                    ],
                    if (description != null)
                      Text(
                        description!,
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
              if (headerActions != null &&
                  headerActions!.isNotEmpty &&
                  isWide) ...[
                const SizedBox(width: 16),
                Row(mainAxisSize: MainAxisSize.min, children: headerActions!),
              ],
              if (showCloseButton) ...[
                const SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.close, color: theme.iconColor),
                  onPressed: () {
                    onClose?.call();
                    Navigator.of(context).pop();
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ],
          ),

          // Header navigation (only for wide tearsheets)
          if (headerNavigation != null && isWide) ...[
            const SizedBox(height: 16),
            Divider(height: 1, thickness: 1, color: theme.dividerColor),
            const SizedBox(height: 8),
            headerNavigation!,
          ],
        ],
      ),
    );
  }

  Widget _buildBodyWithInfluencer(CarbonTearsheetThemeData theme) {
    final influencerSection = Container(
      width: influencerWidth == CarbonTearsheetInfluencerWidth.wide ? 320 : 256,
      color: theme.influencerBackground,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: influencer,
      ),
    );

    final contentSection = Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: influencerPlacement == CarbonTearsheetInfluencerPlacement.left
          ? [
              influencerSection,
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: theme.dividerColor,
              ),
              contentSection,
            ]
          : [
              contentSection,
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: theme.dividerColor,
              ),
              influencerSection,
            ],
    );
  }

  Widget _buildActions(CarbonTearsheetThemeData theme, bool isWide) {
    // Button size based on width
    final buttonHeight = isWide ? 64.0 : 48.0;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: actions!
            .map(
              (action) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: SizedBox(height: buttonHeight, child: action),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Route for displaying a tearsheet with slide-from-bottom animation.
class _CarbonTearsheetRoute<T> extends PageRoute<T> {
  _CarbonTearsheetRoute({
    required this.builder,
    this.title,
    this.description,
    this.label,
    this.width = CarbonTearsheetWidth.narrow,
    this.showCloseButton = true,
    this.actions,
    this.headerActions,
    this.headerNavigation,
    this.influencer,
    this.influencerPlacement = CarbonTearsheetInfluencerPlacement.right,
    this.influencerWidth = CarbonTearsheetInfluencerWidth.narrow,
    this.barrierDismissible = true,
  });

  final WidgetBuilder builder;
  final String? title;
  final String? description;
  final String? label;
  final CarbonTearsheetWidth width;
  final bool showCloseButton;
  final List<Widget>? actions;
  final List<Widget>? headerActions;
  final Widget? headerNavigation;
  final Widget? influencer;
  final CarbonTearsheetInfluencerPlacement influencerPlacement;
  final CarbonTearsheetInfluencerWidth influencerWidth;

  @override
  final bool barrierDismissible;

  @override
  Color? get barrierColor {
    final BuildContext? context = navigator?.context;
    if (context == null) return CarbonPalette.overlay;
    final theme = Theme.of(context);
    final carbon = theme.extension<CarbonThemeData>();
    return carbon?.tearsheet.overlayColor ?? CarbonPalette.overlay;
  }

  @override
  String? get barrierLabel => 'Tearsheet';

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        minimum: const EdgeInsets.only(top: kToolbarHeight),
        child: Center(
          child: Column(
            children: [
              const Spacer(),
              CarbonTearsheet(
                title: title,
                description: description,
                label: label,
                width: width,
                showCloseButton: showCloseButton,
                actions: actions,
                headerActions: headerActions,
                headerNavigation: headerNavigation,
                influencer: influencer,
                influencerPlacement: influencerPlacement,
                influencerWidth: influencerWidth,
                child: builder(context),
              ),
            ],
          ),
        ),
      ),
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
      begin: const Offset(0, 1.0),
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
            child: Container(color: carbon.tearsheet.overlayColor),
          ),
        ),
        // Tearsheet sliding from bottom
        SlideTransition(
          position: slideAnimation,
          child: Align(alignment: Alignment.bottomCenter, child: child),
        ),
      ],
    );
  }
}
