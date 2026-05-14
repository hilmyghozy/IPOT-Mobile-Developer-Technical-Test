import '../../domain/entities/order_models.dart';

class OrderCustomizationModel {
  const OrderCustomizationModel({
    required this.optionId,
    required this.quantity,
  });

  final int optionId;
  final int quantity;

  factory OrderCustomizationModel.fromEntity(OrderCustomization entity) {
    return OrderCustomizationModel(
      optionId: entity.optionId,
      quantity: entity.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {'option_id': optionId, 'quantity': quantity};
  }
}

class OrderRequestItemModel {
  const OrderRequestItemModel({
    required this.menuItemId,
    required this.quantity,
    required this.customizations,
  });

  final int menuItemId;
  final int quantity;
  final List<OrderCustomizationModel> customizations;

  factory OrderRequestItemModel.fromEntity(OrderRequestItem entity) {
    return OrderRequestItemModel(
      menuItemId: entity.menuItemId,
      quantity: entity.quantity,
      customizations: entity.customizations
          .map(OrderCustomizationModel.fromEntity)
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu_item_id': menuItemId,
      'quantity': quantity,
      'customizations': customizations
          .map((item) => item.toJson())
          .toList(growable: false),
    };
  }
}

class OrderRequestModel {
  const OrderRequestModel({
    required this.tableId,
    required this.items,
    required this.customerNote,
  });

  final String tableId;
  final List<OrderRequestItemModel> items;
  final String customerNote;

  factory OrderRequestModel.fromEntity(OrderRequest entity) {
    return OrderRequestModel(
      tableId: entity.tableId,
      items: entity.items
          .map(OrderRequestItemModel.fromEntity)
          .toList(growable: false),
      customerNote: entity.customerNote,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'table_id': tableId,
      'items': items.map((item) => item.toJson()).toList(growable: false),
      'customer_note': customerNote,
    };
  }
}
