import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/cart/presentation/pages/cart_page.dart';
import '../features/menu/presentation/cubit/menu_cubit.dart';
import '../features/menu/presentation/pages/menu_page.dart';
import '../features/order/domain/entities/order_models.dart';
import '../features/order/presentation/cubit/order_submission_cubit.dart';
import '../features/order/presentation/cubit/order_tracking_cubit.dart';
import '../features/order/presentation/pages/order_confirmation_page.dart';
import '../features/order/presentation/pages/order_tracking_page.dart';
import '../features/qr_scanner/presentation/cubit/qr_scanner_cubit.dart';
import '../features/qr_scanner/presentation/pages/qr_scanner_page.dart';
import '../injection/injection_container.dart';

class AppRoutes {
  const AppRoutes._();

  static const qrScanner = '/';
  static const menu = '/menu';
  static const cart = '/cart';
  static const orderConfirmation = '/order-confirmation';
  static const orderTracking = '/order-tracking';
}

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.qrScanner:
        return MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) => sl<QrScannerCubit>(),
            child: const QrScannerPage(),
          ),
        );
      case AppRoutes.menu:
        final args = settings.arguments;
        if (args is! MenuRouteArgs) {
          return _buildRouteError(
            settings.name,
            'Missing menu route arguments.',
          );
        }
        return MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) => sl<MenuCubit>()..loadMenu(args.tableId),
            child: MenuPage(args: args),
          ),
        );
      case AppRoutes.cart:
        final args = settings.arguments;
        if (args is! CartRouteArgs) {
          return _buildRouteError(
            settings.name,
            'Missing cart route arguments.',
          );
        }
        return MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) => sl<OrderSubmissionCubit>(),
            child: CartPage(args: args),
          ),
        );
      case AppRoutes.orderConfirmation:
        final args = settings.arguments;
        if (args is! OrderConfirmationRouteArgs) {
          return _buildRouteError(
            settings.name,
            'Missing order confirmation route arguments.',
          );
        }
        return MaterialPageRoute<void>(
          builder: (_) => OrderConfirmationPage(args: args),
        );
      case AppRoutes.orderTracking:
        final args = settings.arguments;
        if (args is! OrderTrackingRouteArgs) {
          return _buildRouteError(
            settings.name,
            'Missing order tracking route arguments.',
          );
        }
        return MaterialPageRoute<void>(
          builder: (_) => BlocProvider(
            create: (_) => sl<OrderTrackingCubit>()..startPolling(args.orderId),
            child: OrderTrackingPage(args: args),
          ),
        );
      default:
        return _buildRouteError(settings.name, 'Unknown route.');
    }
  }

  static Route<dynamic> _buildRouteError(String? routeName, String message) {
    return MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Navigation error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Unable to open route "$routeName": $message',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class MenuRouteArgs {
  const MenuRouteArgs({required this.tableId});

  final String tableId;
}

class CartRouteArgs {
  const CartRouteArgs({required this.tableId, required this.restaurantName});

  final String tableId;
  final String restaurantName;
}

class OrderConfirmationRouteArgs {
  const OrderConfirmationRouteArgs({
    required this.receipt,
    required this.restaurantName,
  });

  final OrderReceipt receipt;
  final String restaurantName;
}

class OrderTrackingRouteArgs {
  const OrderTrackingRouteArgs({
    required this.orderId,
    required this.restaurantName,
  });

  final String orderId;
  final String restaurantName;
}
