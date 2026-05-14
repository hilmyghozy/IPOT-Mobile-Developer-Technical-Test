import '../../domain/entities/order_models.dart';

OrderStatusStep _parseOrderStatus(String value) {
  return OrderStatusStep.values.firstWhere(
    (status) => status.name == value,
    orElse: () => OrderStatusStep.pending,
  );
}

class OrderSubmissionResponseModel {
  const OrderSubmissionResponseModel({
    required this.orderId,
    required this.tableId,
    required this.status,
    required this.message,
    required this.estimatedPreparationTimeMinutes,
  });

  final String orderId;
  final String tableId;
  final OrderStatusStep status;
  final String message;
  final int? estimatedPreparationTimeMinutes;

  factory OrderSubmissionResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderSubmissionResponseModel(
      orderId: json['order_id'] as String,
      tableId: json['table_id'] as String,
      status: _parseOrderStatus(json['status'] as String),
      message: json['message'] as String? ?? 'Order submitted successfully.',
      estimatedPreparationTimeMinutes:
          json['estimated_preparation_time_minutes'] as int?,
    );
  }

  OrderReceipt toEntity() => OrderReceipt(
    orderId: orderId,
    tableId: tableId,
    status: status,
    estimatedPreparationTimeMinutes: estimatedPreparationTimeMinutes,
    message: message,
  );
}

class OrderStatusResponseModel {
  const OrderStatusResponseModel({
    required this.orderId,
    required this.status,
    required this.updatedAt,
    this.estimatedPreparationTimeMinutes,
  });

  final String orderId;
  final OrderStatusStep status;
  final DateTime updatedAt;
  final int? estimatedPreparationTimeMinutes;

  factory OrderStatusResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusResponseModel(
      orderId: json['order_id'] as String,
      status: _parseOrderStatus(json['status'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      estimatedPreparationTimeMinutes:
          json['estimated_preparation_time_minutes'] as int?,
    );
  }

  OrderStatusSnapshot toEntity() => OrderStatusSnapshot(
    orderId: orderId,
    status: status,
    updatedAt: updatedAt,
    estimatedPreparationTimeMinutes: estimatedPreparationTimeMinutes,
  );
}

class OrderStatusTemplateModel {
  const OrderStatusTemplateModel({
    required this.statuses,
    required this.estimatedPreparationTimeMinutes,
  });

  final List<OrderStatusStep> statuses;
  final int? estimatedPreparationTimeMinutes;

  factory OrderStatusTemplateModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusTemplateModel(
      statuses: (json['statuses'] as List<dynamic>)
          .map((item) => _parseOrderStatus(item as String))
          .toList(growable: false),
      estimatedPreparationTimeMinutes:
          json['estimated_preparation_time_minutes'] as int?,
    );
  }
}
