import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../domain/entities/order_models.dart';
import '../../domain/usecases/submit_order.dart';

enum OrderSubmissionStatus { initial, submitting, success, failure }

class OrderSubmissionState extends Equatable {
  const OrderSubmissionState({
    this.status = OrderSubmissionStatus.initial,
    this.receipt,
    this.errorMessage,
  });

  final OrderSubmissionStatus status;
  final OrderReceipt? receipt;
  final String? errorMessage;

  OrderSubmissionState copyWith({
    OrderSubmissionStatus? status,
    OrderReceipt? receipt,
    String? errorMessage,
  }) {
    return OrderSubmissionState(
      status: status ?? this.status,
      receipt: receipt ?? this.receipt,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, receipt, errorMessage];
}

class OrderSubmissionCubit extends Cubit<OrderSubmissionState> {
  OrderSubmissionCubit({required SubmitOrder submitOrder})
    : _submitOrder = submitOrder,
      super(const OrderSubmissionState());

  final SubmitOrder _submitOrder;

  Future<void> submit({
    required String tableId,
    required List<CartItem> items,
    required String customerNote,
  }) async {
    if (items.isEmpty) {
      emit(
        state.copyWith(
          status: OrderSubmissionStatus.failure,
          errorMessage: 'Your cart is empty.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: OrderSubmissionStatus.submitting,
        errorMessage: null,
      ),
    );

    try {
      final receipt = await _submitOrder(
        OrderRequest.fromCart(
          tableId: tableId,
          cartItems: items,
          customerNote: customerNote,
        ),
      );

      emit(
        state.copyWith(
          status: OrderSubmissionStatus.success,
          receipt: receipt,
          errorMessage: null,
        ),
      );
    } on AppException catch (error) {
      emit(
        state.copyWith(
          status: OrderSubmissionStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: OrderSubmissionStatus.failure,
          errorMessage: 'We could not submit the order.',
        ),
      );
    }
  }

  void reset() {
    emit(const OrderSubmissionState());
  }
}
