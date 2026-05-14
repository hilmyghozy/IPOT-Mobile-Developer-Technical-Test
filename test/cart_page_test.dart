import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ipot_qr_ordering/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ipot_qr_ordering/features/cart/presentation/pages/cart_page.dart';
import 'package:ipot_qr_ordering/features/order/domain/usecases/submit_order.dart';
import 'package:ipot_qr_ordering/features/order/presentation/cubit/order_submission_cubit.dart';
import 'package:ipot_qr_ordering/routes/app_router.dart';

import 'test_helpers/test_data.dart';

void main() {
  testWidgets(
    'CartPage renders cart contents and shows empty state after removal',
    (tester) async {
      final cartCubit = CartCubit()..addItem(buildEdamameItem(), const []);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<CartCubit>.value(value: cartCubit),
            BlocProvider(
              create: (_) => OrderSubmissionCubit(
                submitOrder: SubmitOrder(FakeOrderRepository()),
              ),
            ),
          ],
          child: const MaterialApp(
            home: CartPage(
              args: CartRouteArgs(tableId: 'T001', restaurantName: 'Sushi Zen'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Edamame'), findsOneWidget);
      expect(find.text('Cart is empty'), findsNothing);

    await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Cart is empty'), findsOneWidget);
      expect(find.text('Back to menu'), findsOneWidget);
    },
  );
}
