import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/widgets/backdrop_scaffold.dart';
import '../../../../shared/widgets/section_shell.dart';

class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key, required this.args});

  final OrderConfirmationRouteArgs args;

  @override
  Widget build(BuildContext context) {
    final receipt = args.receipt;

    return BackdropScaffold(
      appBar: AppBar(title: const Text('Order confirmed')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionShell(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondaryContainer,
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          size: 42,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Thanks, your order is in.',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      receipt.message,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SectionShell(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ID',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    SelectableText(
                      receipt.orderId,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Table',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(receipt.tableId),
                    if (receipt.estimatedPreparationTimeMinutes != null) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Estimated preparation time',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '${receipt.estimatedPreparationTimeMinutes} minutes',
                      ),
                    ],
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                      AppRoutes.orderTracking,
                      arguments: OrderTrackingRouteArgs(
                        orderId: receipt.orderId,
                        restaurantName: args.restaurantName,
                      ),
                    );
                  },
                  child: const Text('Track order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
