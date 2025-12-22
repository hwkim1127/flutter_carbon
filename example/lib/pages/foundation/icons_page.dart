import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../../widgets/demo_page_template.dart';

/// Demo page for Carbon icons.
class IconsPage extends StatelessWidget {
  const IconsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return DemoPageTemplate(
      title: 'Icons',
      description:
          'Carbon uses Material Icons in Flutter. Icons should be 16px or 20px at their base size.',
      sections: [
        DemoSection(
          title: 'Icon Sizes',
          description: 'Standard Carbon icon sizes',
          builder: (context) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconSizeDemo('16px (Small)', 16, carbon),
              const SizedBox(height: 16),
              _IconSizeDemo('20px (Medium - Default)', 20, carbon),
              const SizedBox(height: 16),
              _IconSizeDemo('24px (Large)', 24, carbon),
              const SizedBox(height: 16),
              _IconSizeDemo('32px (Extra Large)', 32, carbon),
            ],
          ),
        ),
        DemoSection(
          title: 'Common Action Icons',
          description: 'Frequently used icons for actions',
          builder: (context) => _IconGrid(
            icons: const [
              _IconItem('Add', Icons.add),
              _IconItem('Remove', Icons.remove),
              _IconItem('Close', Icons.close),
              _IconItem('Check', Icons.check),
              _IconItem('Edit', Icons.edit),
              _IconItem('Delete', Icons.delete),
              _IconItem('Save', Icons.save),
              _IconItem('Search', Icons.search),
              _IconItem('Filter', Icons.filter_list),
              _IconItem('Sort', Icons.sort),
              _IconItem('Refresh', Icons.refresh),
              _IconItem('Download', Icons.download),
              _IconItem('Upload', Icons.upload),
              _IconItem('Share', Icons.share),
              _IconItem('Copy', Icons.content_copy),
              _IconItem('More', Icons.more_vert),
            ],
          ),
        ),
        DemoSection(
          title: 'Navigation Icons',
          description: 'Icons for navigation and movement',
          builder: (context) => _IconGrid(
            icons: const [
              _IconItem('Arrow Up', Icons.arrow_upward),
              _IconItem('Arrow Down', Icons.arrow_downward),
              _IconItem('Arrow Left', Icons.arrow_back),
              _IconItem('Arrow Right', Icons.arrow_forward),
              _IconItem('Chevron Up', Icons.expand_less),
              _IconItem('Chevron Down', Icons.expand_more),
              _IconItem('Chevron Left', Icons.chevron_left),
              _IconItem('Chevron Right', Icons.chevron_right),
              _IconItem('Menu', Icons.menu),
              _IconItem('Home', Icons.home),
              _IconItem('Settings', Icons.settings),
              _IconItem('Info', Icons.info),
            ],
          ),
        ),
        DemoSection(
          title: 'Status Icons',
          description: 'Icons indicating status or state',
          builder: (context) => _IconGrid(
            icons: const [
              _IconItem('Success', Icons.check_circle),
              _IconItem('Error', Icons.error),
              _IconItem('Warning', Icons.warning),
              _IconItem('Info', Icons.info_outline),
              _IconItem('Help', Icons.help_outline),
              _IconItem('Pending', Icons.access_time),
              _IconItem('Lock', Icons.lock),
              _IconItem('Unlock', Icons.lock_open),
              _IconItem('Visible', Icons.visibility),
              _IconItem('Hidden', Icons.visibility_off),
              _IconItem('Favorite', Icons.favorite),
              _IconItem('Star', Icons.star),
            ],
          ),
        ),
        DemoSection(
          title: 'File & Document Icons',
          description: 'Icons for files and documents',
          builder: (context) => _IconGrid(
            icons: const [
              _IconItem('Folder', Icons.folder),
              _IconItem('File', Icons.description),
              _IconItem('Document', Icons.article),
              _IconItem('Image', Icons.image),
              _IconItem('PDF', Icons.picture_as_pdf),
              _IconItem('Code', Icons.code),
              _IconItem('Attachment', Icons.attach_file),
              _IconItem('Link', Icons.link),
              _IconItem('Cloud', Icons.cloud),
              _IconItem('Cloud Upload', Icons.cloud_upload),
              _IconItem('Cloud Download', Icons.cloud_download),
              _IconItem('Archive', Icons.inventory_2),
            ],
          ),
        ),
        DemoSection(
          title: 'Communication Icons',
          description: 'Icons for messaging and communication',
          builder: (context) => _IconGrid(
            icons: const [
              _IconItem('Email', Icons.email),
              _IconItem('Message', Icons.message),
              _IconItem('Chat', Icons.chat),
              _IconItem('Comment', Icons.comment),
              _IconItem('Notification', Icons.notifications),
              _IconItem('Phone', Icons.phone),
              _IconItem('Person', Icons.person),
              _IconItem('Group', Icons.group),
            ],
          ),
        ),
        DemoSection(
          title: 'Media Icons',
          description: 'Icons for media control',
          builder: (context) => _IconGrid(
            icons: const [
              _IconItem('Play', Icons.play_arrow),
              _IconItem('Pause', Icons.pause),
              _IconItem('Stop', Icons.stop),
              _IconItem('Volume', Icons.volume_up),
              _IconItem('Mute', Icons.volume_off),
              _IconItem('Mic', Icons.mic),
              _IconItem('Camera', Icons.camera_alt),
              _IconItem('Video', Icons.videocam),
            ],
          ),
        ),
      ],
    );
  }
}

class _IconSizeDemo extends StatelessWidget {
  final String label;
  final double size;
  final CarbonThemeData carbon;

  const _IconSizeDemo(this.label, this.size, this.carbon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            border: Border.all(color: carbon.layer.borderSubtle01),
          ),
          child: Center(
            child: Icon(
              Icons.check_circle,
              size: size,
              color: carbon.text.iconPrimary,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: carbon.text.textPrimary),
        ),
      ],
    );
  }
}

class _IconItem {
  final String name;
  final IconData icon;

  const _IconItem(this.name, this.icon);
}

class _IconGrid extends StatelessWidget {
  final List<_IconItem> icons;

  const _IconGrid({required this.icons});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: icons.map((item) {
        return SizedBox(
          width: 80,
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: carbon.layer.borderSubtle01),
                ),
                child: Icon(
                  item.icon,
                  size: 20,
                  color: carbon.text.iconPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.name,
                style: TextStyle(
                  fontSize: 11,
                  color: carbon.text.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
