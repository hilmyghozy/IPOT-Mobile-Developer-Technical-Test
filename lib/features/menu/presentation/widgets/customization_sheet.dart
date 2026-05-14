import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/section_shell.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../domain/entities/menu_catalog.dart';

class CustomizationSheet extends StatefulWidget {
  const CustomizationSheet({super.key, required this.item});

  final MenuItem item;

  @override
  State<CustomizationSheet> createState() => _CustomizationSheetState();
}

class _CustomizationSheetState extends State<CustomizationSheet> {
  final Map<int, Set<int>> _selectedByGroup = {};
  bool _showValidation = false;

  @override
  void initState() {
    super.initState();
    for (final group in widget.item.customizationGroups) {
      if (group.required &&
          group.isSingleSelection &&
          group.options.isNotEmpty) {
        _selectedByGroup[group.id] = {group.options.first.id};
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice =
        widget.item.price +
        _selectedOptions.fold<double>(
          0,
          (total, selection) => total + selection.priceModifier,
        );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
        ),
        child: SectionShell(
          padding: const EdgeInsets.all(AppSpacing.lg),
          borderRadius: const BorderRadius.all(Radius.circular(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.item.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.item.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppSpacing.md),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.56,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.item.customizationGroups
                        .map((group) => _buildGroup(context, group))
                        .toList(growable: false),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    if (!_validateSelections()) {
                      setState(() => _showValidation = true);
                      return;
                    }

                    Navigator.of(context).pop(_selectedOptions);
                  },
                  child: Text(
                    'Add to cart • ${CurrencyFormatter.format(totalPrice)}',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroup(BuildContext context, CustomizationGroup group) {
    final selectedIds = _selectedByGroup[group.id] ?? <int>{};
    final hasValidationError =
        _showValidation && group.required && selectedIds.isEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: SectionShell(
        backgroundColor: Colors.white.withValues(alpha: 0.28),
        blurSigma: 12,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    group.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  group.required ? 'Required' : 'Optional',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Select up to ${group.maxSelections}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: group.options
                  .map((option) {
                    final selected = selectedIds.contains(option.id);
                    final label = option.priceModifier == 0
                        ? option.name
                        : '${option.name} (+${CurrencyFormatter.format(option.priceModifier)})';

                    return FilterChip(
                      selected: selected,
                      label: Text(label),
                      onSelected: (_) => _toggleOption(group, option.id),
                    );
                  })
                  .toList(growable: false),
            ),
            if (hasValidationError) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Please choose at least one option.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _toggleOption(CustomizationGroup group, int optionId) {
    final currentSelections = Set<int>.from(
      _selectedByGroup[group.id] ?? <int>{},
    );
    final alreadySelected = currentSelections.contains(optionId);

    if (group.isSingleSelection) {
      if (alreadySelected && !group.required) {
        currentSelections.clear();
      } else {
        currentSelections
          ..clear()
          ..add(optionId);
      }
    } else if (alreadySelected) {
      currentSelections.remove(optionId);
    } else if (currentSelections.length < group.maxSelections) {
      currentSelections.add(optionId);
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'You can select up to ${group.maxSelections} options.',
            ),
          ),
        );
      return;
    }

    setState(() {
      _selectedByGroup[group.id] = currentSelections;
      _showValidation = false;
    });
  }

  bool _validateSelections() {
    return widget.item.customizationGroups.every((group) {
      if (!group.required) {
        return true;
      }

      return (_selectedByGroup[group.id] ?? const <int>{}).isNotEmpty;
    });
  }

  List<CartSelection> get _selectedOptions {
    final selections = <CartSelection>[];
    for (final group in widget.item.customizationGroups) {
      final selectedIds = _selectedByGroup[group.id] ?? const <int>{};
      for (final option in group.options.where(
        (item) => selectedIds.contains(item.id),
      )) {
        selections.add(
          CartSelection(
            groupId: group.id,
            groupName: group.name,
            optionId: option.id,
            optionName: option.name,
            priceModifier: option.priceModifier,
          ),
        );
      }
    }

    return List<CartSelection>.unmodifiable(selections);
  }
}
