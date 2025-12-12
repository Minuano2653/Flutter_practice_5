import 'package:fl_prac_5/shared/extensions/format_date.dart';
import 'package:fl_prac_5/shared/widgets/avatar_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/discount_image.dart';
import '../data/discounts_cubit.dart';
import '../../profile/data/user_cubit.dart';
import '../models/discount.dart';
import '../widgets/discount_rating_widget.dart';

class DiscountDetailsScreen extends StatelessWidget {
  final String discountId;

  const DiscountDetailsScreen({super.key, required this.discountId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscountsCubit, List>(
      builder: (context, discounts) {
        final discount = context.read<DiscountsCubit>().getDiscountById(
          discountId,
        );

        if (discount == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Скидка не найдена')),
            body: const Center(child: Text('Скидка не найдена')),
          );
        }

        final currentUserId = context.read<UserCubit>().state.id;
        final isSelf = discount.author.id == currentUserId;
        final theme = Theme.of(context);
        final discountPercent = _calculateDiscountPercent(
          discount.oldPrice,
          discount.newPrice,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Информация о скидке'),
            actions: [
              IconButton(
                onPressed: () {
                  context.push(
                    '/discounts/$discountId/comments',
                    extra: {
                      'title': discount.title,
                      'type': 'discount',
                    },
                  );
                },
                icon: const Icon(Icons.comment_outlined),
              ),
              if (isSelf) ...[
                IconButton(
                  onPressed: () {
                    context.push('/discounts/edit/$discountId');
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    context.read<DiscountsCubit>().deleteDiscount(discountId);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDiscountCard(context, discount, discountPercent, theme),
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
      },
    );
  }

  Widget _buildDiscountCard(
      BuildContext context,
      Discount discount,
      double discountPercent,
      ThemeData theme,
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
                context,
                discount,
                discountPercent,
                theme,
              ),
            ),
            const SizedBox(width: 16),
            // Колонка с виджетом рейтинга и кнопкой избранного
            Column(
              children: [
                DiscountRatingWidget(
                  rating: discount.rating,
                  onUpvote: () {
                    context.read<DiscountsCubit>().upvoteDiscount(discount.id);
                  },
                  onDownvote: () {
                    context.read<DiscountsCubit>().downvoteDiscount(discount.id);
                  },
                  isCompact: false,
                ),
                const SizedBox(height: 12),
                IconButton(
                  onPressed: () {
                    context.read<DiscountsCubit>().toggleFavourite(discountId);
                  },
                  icon: Icon(
                    discount.isInFavourites ? Icons.favorite : Icons.favorite_border,
                    color: discount.isInFavourites ? Colors.orange : Colors.grey,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountInfo(
      BuildContext context,
      Discount discount,
      double discountPercent,
      ThemeData theme,
      ) {
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
        _buildAuthorRow(context, discount),
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

  Widget _buildAuthorRow(BuildContext context, Discount discount) {
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
      ],
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
}