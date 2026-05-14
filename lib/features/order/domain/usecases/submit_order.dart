import '../entities/order_models.dart';
import '../repositories/order_repository.dart';

class SubmitOrder {
  const SubmitOrder(this._repository);

  final OrderRepository _repository;

  Future<OrderReceipt> call(OrderRequest request) {
    return _repository.submitOrder(request);
  }
}
