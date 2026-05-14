import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/order_models.dart';

class OrderStatusTimeline extends StatelessWidget {
  const OrderStatusTimeline({super.key, required this.currentStatus});

  final OrderStatusStep currentStatus;

  @override
  Widget build(BuildContext context) {
    final currentIndex = OrderStatusStep.values.indexOf(currentStatus);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: OrderStatusStep.values
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final status = entry.value;
            final isComplete = index <= currentIndex;
            final isLast = index == OrderStatusStep.values.length - 1;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: isComplete
                          ? colorScheme.primary
                          : colorScheme.outlineVariant.withValues(alpha: 0.35),
                      child: Icon(
                        isComplete ? Icons.check : Icons.circle_outlined,
                        size: 14,
                        color: isComplete
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (!isLast)
                      Container(
                        width: 2,
                        height: 36,
                        color: isComplete
                            ? colorScheme.primary
                            : colorScheme.outlineVariant.withValues(
                                alpha: 0.35,
                              ),
                      ),
                  ],
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          status.label,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          status.helperText,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
              ],
            );
          })
          .toList(growable: false),
    );
  }
}
