import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/order_models.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_data_source.dart';
import '../models/order_request_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  const OrderRepositoryImpl({required OrderDataSource dataSource})
    : _dataSource = dataSource;

  final OrderDataSource _dataSource;

  @override
  Future<OrderStatusSnapshot> getOrderStatus(String orderId) async {
    try {
      final response = await _dataSource.getOrderStatus(orderId);
      return response.toEntity();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException('We could not refresh the order status.');
    }
  }

  @override
  Future<OrderReceipt> submitOrder(OrderRequest request) async {
    try {
      final response = await _dataSource.submitOrder(
        OrderRequestModel.fromEntity(request),
      );
      return response.toEntity();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const AppException('We could not submit the order.');
    }
  }
}
