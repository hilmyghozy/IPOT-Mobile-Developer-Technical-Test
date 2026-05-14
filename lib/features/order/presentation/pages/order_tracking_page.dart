import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/widgets/backdrop_scaffold.dart';
import '../../../../shared/widgets/section_shell.dart';
import '../../domain/entities/order_models.dart';
import '../cubit/order_tracking_cubit.dart';
import '../widgets/order_status_timeline.dart';

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key, required this.args});

  final OrderTrackingRouteArgs args;

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Order tracking'),
            Text(
              args.restaurantName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<OrderTrackingCubit, OrderTrackingState>(
          builder: (context, state) {
            return switch (state.status) {
              OrderTrackingStatus.loading => const AppLoadingView(
                message: 'Checking order status...',
              ),
              OrderTrackingStatus.failure => AppErrorView(
                message:
                    state.errorMessage ??
                    'We could not refresh the order status.',
                onRetry: () => context.read<OrderTrackingCubit>().startPolling(
                  args.orderId,
                ),
              ),
              OrderTrackingStatus.success => _TrackingContent(
                snapshot: state.snapshot!,
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}

class _TrackingContent extends StatelessWidget {
  const _TrackingContent({required this.snapshot});

  final OrderStatusSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final isServed = snapshot.status == OrderStatusStep.served;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionShell(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(label: Text(snapshot.status.label)),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  snapshot.status.helperText,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (snapshot.estimatedPreparationTimeMinutes != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Estimated preparation time: ${snapshot.estimatedPreparationTimeMinutes} minutes',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: SectionShell(
              child: ListView(
                children: [OrderStatusTimeline(currentStatus: snapshot.status)],
              ),
            ),
          ),
          if (isServed)
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.qrScanner,
                    (route) => false,
                  );
                },
                child: const Text('Done'),
              ),
            ),
        ],
      ),
    );
  }
}
