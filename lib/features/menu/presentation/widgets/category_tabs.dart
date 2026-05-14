import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../shared/widgets/section_shell.dart';
import '../../domain/entities/menu_catalog.dart';

class CategoryTabs extends StatelessWidget {
  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelected,
  });

  final List<MenuCategory> categories;
  final int? selectedCategoryId;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    final initialIndex = selectedCategoryId == null
        ? 0
        : categories.indexWhere(
                (category) => category.id == selectedCategoryId,
              ) +
              1;

    return DefaultTabController(
      length: categories.length + 1,
      initialIndex: initialIndex < 0 ? 0 : initialIndex,
      child: SectionShell(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            dividerColor: Colors.transparent,
            indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(18),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: const EdgeInsets.symmetric(
              // horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            labelColor: Theme.of(context).colorScheme.onPrimary,
            unselectedLabelColor: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant,
            onTap: (index) =>
                onSelected(index == 0 ? null : categories[index - 1].id),
            tabs: [
              const Tab(text: 'All'),
              ...categories.map((category) => Tab(text: category.name)),
            ],
          ),
        ),
      ),
    );
  }
}
