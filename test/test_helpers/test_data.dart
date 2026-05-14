import 'package:ipot_qr_ordering/features/cart/domain/entities/cart_item.dart';
import 'package:ipot_qr_ordering/features/menu/domain/entities/menu_catalog.dart';
import 'package:ipot_qr_ordering/features/menu/domain/repositories/menu_repository.dart';
import 'package:ipot_qr_ordering/features/order/domain/entities/order_models.dart';
import 'package:ipot_qr_ordering/features/order/domain/repositories/order_repository.dart';

MenuCatalog buildMenuCatalog() {
  return MenuCatalog(
    restaurant: const Restaurant(
      id: 'R001',
      name: 'Sushi Zen',
      tableId: 'T001',
    ),
    categories: const [
      MenuCategory(id: 1, name: 'Appetizers', sortOrder: 1),
      MenuCategory(id: 2, name: 'Main Course', sortOrder: 2),
      MenuCategory(id: 3, name: 'Drinks', sortOrder: 3),
    ],
    items: [
      buildEdamameItem(),
      buildSalmonSashimiItem(),
      buildGreenTeaItem(),
      buildRamenItem(),
    ],
  );
}

MenuItem buildEdamameItem() {
  return const MenuItem(
    id: 1,
    name: 'Edamame',
    description: 'Steamed soybeans with sea salt',
    price: 5.99,
    categoryId: 1,
    imageUrl: null,
    customizationGroups: [],
  );
}

MenuItem buildSalmonSashimiItem() {
  return const MenuItem(
    id: 2,
    name: 'Salmon Sashimi',
    description: 'Fresh Norwegian salmon, 8 pieces',
    price: 16.99,
    categoryId: 2,
    imageUrl: null,
    customizationGroups: [
      CustomizationGroup(
        id: 2,
        name: 'Size',
        required: true,
        maxSelections: 1,
        options: [
          CustomizationOption(id: 4, name: 'Regular (8pc)', priceModifier: 0),
          CustomizationOption(id: 5, name: 'Large (12pc)', priceModifier: 8),
        ],
      ),
    ],
  );
}

MenuItem buildGreenTeaItem() {
  return const MenuItem(
    id: 3,
    name: 'Green Tea',
    description: 'Hot Japanese green tea',
    price: 3.5,
    categoryId: 3,
    imageUrl: null,
    customizationGroups: [],
  );
}

MenuItem buildRamenItem() {
  return const MenuItem(
    id: 4,
    name: 'Chicken Ramen',
    description: 'Rich chicken broth with chashu, egg, and noodles',
    price: 14.99,
    categoryId: 2,
    imageUrl: null,
    customizationGroups: [
      CustomizationGroup(
        id: 3,
        name: 'Spice Level',
        required: true,
        maxSelections: 1,
        options: [
          CustomizationOption(id: 9, name: 'Extra Spicy', priceModifier: 1),
        ],
      ),
      CustomizationGroup(
        id: 4,
        name: 'Add-ons',
        required: false,
        maxSelections: 3,
        options: [
          CustomizationOption(id: 10, name: 'Extra Egg', priceModifier: 2),
        ],
      ),
    ],
  );
}

List<CartSelection> buildRamenSelections() {
  return const [
    CartSelection(
      groupId: 3,
      groupName: 'Spice Level',
      optionId: 9,
      optionName: 'Extra Spicy',
      priceModifier: 1,
    ),
    CartSelection(
      groupId: 4,
      groupName: 'Add-ons',
      optionId: 10,
      optionName: 'Extra Egg',
      priceModifier: 2,
    ),
  ];
}

class FakeMenuRepository implements MenuRepository {
  FakeMenuRepository({MenuCatalog? catalog})
    : _catalog = catalog ?? buildMenuCatalog();

  final MenuCatalog _catalog;

  @override
  Future<MenuCatalog> getMenu({required String tableId}) async {
    return _catalog;
  }
}

class FakeOrderRepository implements OrderRepository {
  @override
  Future<OrderStatusSnapshot> getOrderStatus(String orderId) async {
    return OrderStatusSnapshot(
      orderId: orderId,
      status: OrderStatusStep.pending,
      updatedAt: DateTime(2026, 5, 14),
      estimatedPreparationTimeMinutes: 18,
    );
  }

  @override
  Future<OrderReceipt> submitOrder(OrderRequest request) async {
    return OrderReceipt(
      orderId: 'ORD-TEST-001',
      tableId: request.tableId,
      status: OrderStatusStep.pending,
      estimatedPreparationTimeMinutes: 18,
      message: 'Order submitted successfully.',
    );
  }
}
