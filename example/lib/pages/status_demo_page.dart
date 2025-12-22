import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for Carbon status indicators.
class StatusDemoPage extends StatelessWidget {
  const StatusDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return DemoPageTemplate(
      title: 'Status Indicators',
      description:
          'Status indicators communicate the state of an item or process using color-coded visual cues.',
      sections: [
        DemoSection(
          title: 'Status Colors',
          description: 'All available status indicator colors',
          builder: (context) => Wrap(
            spacing: 24,
            runSpacing: 16,
            children: [
              _StatusIndicator(
                color: carbon.status.statusRed,
                label: 'Red',
                description: 'Error or critical state',
              ),
              _StatusIndicator(
                color: carbon.status.statusGreen,
                label: 'Green',
                description: 'Success or completed',
              ),
              _StatusIndicator(
                color: carbon.status.statusOrange,
                label: 'Orange',
                description: 'Warning or attention needed',
              ),
              _StatusIndicator(
                color: carbon.status.statusYellow,
                label: 'Yellow',
                description: 'Caution or in progress',
              ),
              _StatusIndicator(
                color: carbon.status.statusBlue,
                label: 'Blue',
                description: 'Info or running',
              ),
              _StatusIndicator(
                color: carbon.status.statusPurple,
                label: 'Purple',
                description: 'Special or custom status',
              ),
              _StatusIndicator(
                color: carbon.status.statusGray,
                label: 'Gray',
                description: 'Inactive or disabled',
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Status Badges',
          description: 'Status indicators as badges with labels',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatusBadge(color: carbon.status.statusRed, label: 'Failed'),
                  _StatusBadge(
                    color: carbon.status.statusGreen,
                    label: 'Active',
                  ),
                  _StatusBadge(
                    color: carbon.status.statusOrange,
                    label: 'Warning',
                  ),
                  _StatusBadge(
                    color: carbon.status.statusYellow,
                    label: 'Pending',
                  ),
                  _StatusBadge(
                    color: carbon.status.statusBlue,
                    label: 'Running',
                  ),
                  _StatusBadge(
                    color: carbon.status.statusGray,
                    label: 'Stopped',
                  ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Status in Lists',
          description: 'Status indicators used in list items',
          builder: (context) => Container(
            decoration: BoxDecoration(
              border: Border.all(color: carbon.layer.borderSubtle01),
            ),
            child: Column(
              children: [
                _StatusListItem(
                  title: 'Production Server',
                  status: 'Running',
                  statusColor: carbon.status.statusGreen,
                  subtitle: 'Last updated: 2 minutes ago',
                ),
                Divider(height: 1, color: carbon.layer.borderSubtle01),
                _StatusListItem(
                  title: 'Development Server',
                  status: 'Stopped',
                  statusColor: carbon.status.statusGray,
                  subtitle: 'Last updated: 1 hour ago',
                ),
                Divider(height: 1, color: carbon.layer.borderSubtle01),
                _StatusListItem(
                  title: 'Staging Server',
                  status: 'Warning',
                  statusColor: carbon.status.statusOrange,
                  subtitle: 'High memory usage detected',
                ),
                Divider(height: 1, color: carbon.layer.borderSubtle01),
                _StatusListItem(
                  title: 'Test Server',
                  status: 'Error',
                  statusColor: carbon.status.statusRed,
                  subtitle: 'Connection timeout',
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Status Sizes',
          description: 'Status indicators in different sizes',
          builder: (context) => Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Small',
                    style: TextStyle(
                      fontSize: 12,
                      color: carbon.text.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _StatusDot(color: carbon.status.statusGreen, size: 6),
                ],
              ),
              const SizedBox(width: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Medium',
                    style: TextStyle(
                      fontSize: 12,
                      color: carbon.text.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _StatusDot(color: carbon.status.statusGreen, size: 8),
                ],
              ),
              const SizedBox(width: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Large',
                    style: TextStyle(
                      fontSize: 12,
                      color: carbon.text.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _StatusDot(color: carbon.status.statusGreen, size: 12),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final Color color;
  final String label;
  final String description;

  const _StatusIndicator({
    required this.color,
    required this.label,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return SizedBox(
      width: 200,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: carbon.text.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: carbon.text.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final Color color;
  final String label;

  const _StatusBadge({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: carbon.text.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusListItem extends StatelessWidget {
  final String title;
  final String status;
  final Color statusColor;
  final String? subtitle;

  const _StatusListItem({
    required this.title,
    required this.status,
    required this.statusColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;
    return Container(
      padding: const EdgeInsets.all(16),
      color: carbon.layer.layer01,
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: carbon.text.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: carbon.text.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: carbon.text.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final Color color;
  final double size;

  const _StatusDot({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
