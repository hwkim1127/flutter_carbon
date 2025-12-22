import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';

/// Carbon Design System modal dialog.
///
/// Uses PageRouteBuilder with full Scaffold for proper positioning
/// on foldable phones and various screen configurations.
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
  }) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        pageBuilder: (context, animation, secondaryAnimation) =>
            _CarbonPassiveModal(
          title: title,
          content: content,
          image: image,
          dismissible: dismissible,
          showCloseButton: showCloseButton,
        ),
      ),
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
    String primaryButtonText = '확인',
    String secondaryButtonText = '취소',
    bool dismissible = false,
  }) async {
    return await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        pageBuilder: (context, animation, secondaryAnimation) =>
            _CarbonTransactionalModal(
          title: title,
          content: content,
          image: image,
          primaryButtonText: primaryButtonText,
          secondaryButtonText: secondaryButtonText,
          dismissible: dismissible,
        ),
      ),
    );
  }

  /// Shows a danger modal (destructive action warning).
  ///
  /// Returns true if user confirmed the dangerous action.
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
    String primaryButtonText = '삭제',
    String secondaryButtonText = '취소',
    bool dismissible = false,
  }) async {
    return await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        pageBuilder: (context, animation, secondaryAnimation) =>
            _CarbonDangerModal(
          title: title,
          content: content,
          primaryButtonText: primaryButtonText,
          secondaryButtonText: secondaryButtonText,
          dismissible: dismissible,
        ),
      ),
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
    String primaryButtonText = '입력',
    String secondaryButtonText = '취소',
    bool dismissible = false,
    TextInputType? keyboardType,
    int? maxLines,
    int? maxLength,
  }) async {
    return await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        pageBuilder: (context, animation, secondaryAnimation) =>
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
      ),
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
  }) async {
    return await Navigator.of(context).push<T>(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        pageBuilder: (context, animation, secondaryAnimation) =>
            _CarbonCustomModal<T>(
          content: content,
          dismissible: dismissible,
          showCloseButton: showCloseButton,
          maxWidth: maxWidth,
        ),
      ),
    );
  }
}

/// Base modal scaffold wrapper.
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Dismissible overlay
            GestureDetector(
              onTap: dismissible ? Navigator.of(context).pop : null,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
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
    final carbon = context.carbon;

    return _ModalScaffold(
      dismissible: dismissible,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: carbon.layer.layer02,
              borderRadius: BorderRadius.zero,
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (image != null) ...[
                  Center(child: SizedBox(width: 80, height: 80, child: image)),
                  const SizedBox(height: 16),
                ],
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(
                      color: carbon.text.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
                DefaultTextStyle(
                  style: TextStyle(
                    color: carbon.text.textPrimary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  child: content,
                ),
              ],
            ),
          ),
          if (showCloseButton)
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                onPressed: Navigator.of(context).pop,
                icon: Icon(
                  Icons.close,
                  color: carbon.text.iconPrimary,
                  size: 20,
                ),
              ),
            ),
        ],
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
    final carbon = context.carbon;

    return _ModalScaffold(
      dismissible: dismissible,
      child: Container(
        decoration: BoxDecoration(
          color: carbon.layer.layer02,
          borderRadius: BorderRadius.zero,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (image != null) ...[
              Center(child: SizedBox(width: 80, height: 80, child: image)),
              const SizedBox(height: 16),
            ],
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  color: carbon.text.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
            ],
            DefaultTextStyle(
              style: TextStyle(color: carbon.text.textPrimary, fontSize: 14),
              child: content,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(secondaryButtonText),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(primaryButtonText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Danger modal implementation.
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
    final carbon = context.carbon;

    return _ModalScaffold(
      dismissible: dismissible,
      child: Container(
        decoration: BoxDecoration(
          color: carbon.layer.layer02,
          borderRadius: BorderRadius.zero,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Danger header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: carbon.layer.supportError),
              child: Row(
                children: [
                  Icon(Icons.warning, color: carbon.text.textOnColor, size: 24),
                  if (title != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title!,
                        style: TextStyle(
                          color: carbon.text.textOnColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DefaultTextStyle(
                    style: TextStyle(
                      color: carbon.text.textPrimary,
                      fontSize: 14,
                    ),
                    child: content,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(secondaryButtonText),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: FilledButton.styleFrom(
                            backgroundColor: carbon.layer.supportError,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(primaryButtonText),
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
    final carbon = context.carbon;

    return _ModalScaffold(
      dismissible: widget.dismissible,
      child: Container(
        decoration: BoxDecoration(
          color: carbon.layer.layer02,
          borderRadius: BorderRadius.zero,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.title != null) ...[
              Text(
                widget.title!,
                style: TextStyle(
                  color: carbon.text.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines ?? 1,
              maxLength: widget.maxLength,
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hintText,
                helperText: widget.helperText,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(widget.secondaryButtonText),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () =>
                        Navigator.of(context).pop(_controller.text),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(widget.primaryButtonText),
                  ),
                ),
              ],
            ),
          ],
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
    final carbon = context.carbon;

    return _ModalScaffold(
      dismissible: dismissible,
      maxWidth: maxWidth ?? 480,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: carbon.layer.layer02,
              borderRadius: BorderRadius.zero,
            ),
            child: content,
          ),
          if (showCloseButton)
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close,
                  color: carbon.text.iconPrimary,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
