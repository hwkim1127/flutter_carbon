import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../widgets/demo_page_template.dart';

/// Demo page for Contained List using Carbon's CarbonContainedList.
class ContainedListDemoPage extends StatefulWidget {
  const ContainedListDemoPage({super.key});

  @override
  State<ContainedListDemoPage> createState() => _ContainedListDemoPageState();
}

class _ContainedListDemoPageState extends State<ContainedListDemoPage> {
  @override
  Widget build(BuildContext context) {
    return DemoPageTemplate(
      title: 'Contained List',
      description:
          'Contained lists organize related content in smaller UI spaces like cards or sidebars. They support headers, actions, and clickable rows.',
      sections: [
        DemoSection(
          title: 'Basic Contained List',
          description: 'Simple list with title and items.',
          builder: (context) => CarbonContainedList(
            title: 'Recent files',
            items: const [
              CarbonContainedListItem(child: Text('Document 1.pdf')),
              CarbonContainedListItem(child: Text('Presentation.pptx')),
              CarbonContainedListItem(child: Text('Spreadsheet.xlsx')),
            ],
          ),
        ),
        DemoSection(
          title: 'With Icons',
          description: 'List items with leading icons.',
          builder: (context) => CarbonContainedList(
            title: 'System settings',
            items: [
              CarbonContainedListItem(
                leading: Icon(
                  Icons.notifications,
                  color: context.carbon.text.iconPrimary,
                ),
                child: const Text('Notifications'),
              ),
              CarbonContainedListItem(
                leading: Icon(
                  Icons.security,
                  color: context.carbon.text.iconPrimary,
                ),
                child: const Text('Security'),
              ),
              CarbonContainedListItem(
                leading: Icon(
                  Icons.privacy_tip,
                  color: context.carbon.text.iconPrimary,
                ),
                child: const Text('Privacy'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Clickable Rows',
          description: 'Rows that respond to clicks with hover effect.',
          builder: (context) => CarbonContainedList(
            title: 'Navigation',
            items: List.generate(5, (index) {
              return CarbonContainedListItem(
                child: Text('Item ${index + 1}'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: context.carbon.text.iconSecondary,
                ),
                onTap: () {
                  // setState(() => _selectedIndex = index);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Clicked item ${index + 1}')),
                  );
                },
              );
            }),
          ),
        ),
        DemoSection(
          title: 'With Subtitles',
          description: 'List items with primary and secondary text.',
          builder: (context) => CarbonContainedList(
            title: 'Team members',
            items: const [
              CarbonContainedListItem(
                child: Text('John Doe'),
                subtitle: 'john.doe@example.com',
                trailing: Icon(Icons.person, size: 20),
              ),
              CarbonContainedListItem(
                child: Text('Jane Smith'),
                subtitle: 'jane.smith@example.com',
                trailing: Icon(Icons.person, size: 20),
              ),
              CarbonContainedListItem(
                child: Text('Bob Johnson'),
                subtitle: 'bob.johnson@example.com',
                trailing: Icon(Icons.person, size: 20),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'With Header Action',
          description: 'List with action button in header.',
          builder: (context) => CarbonContainedList(
            title: 'Messages',
            headerAction: IconButton(
              icon: Icon(Icons.search, color: context.carbon.text.iconPrimary),
              onPressed: () {},
              iconSize: 18,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            items: const [
              CarbonContainedListItem(
                child: Text('Welcome to the team!'),
                subtitle: '2 hours ago',
              ),
              CarbonContainedListItem(
                child: Text('Project update available'),
                subtitle: '5 hours ago',
              ),
              CarbonContainedListItem(
                child: Text('Meeting reminder'),
                subtitle: 'Yesterday',
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Disclosed List (Elevated)',
          description: 'List with shadow for temporary/popover contexts.',
          builder: (context) => CarbonContainedList(
            title: 'Quick actions',
            disclosed: true,
            items: [
              CarbonContainedListItem(
                leading: Icon(
                  Icons.add,
                  color: context.carbon.text.iconPrimary,
                ),
                child: const Text('Create new'),
                onTap: () {},
              ),
              CarbonContainedListItem(
                leading: Icon(
                  Icons.edit,
                  color: context.carbon.text.iconPrimary,
                ),
                child: const Text('Edit'),
                onTap: () {},
              ),
              CarbonContainedListItem(
                leading: Icon(
                  Icons.delete,
                  color: context.carbon.layer.supportError,
                ),
                child: Text(
                  'Delete',
                  style: TextStyle(color: context.carbon.layer.supportError),
                ),
                onTap: () {},
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'With Inset Dividers',
          description: 'Using inset dividers to prevent visual collision.',
          builder: (context) => CarbonContainedList(
            title: 'Tasks',
            insetDividers: true,
            items: [
              CarbonContainedListItem(
                leading: Checkbox(value: false, onChanged: (v) {}),
                child: const Text('Complete documentation'),
              ),
              CarbonContainedListItem(
                leading: Checkbox(value: true, onChanged: (v) {}),
                child: const Text('Review pull request'),
              ),
              CarbonContainedListItem(
                leading: Checkbox(value: false, onChanged: (v) {}),
                child: const Text('Update dependencies'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
