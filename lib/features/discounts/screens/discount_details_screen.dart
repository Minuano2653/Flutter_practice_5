import 'package:fl_prac_5/shared/extensions/format_date.dart';
import 'package:fl_prac_5/shared/widgets/avatar_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:collection/collection.dart';
import '../../../shared/widgets/discount_image.dart';
import '../../login/controllers/auth_controller.dart';
import '../controllers/discounts_list_controller.dart';
import '../models/discount.dart';

class DiscountDetailsScreen extends ConsumerWidget {
  final String discountId;

  const DiscountDetailsScreen({super.key, required this.discountId});

  void _handleFavourite(WidgetRef ref) {
    ref.read(discountsListControllerProvider.notifier).toggleFavourite(discountId);
  }

  void _handleDelete(BuildContext context, WidgetRef ref) {
    ref.read(discountsListControllerProvider.notifier).deleteDiscount(discountId);
    context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final discount = ref.watch(
      discountsListControllerProvider.select(
        (state) => state.firstWhereOrNull((d) => d.id == discountId),
      ),
    );

    final currentUserId = ref.watch(authControllerProvider).value?.id;

    if (discount == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Скидка не найдена')),
        body: const Center(child: Text('Скидка не найдена или была удалена')),
      );
    }

    final theme = Theme.of(context);
    final discountPercent = _calculateDiscountPercent(
      discount.oldPrice,
      discount.newPrice,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о скидке'),
        actions: [
          if (currentUserId != null && discount.author.id == currentUserId)
            IconButton(
              onPressed: () => _handleDelete(context, ref),
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDiscountCard(discount, discountPercent, context, ref),
            const SizedBox(height: 24),
            Text(
              'Подробнее о скидке',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              discount.description,
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateDiscountPercent(String oldPrice, String newPrice) {
    try {
      final oldVal = double.parse(oldPrice.replaceAll(RegExp(r'[^0-9.]'), ''));
      final newVal = double.parse(newPrice.replaceAll(RegExp(r'[^0-9.]'), ''));
      if (oldVal <= 0) return 0;
      return ((oldVal - newVal) / oldVal * 100).roundToDouble();
    } catch (_) {
      return 0;
    }
  }

  Widget _buildDiscountCard(
    Discount discount,
    double discountPercent,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DiscountImage(imageUrl: discount.imageUrl, width: 320, height: 320),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDiscountInfo(
                discount,
                discountPercent,
                context,
                ref,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountInfo(
    Discount discount,
    double discountPercent,
    BuildContext context,
    WidgetRef ref,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Опубликовано: ${discount.createdAt.toFormattedDate()}',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Text(
          discount.title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 10),
        _buildPriceRow(discount, discountPercent),
        const SizedBox(height: 10),
        Text(
          discount.storeName,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.orange[800],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildAuthorRow(discount, context, ref),
      ],
    );
  }

  Widget _buildPriceRow(Discount discount, double discountPercent) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          discount.newPrice,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          discount.oldPrice,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        if (discountPercent > 0) ...[
          const SizedBox(width: 10),
          Text(
            '-$discountPercent%',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAuthorRow(
    Discount discount,
    BuildContext context,
    WidgetRef ref,
  ) {
    return Row(
      children: [
        AvatarImage(imageUrl: discount.author.avatarUrl, radius: 80),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            discount.author.name,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        IconButton(
          onPressed: () => _handleFavourite(ref),
          icon: Icon(
            discount.isInFavourites ? Icons.favorite : Icons.favorite_border,
            color: discount.isInFavourites ? Colors.orange : Colors.grey,
            size: 30,
          ),
        ),
      ],
    );
  }
}
