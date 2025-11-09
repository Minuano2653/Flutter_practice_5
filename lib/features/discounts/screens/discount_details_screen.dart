import 'package:fl_prac_5/shared/extensions/format_date.dart';
import 'package:fl_prac_5/shared/widgets/avatar_image.dart';
import 'package:flutter/material.dart';
import '../../../core/di/di_container.dart';
import '../../../shared/widgets/discount_image.dart';
import '../../profile/data/user_repository.dart';
import '../data/discounts_repository.dart';
import '../models/discount.dart';

class DiscountDetailsScreen extends StatefulWidget {
  final String discountId;

  const DiscountDetailsScreen({
    super.key,
    required this.discountId,
  });

  @override
  State<DiscountDetailsScreen> createState() => _DiscountDetailsScreenState();
}

class _DiscountDetailsScreenState extends State<DiscountDetailsScreen> {
  late final DiscountsRepository _discountsRepository;
  late final UserRepository _userRepository;
  late Discount _discount;

  @override
  void initState() {
    super.initState();
    _discountsRepository = getIt<DiscountsRepository>();
    _userRepository = getIt<UserRepository>();
    _discount = _discountsRepository.demoDiscounts.firstWhere(
          (d) => d.id == widget.discountId,
    );
  }

  void _handleFavourite() {
    setState(() {
      _discountsRepository.toggleFavourite(widget.discountId);
      _discount = _discountsRepository.demoDiscounts.firstWhere(
            (d) => d.id == widget.discountId,
      );
    });
  }

  void _handleDelete() {
    _discountsRepository.deleteDiscount(widget.discountId);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final discountPercent = _calculateDiscountPercent(
      _discount.oldPrice,
      _discount.newPrice,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о скидке'),
        actions: [
          if (_discount.author.id == _userRepository.currentUser.id)
            IconButton(
              onPressed: _handleDelete,
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDiscountCard(_discount, discountPercent),
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
              _discount.description,
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountCard(Discount discount, double discountPercent) {
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
            Expanded(child: _buildDiscountInfo(discount, discountPercent)),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountInfo(Discount discount, double discountPercent) {
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
        _buildAuthorRow(discount),
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

  Widget _buildAuthorRow(Discount discount) {
    return Row(
      children: [
        AvatarImage(imageUrl: discount.author.avatarUrl, radius: 80),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            discount.author.name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        IconButton(
          onPressed: _handleFavourite,
          icon: Icon(
            _discount.isInFavourites ? Icons.favorite : Icons.favorite_border,
            color: _discount.isInFavourites ? Colors.orange : Colors.grey,
            size: 30,
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
