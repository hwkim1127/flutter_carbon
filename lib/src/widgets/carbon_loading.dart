import 'package:flutter/material.dart';

import '../theme/carbon_theme.dart';
import '../theme/carbon_theme_data.dart';

/// Loading size variants.
enum CarbonLoadingSize { small, medium, large }

/// Carbon Design System loading spinner.
///
/// Full-page or large loading indicator with circular spinner.
///
/// Example:
/// ```dart
/// CarbonLoading(
///   size: CarbonLoadingSize.large,
///   withOverlay: true,
/// )
/// ```
class CarbonLoading extends StatelessWidget {
  /// The size of the loading spinner.
  final CarbonLoadingSize size;

  /// Whether to show a semi-transparent overlay behind the spinner.
  final bool withOverlay;

  /// Optional description text below the spinner.
  final String? description;

  const CarbonLoading({
    super.key,
    this.size = CarbonLoadingSize.large,
    this.withOverlay = false,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    final spinner = SizedBox(
      width: _getSize(),
      height: _getSize(),
      child: CircularProgressIndicator(
        strokeWidth: _getStrokeWidth(),
        valueColor: AlwaysStoppedAnimation<Color>(carbon.button.buttonPrimary),
      ),
    );

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        spinner,
        if (description != null) ...[
          const SizedBox(height: 16),
          Text(
            description!,
            style: TextStyle(color: carbon.text.textPrimary, fontSize: 14),
          ),
        ],
      ],
    );

    if (withOverlay) {
      return Container(
        color: carbon.layer.overlay.withValues(alpha: 0.5),
        child: Center(child: content),
      );
    }

    return content;
  }

  double _getSize() {
    switch (size) {
      case CarbonLoadingSize.small:
        return 16;
      case CarbonLoadingSize.medium:
        return 48;
      case CarbonLoadingSize.large:
        return 88;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case CarbonLoadingSize.small:
        return 2;
      case CarbonLoadingSize.medium:
        return 4;
      case CarbonLoadingSize.large:
        return 6;
    }
  }
}

/// Carbon Design System inline loading.
///
/// Small inline loading indicator used within buttons or other UI elements.
///
/// Example:
/// ```dart
/// CarbonInlineLoading(
///   status: CarbonInlineLoadingStatus.active,
///   description: 'Loading...',
/// )
/// ```
class CarbonInlineLoading extends StatelessWidget {
  /// The current loading status.
  final CarbonInlineLoadingStatus status;

  /// Optional description text.
  final String? description;

  const CarbonInlineLoading({
    super.key,
    required this.status,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildStatusIndicator(carbon),
        if (description != null) ...[
          const SizedBox(width: 8),
          Text(
            description!,
            style: TextStyle(color: carbon.text.textPrimary, fontSize: 14),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusIndicator(CarbonThemeData carbon) {
    switch (status) {
      case CarbonInlineLoadingStatus.inactive:
        return const SizedBox.shrink();

      case CarbonInlineLoadingStatus.active:
        return SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              carbon.button.buttonPrimary,
            ),
          ),
        );

      case CarbonInlineLoadingStatus.finished:
        return Icon(
          Icons.check_circle,
          size: 16,
          color: carbon.status.statusGreen,
        );

      case CarbonInlineLoadingStatus.error:
        return Icon(Icons.error, size: 16, color: carbon.status.statusRed);
    }
  }
}

/// Inline loading status states.
enum CarbonInlineLoadingStatus {
  /// Not loading, indicator hidden.
  inactive,

  /// Currently loading, showing spinner.
  active,

  /// Loading completed successfully, showing checkmark.
  finished,

  /// Loading failed, showing error icon.
  error,
}
