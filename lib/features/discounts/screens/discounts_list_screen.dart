import 'package:flutter/material.dart';
import '../models/discount.dart';
import '../widgets/discounts_list.dart';

class DiscountsListScreen extends StatelessWidget {
  final List<Discount> discounts;
  final void Function() onAdd;
  final ValueChanged<Discount> onDiscountTap;
  final ValueChanged<String> onToggleFavourite;
  final ValueChanged<String> onDelete;

  const DiscountsListScreen({
    required this.discounts,
    required this.onAdd,
    required this.onDiscountTap,
    required this.onToggleFavourite,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Скидки'),
        actions: [IconButton(onPressed: onAdd, icon: const Icon(Icons.add))],
      ),
      body: DiscountsList(
        discounts: discounts,
        onToggleFavourite: onToggleFavourite,
        onDiscountTap: onDiscountTap,
        onDelete: onDelete,
      ),
    );
  }
}
