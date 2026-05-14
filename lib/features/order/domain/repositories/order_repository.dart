import '../entities/order_models.dart';

abstract class OrderRepository {
  Future<OrderReceipt> submitOrder(OrderRequest request);

  Future<OrderStatusSnapshot> getOrderStatus(String orderId);
}
