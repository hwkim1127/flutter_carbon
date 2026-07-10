import 'package:flutter/widgets.dart';

import '../base/carbon_overlay_surface.dart';
import '../base/carbon_pressable.dart';
import '../foundation/motion.dart';
import '../foundation/typography.dart';
import '../icons/carbon_icons.dart';
import '../theme/carbon_theme.dart';
import 'carbon_button.dart';
import 'carbon_text_input.dart';

/// Carbon Design System modal dialog.
///
/// Uses a widgets-layer [PageRouteBuilder] (no Material route machinery) with
/// the Carbon spec entrance motion, `$overlay` barrier, and the signature
/// Carbon footer (64px buttons filling the container width in halves).
///
/// Note: modal content no longer has a `Material` ancestor — Material widgets
/// passed as `content` need their own `Material`.
class CarbonModal {
  /// Shows a passive modal (informational only, no actions required).
  ///
  /// Example:
  /// ```dart
  /// CarbonModal.passive(
  ///   context,
  ///   title: 'Success',
  ///   content: Text('Your changes have been saved'),
  ///   image: Image.asset('assets/success.png'),
  /// );
  /// ```
  static Future<void> passive(
    BuildContext context, {
    String? title,
    required Widget content,
    Widget? image,
    bool dismissible = true,
    bool showCloseButton = true,
  }) {
    return _show<void>(
      context,
      _CarbonPassiveModal(
        title: title,
        content: content,
        image: image,
        dismissible: dismissible,
        showCloseButton: showCloseButton,
      ),
      dismissible: dismissible,
    );
  }

  /// Shows a transactional modal (requires user decision).
  ///
  /// Returns true if primary action was taken, false if secondary/canceled.
  ///
  /// Example:
  /// ```dart
  /// final confirmed = await CarbonModal.transactional(
  ///   context,
  ///   title: 'Confirm Action',
  ///   content: Text('Are you sure you want to proceed?'),
  ///   primaryButtonText: 'Confirm',
  ///   secondaryButtonText: 'Cancel',
  /// );
  /// ```
  static Future<bool?> transactional(
    BuildContext context, {
    String? title,
    required Widget content,
    Widget? image,
    String primaryButtonText = 'Confirm',
    String secondaryButtonText = 'Cancel',
    bool dismissible = false,
  }) {
    return _show<bool>(
      context,
      _CarbonTransactionalModal(
        title: title,
        content: content,
        image: image,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        dismissible: dismissible,
      ),
      dismissible: dismissible,
    );
  }

  /// Shows a danger modal (destructive action warning).
  ///
  /// Per the Carbon spec this is a standard modal whose primary button is
  /// the `danger` kind. Returns true if the user confirmed.
  ///
  /// Example:
  /// ```dart
  /// final confirmed = await CarbonModal.danger(
  ///   context,
  ///   title: 'Delete Account',
  ///   content: Text('This action cannot be undone.'),
  ///   primaryButtonText: 'Delete',
  /// );
  /// ```
  static Future<bool?> danger(
    BuildContext context, {
    String? title,
    required Widget content,
    String primaryButtonText = 'Delete',
    String secondaryButtonText = 'Cancel',
    bool dismissible = false,
  }) {
    return _show<bool>(
      context,
      _CarbonDangerModal(
        title: title,
        content: content,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        dismissible: dismissible,
      ),
      dismissible: dismissible,
    );
  }

  /// Shows a modal with text input.
  ///
  /// Returns the entered text, or null if canceled.
  ///
  /// Example:
  /// ```dart
  /// final name = await CarbonModal.input(
  ///   context,
  ///   title: 'Enter Name',
  ///   hintText: 'Your name',
  ///   initialValue: 'John',
  /// );
  /// ```
  static Future<String?> input(
    BuildContext context, {
    String? title,
    String? label,
    String? hintText,
    String? helperText,
    String? initialValue,
    String primaryButtonText = 'Enter',
    String secondaryButtonText = 'Cancel',
    bool dismissible = false,
    TextInputType? keyboardType,
    int? maxLines,
    int? maxLength,
  }) {
    return _show<String>(
      context,
      _CarbonInputModal(
        title: title,
        label: label,
        hintText: hintText,
        helperText: helperText,
        initialValue: initialValue,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        dismissible: dismissible,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
      ),
      dismissible: dismissible,
    );
  }

  /// Shows a custom modal with full control over content and actions.
  ///
  /// Example:
  /// ```dart
  /// CarbonModal.custom(
  ///   context,
  ///   content: MyCustomWidget(),
  ///   dismissible: true,
  /// );
  /// ```
  static Future<T?> custom<T>(
    BuildContext context, {
    required Widget content,
    bool dismissible = true,
    bool showCloseButton = false,
    double? maxWidth,
  }) {
    return _show<T>(
      context,
      _CarbonCustomModal<T>(
        content: content,
        dismissible: dismissible,
        showCloseButton: showCloseButton,
        maxWidth: maxWidth,
      ),
      dismissible: dismissible,
    );
  }

  /// Pushes [modal] with the Carbon spec motion: 240ms fade + 24px rise
  /// (expressive easing) over the `$overlay` barrier.
  ///
  /// [dismissible] also enables the route's Escape-to-dismiss handling
  /// (ModalRoute wires Escape → DismissIntent → pop when
  /// `barrierDismissible` is true).
  static Future<T?> _show<T>(
    BuildContext context,
    Widget modal, {
    required bool dismissible,
  }) {
    final overlayColor = context.carbon.layer.overlay;
    return Navigator.of(context).push<T>(
      PageRouteBuilder<T>(
        opaque: false,
        barrierColor: overlayColor,
        barrierDismissible: dismissible,
        barrierLabel: dismissible ? 'Dismiss' : null,
        transitionDuration: CarbonMotion.moderate02,
        reverseTransitionDuration: CarbonMotion.moderate02,
        pageBuilder: (context, animation, secondaryAnimation) => modal,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: CarbonMotion.entranceExpressive,
            reverseCurve: CarbonMotion.exitExpressive,
          );
          return FadeTransition(
            opacity: curved,
            child: AnimatedBuilder(
              animation: curved,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, -24 * (1 - curved.value)),
                child: child,
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

/// Base modal route content: barrier, centering, keyboard avoidance.
///
/// Replaces the previous Scaffold: [CarbonOverlaySurface] restores the
/// default text style Material used to provide, and the bottom-inset padding
/// replaces `resizeToAvoidBottomInset`.
class _ModalScaffold extends StatelessWidget {
  final Widget child;
  final bool dismissible;
  final double maxWidth;

  const _ModalScaffold({
    required this.child,
    required this.dismissible,
    this.maxWidth = 480,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return CarbonOverlaySurface(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Dismiss barrier (the route's barrierColor paints the scrim).
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: dismissible ? Navigator.of(context).pop : null,
                ),
              ),
              // Modal content
              Container(
                constraints: BoxConstraints(maxWidth: maxWidth),
                margin: const EdgeInsets.all(16),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shared modal container: header / body / flush footer per the Carbon spec,
/// with an optional overlaid close button.
class _ModalContainer extends StatelessWidget {
  final String? title;
  final Widget? image;
  final Widget body;
  final Widget? footer;
  final bool showCloseButton;
  final bool padBody;

  const _ModalContainer({
    this.title,
    this.image,
    required this.body,
    this.footer,
    this.showCloseButton = false,
    this.padBody = true,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: carbon.layer.layer01,
            border: Border.all(color: carbon.layer.borderSubtle01),
            borderRadius: BorderRadius.zero,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (image != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Center(
                    child: SizedBox(width: 80, height: 80, child: image),
                  ),
                ),
              if (title != null)
                Padding(
                  // Right inset clears the 48px close button.
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 48),
                  child: Text(
                    title!,
                    style: CarbonTypography.heading03.copyWith(
                      color: carbon.text.textPrimary,
                    ),
                  ),
                ),
              Padding(
                padding: padBody
                    ? const EdgeInsets.only(
                        top: 8,
                        left: 16,
                        right: 16,
                        bottom: 48,
                      )
                    : EdgeInsets.zero,
                child: DefaultTextStyle(
                  style: CarbonTypography.body01.copyWith(
                    color: carbon.text.textPrimary,
                  ),
                  child: body,
                ),
              ),
              // Flush footer — no padding, buttons touch the edges.
              ?footer,
            ],
          ),
        ),
        if (showCloseButton)
          Positioned(
            right: 0,
            top: 0,
            child: _ModalCloseButton(onTap: Navigator.of(context).pop),
          ),
      ],
    );
  }
}

/// Carbon spec footer: 64px-tall buttons filling the width in halves.
Widget _modalFooter(
  BuildContext context, {
  required String secondaryText,
  required VoidCallback onSecondary,
  required String primaryText,
  required VoidCallback onPrimary,
  CarbonButtonKind primaryKind = CarbonButtonKind.primary,
}) {
  return Row(
    children: [
      Expanded(
        child: CarbonButton(
          kind: CarbonButtonKind.secondary,
          size: CarbonButtonSize.xl,
          onPressed: onSecondary,
          child: Text(secondaryText),
        ),
      ),
      // No gap — Carbon modal footer buttons touch.
      Expanded(
        child: CarbonButton(
          kind: primaryKind,
          size: CarbonButtonSize.xl,
          onPressed: onPrimary,
          child: Text(primaryText),
        ),
      ),
    ],
  );
}

/// 48×48 close button, 20px icon (spec).
class _ModalCloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ModalCloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Semantics(
      button: true,
      label: 'Close',
      child: CarbonPressable(
        onTap: onTap,
        focusable: true,
        builder: (context, state) => Container(
          width: 48,
          height: 48,
          color: state.hovered ? carbon.layer.layerHover01 : null,
          child: Icon(
            CarbonIcons.close,
            color: carbon.text.iconPrimary,
            size: 20,
          ),
        ),
      ),
    );
  }
}

/// Passive modal implementation.
class _CarbonPassiveModal extends StatelessWidget {
  final String? title;
  final Widget content;
  final Widget? image;
  final bool dismissible;
  final bool showCloseButton;

  const _CarbonPassiveModal({
    this.title,
    required this.content,
    this.image,
    required this.dismissible,
    required this.showCloseButton,
  });

  @override
  Widget build(BuildContext context) {
    return _ModalScaffold(
      dismissible: dismissible,
      child: _ModalContainer(
        title: title,
        image: image,
        body: content,
        showCloseButton: showCloseButton,
      ),
    );
  }
}

/// Transactional modal implementation.
class _CarbonTransactionalModal extends StatelessWidget {
  final String? title;
  final Widget content;
  final Widget? image;
  final String primaryButtonText;
  final String secondaryButtonText;
  final bool dismissible;

  const _CarbonTransactionalModal({
    this.title,
    required this.content,
    this.image,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.dismissible,
  });

  @override
  Widget build(BuildContext context) {
    return _ModalScaffold(
      dismissible: dismissible,
      child: _ModalContainer(
        title: title,
        image: image,
        body: content,
        footer: _modalFooter(
          context,
          secondaryText: secondaryButtonText,
          onSecondary: () => Navigator.of(context).pop(false),
          primaryText: primaryButtonText,
          onPrimary: () => Navigator.of(context).pop(true),
        ),
      ),
    );
  }
}

/// Danger modal implementation: standard modal + danger primary button.
class _CarbonDangerModal extends StatelessWidget {
  final String? title;
  final Widget content;
  final String primaryButtonText;
  final String secondaryButtonText;
  final bool dismissible;

  const _CarbonDangerModal({
    this.title,
    required this.content,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.dismissible,
  });

  @override
  Widget build(BuildContext context) {
    return _ModalScaffold(
      dismissible: dismissible,
      child: _ModalContainer(
        title: title,
        body: content,
        footer: _modalFooter(
          context,
          secondaryText: secondaryButtonText,
          onSecondary: () => Navigator.of(context).pop(false),
          primaryText: primaryButtonText,
          onPrimary: () => Navigator.of(context).pop(true),
          primaryKind: CarbonButtonKind.danger,
        ),
      ),
    );
  }
}

/// Input modal implementation.
class _CarbonInputModal extends StatefulWidget {
  final String? title;
  final String? label;
  final String? hintText;
  final String? helperText;
  final String? initialValue;
  final String primaryButtonText;
  final String secondaryButtonText;
  final bool dismissible;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;

  const _CarbonInputModal({
    this.title,
    this.label,
    this.hintText,
    this.helperText,
    this.initialValue,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.dismissible,
    this.keyboardType,
    this.maxLines,
    this.maxLength,
  });

  @override
  State<_CarbonInputModal> createState() => _CarbonInputModalState();
}

class _CarbonInputModalState extends State<_CarbonInputModal> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Native Carbon input. Note: [maxLength] still enforces the limit, but
    // Material's character counter UI is gone (the Carbon counter is a
    // deferred CarbonTextInput feature).
    final Widget field;
    if ((widget.maxLines ?? 1) > 1) {
      field = CarbonTextArea(
        labelText: widget.label ?? widget.hintText ?? '',
        hideLabel: widget.label == null,
        controller: _controller,
        autofocus: true,
        placeholder: widget.hintText,
        helperText: widget.helperText,
        minLines: widget.maxLines!,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
      );
    } else {
      field = CarbonTextInput(
        labelText: widget.label ?? widget.hintText ?? '',
        hideLabel: widget.label == null,
        controller: _controller,
        autofocus: true,
        placeholder: widget.hintText,
        helperText: widget.helperText,
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
      );
    }

    return _ModalScaffold(
      dismissible: widget.dismissible,
      child: _ModalContainer(
        title: widget.title,
        body: field,
        footer: _modalFooter(
          context,
          secondaryText: widget.secondaryButtonText,
          onSecondary: () => Navigator.of(context).pop(),
          primaryText: widget.primaryButtonText,
          onPrimary: () => Navigator.of(context).pop(_controller.text),
        ),
      ),
    );
  }
}

/// Custom modal implementation.
class _CarbonCustomModal<T> extends StatelessWidget {
  final Widget content;
  final bool dismissible;
  final bool showCloseButton;
  final double? maxWidth;

  const _CarbonCustomModal({
    required this.content,
    required this.dismissible,
    required this.showCloseButton,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return _ModalScaffold(
      dismissible: dismissible,
      maxWidth: maxWidth ?? 480,
      child: _ModalContainer(
        body: content,
        padBody: false,
        showCloseButton: showCloseButton,
      ),
    );
  }
}
