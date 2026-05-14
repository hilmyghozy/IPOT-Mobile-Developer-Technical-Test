import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../menu/domain/entities/menu_catalog.dart';
import '../../domain/entities/cart_item.dart';

class CartState extends Equatable {
  const CartState({this.items = const []});

  final List<CartItem> items;

  bool get isEmpty => items.isEmpty;

  int get itemCount =>
      items.fold<int>(0, (count, item) => count + item.quantity);

  double get subtotal =>
      items.fold<double>(0, (total, item) => total + item.totalPrice);

  CartState copyWith({List<CartItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addItem(MenuItem item, List<CartSelection> selections) {
    final lineId = CartItem.composeLineId(item.id, selections);
    final currentItems = List<CartItem>.from(state.items);
    final existingIndex = currentItems.indexWhere(
      (cartItem) => cartItem.lineId == lineId,
    );

    if (existingIndex >= 0) {
      final existingItem = currentItems[existingIndex];
      currentItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      currentItems.add(
        CartItem.fromMenuItem(
          item: item,
          selections: List<CartSelection>.unmodifiable(selections),
        ),
      );
    }

    emit(state.copyWith(items: List<CartItem>.unmodifiable(currentItems)));
  }

  void increaseQuantity(String lineId) {
    emit(
      state.copyWith(
        items: state.items
            .map(
              (item) => item.lineId == lineId
                  ? item.copyWith(quantity: item.quantity + 1)
                  : item,
            )
            .toList(growable: false),
      ),
    );
  }

  void decreaseQuantity(String lineId) {
    final updatedItems = <CartItem>[];
    for (final item in state.items) {
      if (item.lineId != lineId) {
        updatedItems.add(item);
        continue;
      }

      if (item.quantity > 1) {
        updatedItems.add(item.copyWith(quantity: item.quantity - 1));
      }
    }

    emit(state.copyWith(items: List<CartItem>.unmodifiable(updatedItems)));
  }

  void removeItem(String lineId) {
    emit(
      state.copyWith(
        items: state.items
            .where((item) => item.lineId != lineId)
            .toList(growable: false),
      ),
    );
  }

  void clear() {
    emit(const CartState());
  }
}
