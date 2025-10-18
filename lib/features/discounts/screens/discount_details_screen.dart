import 'package:fl_prac_5/shared/extensions/format_date.dart';
import 'package:flutter/material.dart';
import '../../../app.dart';
import '../models/discount.dart';

class DiscountDetailsScreen extends StatefulWidget {
  final Discount discount;
  final VoidCallback onBack;
  final ValueChanged<String> onToggleFavourite;
  final ValueChanged<String> onDelete;

  const DiscountDetailsScreen({
    super.key,
    required this.discount,
    required this.onBack,
    required this.onToggleFavourite,
    required this.onDelete,
  });

  @override
  State<DiscountDetailsScreen> createState() => _DiscountDetailsScreenState();
}

class _DiscountDetailsScreenState extends State<DiscountDetailsScreen> {
  late bool isInFavourites;

  @override
  void initState() {
    super.initState();
    isInFavourites = widget.discount.isInFavourites;
  }

  void _handleFavourite() {
    setState(() {
      isInFavourites = !isInFavourites;
    });
    widget.onToggleFavourite(widget.discount.id);
  }

  @override
  Widget build(BuildContext context) {
    final discount = widget.discount;
    final theme = Theme.of(context);
    final discountPercent =
    _calculateDiscountPercent(discount.oldPrice, discount.newPrice);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о скидке'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
        actions: [
          if (discount.author.id == currentUser.id)
            IconButton(
              onPressed: () => widget.onDelete(discount.id),
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Фото
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        discount.imageUrl,
                        width: 320,
                        height: 320,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Опубликовано: ${discount.createdAt.toFormattedDate()}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
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
                          Row(
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
                          ),
                          const SizedBox(height: 10),
                          Text(
                            discount.storeName,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: Colors.orange[800],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundImage:
                                NetworkImage(discount.author.avatarUrl),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  discount.author.name,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: _handleFavourite,
                                icon: Icon(
                                  isInFavourites
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isInFavourites
                                      ? Colors.orange
                                      : Colors.grey,
                                  size: 30,
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
            ),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
