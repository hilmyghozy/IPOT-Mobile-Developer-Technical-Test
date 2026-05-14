import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  const Restaurant({
    required this.id,
    required this.name,
    required this.tableId,
  });

  final String id;
  final String name;
  final String tableId;

  @override
  List<Object?> get props => [id, name, tableId];
}

class MenuCategory extends Equatable {
  const MenuCategory({
    required this.id,
    required this.name,
    required this.sortOrder,
  });

  final int id;
  final String name;
  final int sortOrder;

  @override
  List<Object?> get props => [id, name, sortOrder];
}

class CustomizationOption extends Equatable {
  const CustomizationOption({
    required this.id,
    required this.name,
    required this.priceModifier,
  });

  final int id;
  final String name;
  final double priceModifier;

  @override
  List<Object?> get props => [id, name, priceModifier];
}

class CustomizationGroup extends Equatable {
  const CustomizationGroup({
    required this.id,
    required this.name,
    required this.required,
    required this.maxSelections,
    required this.options,
  });

  final int id;
  final String name;
  final bool required;
  final int maxSelections;
  final List<CustomizationOption> options;

  bool get isSingleSelection => maxSelections == 1;

  @override
  List<Object?> get props => [id, name, required, maxSelections, options];
}

class MenuItem extends Equatable {
  const MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageUrl,
    required this.customizationGroups,
  });

  final int id;
  final String name;
  final String description;
  final double price;
  final int categoryId;
  final String? imageUrl;
  final List<CustomizationGroup> customizationGroups;

  bool get hasCustomizations => customizationGroups.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    categoryId,
    imageUrl,
    customizationGroups,
  ];
}

class MenuCatalog extends Equatable {
  const MenuCatalog({
    required this.restaurant,
    required this.categories,
    required this.items,
  });

  final Restaurant restaurant;
  final List<MenuCategory> categories;
  final List<MenuItem> items;

  List<MenuItem> filterItems({
    required int? categoryId,
    required String query,
  }) {
    final normalizedQuery = query.trim().toLowerCase();

    return items
        .where((item) {
          final matchesCategory =
              categoryId == null || item.categoryId == categoryId;
          if (!matchesCategory) {
            return false;
          }

          if (normalizedQuery.isEmpty) {
            return true;
          }

          return item.name.toLowerCase().contains(normalizedQuery) ||
              item.description.toLowerCase().contains(normalizedQuery);
        })
        .toList(growable: false);
  }

  @override
  List<Object?> get props => [restaurant, categories, items];
}
