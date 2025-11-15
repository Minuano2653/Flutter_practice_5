import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/discounts_list_controller.dart';
import '../widgets/discounts_list.dart';

class DiscountsListScreen extends ConsumerWidget {
  const DiscountsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discounts = ref.watch(discountsListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Скидки'),
        actions: [
          IconButton(
            onPressed: () => context.push('/discounts/add'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: discounts.isEmpty
          ? const Center(child: Text('Скидок пока нет'))
          : DiscountsList(
              discounts: discounts,
              onToggleFavourite: (id) {
                ref.read(discountsListControllerProvider.notifier).toggleFavourite(id);
              },
              onDiscountTap: (discount) =>
                  context.push('/discounts/${discount.id}'),
              onDelete: (id) {
                ref.read(discountsListControllerProvider.notifier).deleteDiscount(id);
              },
            ),
    );
  }
}
