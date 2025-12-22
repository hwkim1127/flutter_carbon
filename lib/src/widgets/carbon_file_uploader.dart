import 'package:flutter/material.dart';

import '../theme/carbon_theme_data.dart';

/// File uploader item state from Carbon Design System.
enum CarbonFileUploaderItemState {
  /// Upload in progress.
  uploading,

  /// Upload complete.
  complete,

  /// Editing/showing file with delete option.
  edit,
}

/// File uploader item size variants.
enum CarbonFileUploaderItemSize {
  /// Small size.
  small,

  /// Medium size.
  medium,

  /// Large size.
  large,
}

/// A Carbon Design System file uploader container.
///
/// This is the main container that wraps either a button or drop zone,
/// and displays uploaded file items below.
///
/// Example:
/// ```dart
/// CarbonFileUploader(
///   labelTitle: 'Upload files',
///   labelDescription: 'Max file size is 500mb',
///   disabled: false,
///   child: CarbonFileUploaderButton(
///     onPressed: () async {
///       final result = await FilePicker.platform.pickFiles(allowMultiple: true);
///       // Handle files
///     },
///     child: Text('Add files'),
///   ),
///   items: [
///     CarbonFileUploaderItem(
///       filename: 'document.pdf',
///       state: CarbonFileUploaderItemState.complete,
///       onDelete: () => removeFile('document.pdf'),
///     ),
///   ],
/// )
/// ```
class CarbonFileUploader extends StatelessWidget {
  /// Creates a Carbon file uploader container.
  const CarbonFileUploader({
    super.key,
    this.labelTitle,
    this.labelDescription,
    this.disabled = false,
    required this.child,
    this.items = const [],
  });

  /// Label title text.
  final String? labelTitle;

  /// Label description text.
  final String? labelDescription;

  /// Whether the file uploader is disabled.
  final bool disabled;

  /// The button or drop zone child widget.
  final Widget child;

  /// List of uploaded file items to display.
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final carbon = theme.extension<CarbonThemeData>()!;
    final fileUploaderTheme = carbon.fileUploader;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelTitle != null) ...[
          Text(
            labelTitle!,
            style: TextStyle(
              color: disabled
                  ? fileUploaderTheme.labelColor.withValues(alpha: 0.5)
                  : fileUploaderTheme.labelColor,
              fontSize: 14,
              height: 1.42857,
              letterSpacing: 0.16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
        ],
        if (labelDescription != null) ...[
          Text(
            labelDescription!,
            style: TextStyle(
              color: disabled
                  ? fileUploaderTheme.descriptionColor.withValues(alpha: 0.5)
                  : fileUploaderTheme.descriptionColor,
              fontSize: 14,
              height: 1.42857,
              letterSpacing: 0.16,
            ),
          ),
          const SizedBox(height: 16),
        ],
        child,
        if (items.isNotEmpty) ...[
          const SizedBox(height: 16),
          ...items,
        ],
      ],
    );
  }
}

/// A Carbon Design System file uploader button.
///
/// Simple button that opens file picker dialog. No drag-and-drop functionality.
///
/// Example:
/// ```dart
/// CarbonFileUploaderButton(
///   disabled: false,
///   onPressed: () async {
///     final result = await FilePicker.platform.pickFiles(
///       allowMultiple: true,
///       type: FileType.custom,
///       allowedExtensions: ['pdf', 'doc', 'docx'],
///     );
///     if (result != null) {
///       setState(() => _files.addAll(result.files));
///     }
///   },
///   child: Text('Add files'),
/// )
/// ```
class CarbonFileUploaderButton extends StatelessWidget {
  /// Creates a Carbon file uploader button.
  const CarbonFileUploaderButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.disabled = false,
  });

  /// Callback when button is pressed. User should open file picker here.
  final VoidCallback? onPressed;

  /// Button label widget.
  final Widget child;

  /// Whether the button is disabled.
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: disabled ? null : onPressed,
      child: child,
    );
  }
}

/// A Carbon Design System file uploader drop zone.
///
/// Provides Carbon-styled drop zone UI. User must wrap this with their
/// drag-and-drop package (e.g., super_drag_and_drop, desktop_drop).
///
/// This widget only provides:
/// - Carbon Design System styling
/// - Visual states (default, dragging, disabled)
/// - Browse files button
///
/// User provides:
/// - Drag-and-drop wrapper (DropRegion, DropTarget, etc.)
/// - File picker implementation
/// - File handling logic
///
/// Example with super_drag_and_drop:
/// ```dart
/// DropRegion(
///   formats: Formats.standardFormats,
///   onDropEnter: (_) => setState(() => _isDragging = true),
///   onDropLeave: (_) => setState(() => _isDragging = false),
///   onPerformDrop: (event) async {
///     final files = await extractFiles(event);
///     setState(() {
///       _files.addAll(files);
///       _isDragging = false;
///     });
///   },
///   child: CarbonFileUploaderDropZone(
///     isDragging: _isDragging,
///     disabled: false,
///     onBrowseFiles: () async {
///       final result = await FilePicker.platform.pickFiles(allowMultiple: true);
///       if (result != null) {
///         setState(() => _files.addAll(result.files));
///       }
///     },
///     child: Column(
///       children: [
///         Text('Drag and drop files here or'),
///         SizedBox(height: 8),
///         Text('click to upload', style: TextStyle(fontWeight: FontWeight.w600)),
///       ],
///     ),
///   ),
/// )
/// ```
class CarbonFileUploaderDropZone extends StatelessWidget {
  /// Creates a Carbon file uploader drop zone.
  const CarbonFileUploaderDropZone({
    super.key,
    required this.isDragging,
    required this.onBrowseFiles,
    this.child,
    this.disabled = false,
  });

  /// Whether files are currently being dragged over the drop zone.
  /// Controlled by parent via drag-drop package callbacks.
  final bool isDragging;

  /// Callback to open file picker dialog.
  final VoidCallback? onBrowseFiles;

  /// Drop zone content widget.
  final Widget? child;

  /// Whether the drop zone is disabled.
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final carbon = theme.extension<CarbonThemeData>()!;
    final fileUploaderTheme = carbon.fileUploader;

    final backgroundColor = disabled
        ? fileUploaderTheme.dropZoneBackground.withValues(alpha: 0.5)
        : (isDragging
            ? fileUploaderTheme.dropZoneDragBackground
            : fileUploaderTheme.dropZoneBackground);

    final borderColor = disabled
        ? fileUploaderTheme.dropZoneBorder.withValues(alpha: 0.5)
        : (isDragging
            ? fileUploaderTheme.dropZoneDragBorder
            : fileUploaderTheme.dropZoneBorder);

    return InkWell(
      onTap: disabled ? null : onBrowseFiles,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: isDragging ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: disabled
                ? fileUploaderTheme.dropZoneLabelColor.withValues(alpha: 0.5)
                : fileUploaderTheme.dropZoneLabelColor,
            fontSize: 14,
            height: 1.42857,
            letterSpacing: 0.16,
          ),
          textAlign: TextAlign.center,
          child: child ??
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Drag and drop files here or'),
                  const SizedBox(height: 8),
                  Text(
                    'click to upload',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: fileUploaderTheme.dropZoneLabelColor,
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}

/// A Carbon Design System file uploader item.
///
/// Displays an uploaded file with filename, state indicator, and optional delete button.
///
/// Example:
/// ```dart
/// CarbonFileUploaderItem(
///   filename: 'document.pdf',
///   state: CarbonFileUploaderItemState.complete,
///   size: CarbonFileUploaderItemSize.medium,
///   onDelete: () => setState(() => _files.removeAt(index)),
/// )
///
/// // With error state
/// CarbonFileUploaderItem(
///   filename: 'invalid-file.exe',
///   state: CarbonFileUploaderItemState.edit,
///   invalid: true,
///   errorSubject: 'Invalid file type',
///   errorBody: 'Only PDF and DOC files are allowed',
///   onDelete: () => removeFile(),
/// )
/// ```
class CarbonFileUploaderItem extends StatelessWidget {
  /// Creates a Carbon file uploader item.
  const CarbonFileUploaderItem({
    super.key,
    required this.filename,
    this.state = CarbonFileUploaderItemState.uploading,
    this.size = CarbonFileUploaderItemSize.medium,
    this.onDelete,
    this.invalid = false,
    this.errorSubject,
    this.errorBody,
    this.iconDescription = 'Delete this file',
  });

  /// The name of the file.
  final String filename;

  /// The state of the file upload.
  final CarbonFileUploaderItemState state;

  /// The size of the file item.
  final CarbonFileUploaderItemSize size;

  /// Callback when delete button is pressed.
  final VoidCallback? onDelete;

  /// Whether the file is invalid.
  final bool invalid;

  /// Error subject/title text.
  final String? errorSubject;

  /// Error body/description text.
  final String? errorBody;

  /// Aria label for delete icon button.
  final String iconDescription;

  double get _itemHeight {
    switch (size) {
      case CarbonFileUploaderItemSize.small:
        return 32;
      case CarbonFileUploaderItemSize.medium:
        return 40;
      case CarbonFileUploaderItemSize.large:
        return 48;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final carbon = theme.extension<CarbonThemeData>()!;
    final fileUploaderTheme = carbon.fileUploader;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: _itemHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  filename,
                  style: TextStyle(
                    color: fileUploaderTheme.filenameColor,
                    fontSize: 14,
                    height: 1.42857,
                    letterSpacing: 0.16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              _buildStateIndicator(context, fileUploaderTheme),
            ],
          ),
        ),
        if (invalid && (errorSubject != null || errorBody != null))
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (errorSubject != null)
                  Text(
                    errorSubject!,
                    style: TextStyle(
                      color: fileUploaderTheme.errorTextColor,
                      fontSize: 12,
                      height: 1.33333,
                      letterSpacing: 0.32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (errorBody != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    errorBody!,
                    style: TextStyle(
                      color: fileUploaderTheme.errorTextColor,
                      fontSize: 12,
                      height: 1.33333,
                      letterSpacing: 0.32,
                    ),
                  ),
                ],
              ],
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildStateIndicator(
    BuildContext context,
    CarbonFileUploaderThemeData theme,
  ) {
    switch (state) {
      case CarbonFileUploaderItemState.uploading:
        return SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(theme.fileItemIconColor),
          ),
        );

      case CarbonFileUploaderItemState.complete:
        return Icon(
          Icons.check_circle,
          size: 16,
          color: theme.completeColor,
        );

      case CarbonFileUploaderItemState.edit:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (invalid)
              Icon(
                Icons.warning,
                size: 16,
                color: theme.errorColor,
              ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.close,
                size: 16,
                color: theme.fileItemIconColor,
              ),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(
                minWidth: 24,
                minHeight: 24,
              ),
              tooltip: iconDescription,
            ),
          ],
        );
    }
  }
}
