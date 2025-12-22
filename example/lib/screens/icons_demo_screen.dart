import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';

class IconsDemoScreen extends StatelessWidget {
  const IconsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample of commonly used Carbon icons
    final List<MapEntry<String, IconData>> sampleIcons = [
      const MapEntry('add', CarbonIcons.add),
      const MapEntry('checkmark', CarbonIcons.checkmark),
      const MapEntry('close', CarbonIcons.close),
      const MapEntry('menu', CarbonIcons.menu),
      const MapEntry('search', CarbonIcons.search),
      const MapEntry('settings', CarbonIcons.settings),
      const MapEntry('user', CarbonIcons.user),
      const MapEntry('arrowRight', CarbonIcons.arrowRight),
      const MapEntry('arrowLeft', CarbonIcons.arrowLeft),
      const MapEntry('arrowUp', CarbonIcons.arrowUp),
      const MapEntry('arrowDown', CarbonIcons.arrowDown),
      const MapEntry('chevronRight', CarbonIcons.chevronRight),
      const MapEntry('chevronLeft', CarbonIcons.chevronLeft),
      const MapEntry('chevronUp', CarbonIcons.chevronUp),
      const MapEntry('chevronDown', CarbonIcons.chevronDown),
      const MapEntry('checkmarkFilled', CarbonIcons.checkmarkFilled),
      const MapEntry('warningFilled', CarbonIcons.warningFilled),
      const MapEntry('errorFilled', CarbonIcons.errorFilled),
      const MapEntry('information', CarbonIcons.information),
      const MapEntry('download', CarbonIcons.download),
      const MapEntry('upload', CarbonIcons.upload),
      const MapEntry('save', CarbonIcons.save),
      const MapEntry('edit', CarbonIcons.edit),
      const MapEntry('delete', CarbonIcons.delete),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Icons Demo'),
        leading: IconButton(
          icon: const Icon(CarbonIcons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(icon: const Icon(CarbonIcons.search), onPressed: () {}),
          IconButton(icon: const Icon(CarbonIcons.settings), onPressed: () {}),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Carbon Design System Icons',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '2,575 icons available as native Flutter IconData',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: sampleIcons.length,
              itemBuilder: (context, index) {
                final entry = sampleIcons[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tapped: ${entry.key}'),
                          duration: const Duration(milliseconds: 500),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(entry.value, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          entry.key,
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show count of all icons
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Row(
                children: [
                  Icon(CarbonIcons.information),
                  SizedBox(width: 8),
                  Text('Icon Stats'),
                ],
              ),
              content: Text('Total icons available: ${CarbonIcons.all.length}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        child: const Icon(CarbonIcons.information),
      ),
    );
  }
}
