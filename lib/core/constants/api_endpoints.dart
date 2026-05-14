class ApiEndpoints {
  const ApiEndpoints._();

  static const menu = '/api/v1/menu';
  static const orders = '/api/v1/orders';

  static String orderById(String id) => '$orders/$id';
}
