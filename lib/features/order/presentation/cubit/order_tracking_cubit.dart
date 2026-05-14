import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/order_models.dart';
import '../../domain/usecases/get_order_status.dart';

enum OrderTrackingStatus { initial, loading, success, failure }

class OrderTrackingState extends Equatable {
  const OrderTrackingState({
    this.status = OrderTrackingStatus.initial,
    this.snapshot,
    this.errorMessage,
  });

  final OrderTrackingStatus status;
  final OrderStatusSnapshot? snapshot;
  final String? errorMessage;

  OrderTrackingState copyWith({
    OrderTrackingStatus? status,
    OrderStatusSnapshot? snapshot,
    String? errorMessage,
  }) {
    return OrderTrackingState(
      status: status ?? this.status,
      snapshot: snapshot ?? this.snapshot,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, snapshot, errorMessage];
}

class OrderTrackingCubit extends Cubit<OrderTrackingState> {
  OrderTrackingCubit({required GetOrderStatus getOrderStatus})
    : _getOrderStatus = getOrderStatus,
      super(const OrderTrackingState());

  final GetOrderStatus _getOrderStatus;

  Timer? _timer;
  String? _orderId;
  bool _isFetching = false;

  Future<void> startPolling(String orderId) async {
    _orderId = orderId;
    _timer?.cancel();
    emit(
      state.copyWith(status: OrderTrackingStatus.loading, errorMessage: null),
    );

    await _fetchStatus();
    if (state.snapshot?.status != OrderStatusStep.served &&
        state.status == OrderTrackingStatus.success) {
      _timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => _fetchStatus(),
      );
    }
  }

  Future<void> _fetchStatus() async {
    if (_isFetching || _orderId == null) {
      return;
    }

    _isFetching = true;
    try {
      final snapshot = await _getOrderStatus(_orderId!);
      emit(
        state.copyWith(
          status: OrderTrackingStatus.success,
          snapshot: snapshot,
          errorMessage: null,
        ),
      );

      if (snapshot.status == OrderStatusStep.served) {
        _timer?.cancel();
      }
    } on AppException catch (error) {
      emit(
        state.copyWith(
          status: OrderTrackingStatus.failure,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: OrderTrackingStatus.failure,
          errorMessage: 'We could not refresh the order status.',
        ),
      );
    } finally {
      _isFetching = false;
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
