import '../entities/order_models.dart';
import '../repositories/order_repository.dart';

class GetOrderStatus {
  const GetOrderStatus(this._repository);

  final OrderRepository _repository;

  Future<OrderStatusSnapshot> call(String orderId) {
    return _repository.getOrderStatus(orderId);
  }
}
