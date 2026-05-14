import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/json_asset_loader.dart';
import '../models/order_response_models.dart';

class MockOrderStore {
  MockOrderStore({required JsonAssetLoader assetLoader})
    : _assetLoader = assetLoader;

  final JsonAssetLoader _assetLoader;
  final Map<String, int> _orderProgress = {};

  OrderStatusTemplateModel? _cachedTemplate;

  Future<void> seedOrder(String orderId) async {
    await _loadTemplate();
    _orderProgress[orderId] = 0;
  }

  Future<OrderStatusResponseModel> nextStatus(String orderId) async {
    final template = await _loadTemplate();
    final currentIndex = _orderProgress[orderId];
    if (currentIndex == null) {
      throw NotFoundException(
        'We could not find this order in the mock store.',
      );
    }

    final status = template.statuses[currentIndex];
    if (currentIndex < template.statuses.length - 1) {
      _orderProgress[orderId] = currentIndex + 1;
    }

    return OrderStatusResponseModel.fromJson({
      'order_id': orderId,
      'status': status.name,
      'estimated_preparation_time_minutes':
          template.estimatedPreparationTimeMinutes,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<OrderStatusTemplateModel> _loadTemplate() async {
    final cachedTemplate = _cachedTemplate;
    if (cachedTemplate != null) {
      return cachedTemplate;
    }

    final json = await _assetLoader.loadObject('assets/mock/order_status.json');
    final template = OrderStatusTemplateModel.fromJson(json);
    _cachedTemplate = template;
    return template;
  }
}
