import 'package:flutter/material.dart';

import '../../../shared/widgets/empty_state.dart';
import '../models/discount.dart';
import '../../../shared/widgets/discount_item.dart';

class DiscountsList extends StatelessWidget {
  final List<Discount> discounts;
  final String currentUserId;
  final ValueChanged<Discount>? onDiscountTap;
  final ValueChanged<String>? onToggleFavourite;
  final ValueChanged<String>? onDelete;

  const DiscountsList({
    super.key,
    required this.discounts,
    required this.currentUserId,
    this.onDiscountTap,
    this.onToggleFavourite,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (discounts.isEmpty) {
      return const EmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: discounts.length,
      itemBuilder: (context, index) {
        final discount = discounts[index];
        final isSelf = discount.author.id == currentUserId;

        return DiscountItem(
          key: ValueKey(discount.id),
          discount: discount,
          isSelf: isSelf,
          onTap: onDiscountTap != null ? () => onDiscountTap!(discount) : null,
          onToggleFavourite: onToggleFavourite != null
              ? () => onToggleFavourite!(discount.id)
              : null,
          onDelete: (isSelf && onDelete != null)
              ? () => onDelete!(discount.id)
              : null,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
    );
  }
}
