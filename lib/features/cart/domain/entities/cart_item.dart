import 'package:equatable/equatable.dart';

import '../../../menu/domain/entities/menu_catalog.dart';

class CartSelection extends Equatable {
  const CartSelection({
    required this.groupId,
    required this.groupName,
    required this.optionId,
    required this.optionName,
    required this.priceModifier,
  });

  final int groupId;
  final String groupName;
  final int optionId;
  final String optionName;
  final double priceModifier;

  @override
  List<Object?> get props => [
    groupId,
    groupName,
    optionId,
    optionName,
    priceModifier,
  ];
}

class CartItem extends Equatable {
  const CartItem({
    required this.lineId,
    required this.menuItemId,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.quantity,
    required this.selections,
    this.imageUrl,
  });

  final String lineId;
  final int menuItemId;
  final String name;
  final String description;
  final double basePrice;
  final int quantity;
  final String? imageUrl;
  final List<CartSelection> selections;

  factory CartItem.fromMenuItem({
    required MenuItem item,
    required List<CartSelection> selections,
  }) {
    return CartItem(
      lineId: composeLineId(item.id, selections),
      menuItemId: item.id,
      name: item.name,
      description: item.description,
      basePrice: item.price,
      quantity: 1,
      imageUrl: item.imageUrl,
      selections: List<CartSelection>.unmodifiable(selections),
    );
  }

  static String composeLineId(int menuItemId, List<CartSelection> selections) {
    final sortedIds = selections.map((selection) => selection.optionId).toList()
      ..sort();
    return '$menuItemId:${sortedIds.join('-')}';
  }

  double get modifiersTotal => selections.fold<double>(
    0,
    (total, selection) => total + selection.priceModifier,
  );

  double get unitPrice => basePrice + modifiersTotal;

  double get totalPrice => unitPrice * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      lineId: lineId,
      menuItemId: menuItemId,
      name: name,
      description: description,
      basePrice: basePrice,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl,
      selections: selections,
    );
  }

  @override
  List<Object?> get props => [
    lineId,
    menuItemId,
    name,
    description,
    basePrice,
    quantity,
    imageUrl,
    selections,
  ];
}
