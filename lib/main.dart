import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/app_config.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'injection/injection_container.dart';
import 'routes/app_router.dart';
import 'shared/themes/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();
  await configureDependencies();
  runApp(const IpotQrOrderingApp());
}

class IpotQrOrderingApp extends StatelessWidget {
  const IpotQrOrderingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<CartCubit>(create: (_) => sl<CartCubit>())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'IPOT QR Ordering',
        theme: AppTheme.light(),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppRoutes.qrScanner,
      ),
    );
  }
}
