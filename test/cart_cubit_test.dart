import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ipot_qr_ordering/features/cart/domain/entities/cart_item.dart';
import 'package:ipot_qr_ordering/features/cart/presentation/cubit/cart_cubit.dart';

import 'test_helpers/test_data.dart';

void main() {
  group('CartCubit', () {
    blocTest<CartCubit, CartState>(
      'merges identical customized items into one line and keeps subtotal accurate',
      build: CartCubit.new,
      act: (cubit) {
        final ramen = buildRamenItem();
        final selections = buildRamenSelections();
        final lineId = CartItem.composeLineId(ramen.id, selections);

        cubit.addItem(ramen, selections);
        cubit.addItem(ramen, selections);
        cubit.decreaseQuantity(lineId);
      },
      verify: (cubit) {
        expect(cubit.state.items, hasLength(1));
        expect(cubit.state.items.single.quantity, 1);
        expect(cubit.state.itemCount, 1);
        expect(cubit.state.subtotal, closeTo(17.99, 0.001));
      },
    );
  });
}
