import 'package:fl_prac_5/shared/extensions/format_date.dart';
import 'package:fl_prac_5/shared/widgets/avatar_image.dart';
import 'package:flutter/material.dart';
import '../../features/discounts/models/discount.dart';
import 'discount_image.dart';

class DiscountItem extends StatelessWidget {
  final Discount discount;
  final bool isSelf;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFavourite;
  final VoidCallback? onDelete;

  const DiscountItem({
    super.key,
    required this.discount,
    this.isSelf = false,
    this.onTap,
    this.onToggleFavourite,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DiscountImage(imageUrl: discount.imageUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Опубликовано: ${discount.createdAt.toFormattedDate()}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      if (isSelf && onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                          onPressed: onDelete,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    discount.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        discount.newPrice,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.deepOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        discount.oldPrice,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsGeometry.directional(
                          start: 6,
                          end: 6,
                        ),
                        child: Text(
                          "|",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Text(
                        discount.storeName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    discount.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      AvatarImage(imageUrl: discount.author.avatarUrl, radius: 40),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          discount.author.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (onToggleFavourite != null)
                        IconButton(
                          onPressed: onToggleFavourite,
                          icon: Icon(
                            discount.isInFavourites
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: discount.isInFavourites
                                ? Colors.orange
                                : Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}