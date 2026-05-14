import '../../domain/entities/menu_catalog.dart';

class RestaurantModel {
  const RestaurantModel({
    required this.id,
    required this.name,
    required this.tableId,
  });

  final String id;
  final String name;
  final String tableId;

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      tableId: json['table_id'] as String,
    );
  }

  Restaurant toEntity() => Restaurant(id: id, name: name, tableId: tableId);
}

class MenuCategoryModel {
  const MenuCategoryModel({
    required this.id,
    required this.name,
    required this.sortOrder,
  });

  final int id;
  final String name;
  final int sortOrder;

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) {
    return MenuCategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      sortOrder: json['sort_order'] as int,
    );
  }

  MenuCategory toEntity() =>
      MenuCategory(id: id, name: name, sortOrder: sortOrder);
}

class CustomizationOptionModel {
  const CustomizationOptionModel({
    required this.id,
    required this.name,
    required this.priceModifier,
  });

  final int id;
  final String name;
  final double priceModifier;

  factory CustomizationOptionModel.fromJson(Map<String, dynamic> json) {
    return CustomizationOptionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      priceModifier: (json['price_modifier'] as num).toDouble(),
    );
  }

  CustomizationOption toEntity() =>
      CustomizationOption(id: id, name: name, priceModifier: priceModifier);
}

class CustomizationGroupModel {
  const CustomizationGroupModel({
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
  final List<CustomizationOptionModel> options;

  factory CustomizationGroupModel.fromJson(Map<String, dynamic> json) {
    return CustomizationGroupModel(
      id: json['id'] as int,
      name: json['name'] as String,
      required: json['required'] as bool,
      maxSelections: json['max_selections'] as int,
      options: (json['options'] as List<dynamic>)
          .map(
            (item) => CustomizationOptionModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false),
    );
  }

  CustomizationGroup toEntity() => CustomizationGroup(
    id: id,
    name: name,
    required: required,
    maxSelections: maxSelections,
    options: options.map((option) => option.toEntity()).toList(growable: false),
  );
}

class MenuItemModel {
  const MenuItemModel({
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
  final List<CustomizationGroupModel> customizationGroups;

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      categoryId: json['category_id'] as int,
      imageUrl: json['image_url'] as String?,
      customizationGroups: (json['customization_groups'] as List<dynamic>)
          .map(
            (item) => CustomizationGroupModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false),
    );
  }

  MenuItem toEntity() => MenuItem(
    id: id,
    name: name,
    description: description,
    price: price,
    categoryId: categoryId,
    imageUrl: imageUrl,
    customizationGroups: customizationGroups
        .map((group) => group.toEntity())
        .toList(growable: false),
  );
}

class MenuCatalogModel {
  const MenuCatalogModel({
    required this.restaurant,
    required this.categories,
    required this.items,
  });

  final RestaurantModel restaurant;
  final List<MenuCategoryModel> categories;
  final List<MenuItemModel> items;

  factory MenuCatalogModel.fromJson(Map<String, dynamic> json) {
    return MenuCatalogModel(
      restaurant: RestaurantModel.fromJson(
        Map<String, dynamic>.from(json['restaurant'] as Map),
      ),
      categories: (json['categories'] as List<dynamic>)
          .map(
            (item) => MenuCategoryModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList(growable: false),
      items: (json['items'] as List<dynamic>)
          .map(
            (item) =>
                MenuItemModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(growable: false),
    );
  }

  MenuCatalog toEntity() => MenuCatalog(
    restaurant: restaurant.toEntity(),
    categories: categories
        .map((item) => item.toEntity())
        .toList(growable: false),
    items: items.map((item) => item.toEntity()).toList(growable: false),
  );
}
