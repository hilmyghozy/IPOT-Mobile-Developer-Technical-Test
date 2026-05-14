import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../core/network/app_dio.dart';
import '../core/services/app_config.dart';
import '../core/services/json_asset_loader.dart';
import '../features/cart/presentation/cubit/cart_cubit.dart';
import '../features/menu/data/datasources/menu_data_source.dart';
import '../features/menu/data/repositories/menu_repository_impl.dart';
import '../features/menu/domain/repositories/menu_repository.dart';
import '../features/menu/domain/usecases/get_menu_for_table.dart';
import '../features/menu/presentation/cubit/menu_cubit.dart';
import '../features/order/data/datasources/mock_order_store.dart';
import '../features/order/data/datasources/order_data_source.dart';
import '../features/order/data/repositories/order_repository_impl.dart';
import '../features/order/domain/repositories/order_repository.dart';
import '../features/order/domain/usecases/get_order_status.dart';
import '../features/order/domain/usecases/submit_order.dart';
import '../features/order/presentation/cubit/order_submission_cubit.dart';
import '../features/order/presentation/cubit/order_tracking_cubit.dart';
import '../features/qr_scanner/domain/usecases/parse_table_qr.dart';
import '../features/qr_scanner/presentation/cubit/qr_scanner_cubit.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  if (sl.isRegistered<AppConfig>()) {
    return;
  }

  sl
    ..registerLazySingleton<AppConfig>(() => AppConfig.instance)
    ..registerLazySingleton<Dio>(() => AppDio(sl<AppConfig>()).create())
    ..registerLazySingleton<JsonAssetLoader>(JsonAssetLoader.new)
    ..registerLazySingleton<MenuDataSource>(
      () => LocalMenuDataSource(assetLoader: sl<JsonAssetLoader>()),
    )
    ..registerLazySingleton<MenuRepository>(
      () => MenuRepositoryImpl(dataSource: sl<MenuDataSource>()),
    )
    ..registerLazySingleton<MockOrderStore>(
      () => MockOrderStore(assetLoader: sl<JsonAssetLoader>()),
    )
    ..registerLazySingleton<OrderDataSource>(
      () => MockOrderDataSource(
        assetLoader: sl<JsonAssetLoader>(),
        orderStore: sl<MockOrderStore>(),
      ),
    )
    ..registerLazySingleton<OrderRepository>(
      () => OrderRepositoryImpl(dataSource: sl<OrderDataSource>()),
    )
    ..registerFactory(() => ParseTableQr())
    ..registerFactory(() => QrScannerCubit(parseTableQr: sl<ParseTableQr>()))
    ..registerFactory(() => GetMenuForTable(sl<MenuRepository>()))
    ..registerFactory(() => MenuCubit(getMenuForTable: sl<GetMenuForTable>()))
    ..registerFactory(CartCubit.new)
    ..registerFactory(() => SubmitOrder(sl<OrderRepository>()))
    ..registerFactory(() => GetOrderStatus(sl<OrderRepository>()))
    ..registerFactory(
      () => OrderSubmissionCubit(submitOrder: sl<SubmitOrder>()),
    )
    ..registerFactory(
      () => OrderTrackingCubit(getOrderStatus: sl<GetOrderStatus>()),
    );
}
