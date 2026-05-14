import 'package:equatable/equatable.dart';

import '../../../cart/domain/entities/cart_item.dart';

enum OrderStatusStep { pending, confirmed, preparing, ready, served }

extension OrderStatusStepX on OrderStatusStep {
  String get label => switch (this) {
    OrderStatusStep.pending => 'Pending',
    OrderStatusStep.confirmed => 'Confirmed',
    OrderStatusStep.preparing => 'Preparing',
    OrderStatusStep.ready => 'Ready',
    OrderStatusStep.served => 'Served',
  };

  String get helperText => switch (this) {
    OrderStatusStep.pending => 'Your order is waiting for staff confirmation.',
    OrderStatusStep.confirmed => 'The kitchen accepted your order.',
    OrderStatusStep.preparing => 'The kitchen is preparing your items.',
    OrderStatusStep.ready => 'Your order is ready for delivery to the table.',
    OrderStatusStep.served => 'Your order has been served.',
  };
}

class OrderCustomization extends Equatable {
  const OrderCustomization({required this.optionId, required this.quantity});

  final int optionId;
  final int quantity;

  @override
  List<Object?> get props => [optionId, quantity];
}

class OrderRequestItem extends Equatable {
  const OrderRequestItem({
    required this.menuItemId,
    required this.quantity,
    required this.customizations,
  });

  final int menuItemId;
  final int quantity;
  final List<OrderCustomization> customizations;

  @override
  List<Object?> get props => [menuItemId, quantity, customizations];
}

class OrderRequest extends Equatable {
  const OrderRequest({
    required this.tableId,
    required this.items,
    required this.customerNote,
  });

  final String tableId;
  final List<OrderRequestItem> items;
  final String customerNote;

  factory OrderRequest.fromCart({
    required String tableId,
    required List<CartItem> cartItems,
    required String customerNote,
  }) {
    return OrderRequest(
      tableId: tableId,
      items: cartItems
          .map(
            (item) => OrderRequestItem(
              menuItemId: item.menuItemId,
              quantity: item.quantity,
              customizations: item.selections
                  .map(
                    (selection) => OrderCustomization(
                      optionId: selection.optionId,
                      quantity: 1,
                    ),
                  )
                  .toList(growable: false),
            ),
          )
          .toList(growable: false),
      customerNote: customerNote,
    );
  }

  @override
  List<Object?> get props => [tableId, items, customerNote];
}

class OrderReceipt extends Equatable {
  const OrderReceipt({
    required this.orderId,
    required this.tableId,
    required this.status,
    required this.estimatedPreparationTimeMinutes,
    required this.message,
  });

  final String orderId;
  final String tableId;
  final OrderStatusStep status;
  final int? estimatedPreparationTimeMinutes;
  final String message;

  @override
  List<Object?> get props => [
    orderId,
    tableId,
    status,
    estimatedPreparationTimeMinutes,
    message,
  ];
}

class OrderStatusSnapshot extends Equatable {
  const OrderStatusSnapshot({
    required this.orderId,
    required this.status,
    required this.updatedAt,
    this.estimatedPreparationTimeMinutes,
  });

  final String orderId;
  final OrderStatusStep status;
  final DateTime updatedAt;
  final int? estimatedPreparationTimeMinutes;

  @override
  List<Object?> get props => [
    orderId,
    status,
    updatedAt,
    estimatedPreparationTimeMinutes,
  ];
}
