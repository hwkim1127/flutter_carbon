import 'package:flutter/material.dart';
import 'package:flutter_carbon/flutter_carbon.dart';
import '../routes.dart';

/// Home page with component category navigation.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final carbon = context.carbon;

    return Scaffold(
      backgroundColor: carbon.layer.layer01,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text('Carbon Design System'),
            backgroundColor: carbon.layer.layer01,
            foregroundColor: carbon.text.textPrimary,
            elevation: 0,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Welcome card
                _buildWelcomeCard(context, carbon),
                const SizedBox(height: 24),

                // View All Components button
                _buildAllComponentsButton(context, carbon),
                const SizedBox(height: 32),

                // Component categories
                ...componentCategories.map((category) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategoryHeader(context, category, carbon),
                      const SizedBox(height: 12),
                      _buildCategoryGrid(context, category, carbon),
                      const SizedBox(height: 32),
                    ],
                  );
                }),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, CarbonThemeData carbon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: carbon.layer.layer01,
        border: Border.all(color: carbon.layer.borderSubtle01),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Flutter Carbon',
            style: TextStyle(
              fontSize: 28,
              height: 1.25,
              fontWeight: FontWeight.w600,
              color: carbon.text.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A Flutter implementation of IBM\'s Carbon Design System',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
              color: carbon.text.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildStatChip('73 Components', carbon),
              _buildStatChip('4 Themes', carbon),
              _buildStatChip('22 Custom Widgets', carbon),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, CarbonThemeData carbon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: carbon.layer.layer02,
        border: Border.all(color: carbon.layer.borderSubtle01),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: carbon.text.textSecondary),
      ),
    );
  }

  Widget _buildAllComponentsButton(
    BuildContext context,
    CarbonThemeData carbon,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.allComponents);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: carbon.button.buttonPrimary,
          foregroundColor: carbon.text.textOnColor,
          elevation: 0,
          shape: const RoundedRectangleBorder(),
        ),
        child: const Text('View All Components'),
      ),
    );
  }

  Widget _buildCategoryHeader(
    BuildContext context,
    ComponentCategory category,
    CarbonThemeData carbon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.title,
          style: TextStyle(
            fontSize: 20,
            height: 1.4,
            fontWeight: FontWeight.w600,
            color: carbon.text.textPrimary,
          ),
        ),
        if (category.subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            category.subtitle!,
            style: TextStyle(
              fontSize: 14,
              height: 1.43,
              color: carbon.text.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryGrid(
    BuildContext context,
    ComponentCategory category,
    CarbonThemeData carbon,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800
            ? 3
            : constraints.maxWidth > 500
                ? 2
                : 1;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 3,
          children: category.items.map((item) {
            return _buildComponentCard(context, item, carbon);
          }).toList(),
        );
      },
    );
  }

  Widget _buildComponentCard(
    BuildContext context,
    ComponentItem item,
    CarbonThemeData carbon,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, item.route);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: carbon.layer.layer01,
          border: Border.all(color: carbon.layer.borderSubtle01),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: carbon.text.textPrimary,
              ),
            ),
            if (item.description != null) ...[
              const SizedBox(height: 4),
              Text(
                item.description!,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.33,
                  color: carbon.text.textSecondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
