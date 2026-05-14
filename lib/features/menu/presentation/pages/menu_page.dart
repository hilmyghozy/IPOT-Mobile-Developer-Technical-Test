import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/build_context_x.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/widgets/backdrop_scaffold.dart';
import '../../../../shared/widgets/section_shell.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../domain/entities/menu_catalog.dart';
import '../cubit/menu_cubit.dart';
import '../widgets/category_tabs.dart';
import '../widgets/customization_sheet.dart';
import '../widgets/menu_item_card.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key, required this.args});

  final MenuRouteArgs args;

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        final restaurantName = state.catalog?.restaurant.name ?? 'Menu';

        return BackdropScaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(restaurantName),
                Text(
                  'Table ${widget.args.tableId}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: switch (state.status) {
                MenuStatus.loading => const AppLoadingView(
                  message: 'Loading menu...',
                ),
                MenuStatus.failure => AppErrorView(
                  message: state.errorMessage ?? 'We could not load the menu.',
                  onRetry: () =>
                      context.read<MenuCubit>().loadMenu(widget.args.tableId),
                ),
                MenuStatus.success => _MenuSuccessView(
                  state: state,
                  searchController: _searchController,
                  onSearchChanged: context.read<MenuCubit>().updateSearchQuery,
                  onCategorySelected: context.read<MenuCubit>().selectCategory,
                  onAddPressed: (item) => _handleAddItem(context, item),
                ),
                _ => const SizedBox.shrink(),
              },
            ),
          ),
          bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
            builder: (context, cartState) {
              if (cartState.isEmpty || state.catalog == null) {
                return const SizedBox.shrink();
              }

              return SafeArea(
                minimum: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: SectionShell(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${cartState.itemCount} items in cart',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              CurrencyFormatter.format(cartState.subtotal),
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            AppRoutes.cart,
                            arguments: CartRouteArgs(
                              tableId: widget.args.tableId,
                              restaurantName: state.catalog!.restaurant.name,
                            ),
                          );
                        },
                        child: const Text('View cart'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _handleAddItem(BuildContext context, MenuItem item) async {
    if (!item.hasCustomizations) {
      context.read<CartCubit>().addItem(item, const <CartSelection>[]);
      context.showAppSnackBar('${item.name} added to cart.');
      return;
    }

    final selectedOptions = await showModalBottomSheet<List<CartSelection>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CustomizationSheet(item: item),
    );

    if (selectedOptions == null) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    context.read<CartCubit>().addItem(item, selectedOptions);
    context.showAppSnackBar('${item.name} added to cart.');
  }
}

class _MenuSuccessView extends StatelessWidget {
  const _MenuSuccessView({
    required this.state,
    required this.searchController,
    required this.onSearchChanged,
    required this.onCategorySelected,
    required this.onAddPressed,
  });

  final MenuState state;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<int?> onCategorySelected;
  final ValueChanged<MenuItem> onAddPressed;

  @override
  Widget build(BuildContext context) {
    final catalog = state.catalog!;

    return RefreshIndicator(
      onRefresh: () =>
          context.read<MenuCubit>().loadMenu(catalog.restaurant.tableId),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          SectionShell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Browse the menu',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${catalog.items.length} dishes across ${catalog.categories.length} categories',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _PagePill(label: 'Table ${catalog.restaurant.tableId}'),
                    _PagePill(label: catalog.restaurant.name),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SectionShell(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search menu items',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          CategoryTabs(
            categories: state.categories,
            selectedCategoryId: state.selectedCategoryId,
            onSelected: onCategorySelected,
          ),
          const SizedBox(height: AppSpacing.md),
          if (state.visibleItems.isEmpty)
            const AppEmptyView(
              title: 'No menu items found',
              message: 'Try another keyword or category.',
              icon: Icons.search_off_outlined,
            )
          else
            ...state.visibleItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: MenuItemCard(
                  item: item,
                  onAdd: () => onAddPressed(item),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PagePill extends StatelessWidget {
  const _PagePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.42)),
      ),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
