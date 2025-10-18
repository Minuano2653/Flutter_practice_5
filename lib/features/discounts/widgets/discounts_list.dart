import 'package:flutter/material.dart';

import '../../../shared/widgets/empty_state.dart';
import '../models/discount.dart';
import '../../../shared/widgets/discount_item.dart';

class DiscountsList extends StatelessWidget {
  final List<Discount> discounts;
  final ValueChanged<Discount> onDiscountTap;
  final ValueChanged<String> onToggleFavourite;
  final ValueChanged<String> onDelete;

  const DiscountsList({
    super.key,
    required this.discounts,
    required this.onDiscountTap,
    required this.onToggleFavourite,
    required this.onDelete
  });

  @override
  Widget build(BuildContext context) {
    if (discounts.isEmpty) {
      return EmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: discounts.length,
      itemBuilder: (context, index) {
        final discount = discounts[index];
        return DiscountItem(
          key: ValueKey(discount.id),
          discount: discount,
          onTap: (dsk) => onDiscountTap(dsk),
          onToggleFavourite: onToggleFavourite,
          onDelete: onDelete,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}
