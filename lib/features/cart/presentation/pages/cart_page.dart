import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/build_context_x.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../routes/app_router.dart';
import '../../../../shared/widgets/backdrop_scaffold.dart';
import '../../../../shared/widgets/section_shell.dart';
import '../../../order/presentation/cubit/order_submission_cubit.dart';
import '../cubit/cart_cubit.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_summary_card.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key, required this.args});

  final CartRouteArgs args;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderSubmissionCubit, OrderSubmissionState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == OrderSubmissionStatus.failure &&
            state.errorMessage != null) {
          context.showAppSnackBar(state.errorMessage!);
          return;
        }

        if (state.status == OrderSubmissionStatus.success &&
            state.receipt != null) {
          context.read<CartCubit>().clear();
          Navigator.of(context).pushReplacementNamed(
            AppRoutes.orderConfirmation,
            arguments: OrderConfirmationRouteArgs(
              receipt: state.receipt!,
              restaurantName: widget.args.restaurantName,
            ),
          );
        }
      },
      child: BackdropScaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your cart'),
              Text(
                widget.args.restaurantName,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state.isEmpty) {
                return AppEmptyView(
                  title: 'Cart is empty',
                  message:
                      'Add a few dishes from the menu to start your order.',
                  icon: Icons.shopping_cart_outlined,
                  action: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Back to menu'),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(AppSpacing.md),
                children: [
                  SectionShell(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Review your order',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Text(
                                'Table ${widget.args.tableId} • ${widget.args.restaurantName}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        _CountPill(count: state.itemCount),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...state.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: CartItemTile(
                        item: item,
                        onIncrease: () => context
                            .read<CartCubit>()
                            .increaseQuantity(item.lineId),
                        onDecrease: () => context
                            .read<CartCubit>()
                            .decreaseQuantity(item.lineId),
                        onRemove: () =>
                            context.read<CartCubit>().removeItem(item.lineId),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SectionShell(
                    child: TextField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Customer note',
                        hintText: 'No MSG please',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
          builder: (context, cartState) {
            if (cartState.isEmpty) {
              return const SizedBox.shrink();
            }

            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.sm,
                  AppSpacing.md,
                  AppSpacing.md,
                ),
                child: SectionShell(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CartSummaryCard(
                        itemCount: cartState.itemCount,
                        subtotal: cartState.subtotal,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      BlocBuilder<OrderSubmissionCubit, OrderSubmissionState>(
                        builder: (context, submissionState) {
                          final isSubmitting =
                              submissionState.status ==
                              OrderSubmissionStatus.submitting;

                          return SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: isSubmitting
                                  ? null
                                  : () => context
                                        .read<OrderSubmissionCubit>()
                                        .submit(
                                          tableId: widget.args.tableId,
                                          items: cartState.items,
                                          customerNote: _noteController.text
                                              .trim(),
                                        ),
                              child: isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text('Submit order'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.42)),
      ),
      child: Text('$count items', style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
