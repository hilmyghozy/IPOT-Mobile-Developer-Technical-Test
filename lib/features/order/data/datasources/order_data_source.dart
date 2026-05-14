import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/json_asset_loader.dart';
import '../models/order_request_model.dart';
import '../models/order_response_models.dart';
import 'mock_order_store.dart';

abstract class OrderDataSource {
  Future<OrderSubmissionResponseModel> submitOrder(OrderRequestModel request);

  Future<OrderStatusResponseModel> getOrderStatus(String orderId);
}

class MockOrderDataSource implements OrderDataSource {
  const MockOrderDataSource({
    required JsonAssetLoader assetLoader,
    required MockOrderStore orderStore,
  }) : _assetLoader = assetLoader,
       _orderStore = orderStore;

  final JsonAssetLoader _assetLoader;
  final MockOrderStore _orderStore;

  @override
  Future<OrderSubmissionResponseModel> submitOrder(
    OrderRequestModel request,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));

    if (request.items.isEmpty) {
      throw const AppException(
        'Add at least one menu item before submitting the order.',
      );
    }

    if (request.tableId.trim().isEmpty) {
      throw const AppException(
        'Missing table information. Please rescan the QR code.',
      );
    }

    final template = await _assetLoader.loadObject(
      'assets/mock/order_success.json',
    );
    final orderId = _buildOrderId();
    await _orderStore.seedOrder(orderId);

    return OrderSubmissionResponseModel.fromJson({
      ...template,
      'order_id': orderId,
      'table_id': request.tableId,
    });
  }

  @override
  Future<OrderStatusResponseModel> getOrderStatus(String orderId) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    return _orderStore.nextStatus(orderId);
  }

  String _buildOrderId() {
    final now = DateTime.now();
    return 'ORD-${now.millisecondsSinceEpoch}';
  }
}
