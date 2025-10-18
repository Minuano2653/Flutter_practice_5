import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../discounts/models/discount.dart';
import '../../../shared/widgets/discount_item.dart';

class ProfileScreen extends StatefulWidget {
  final List<Discount> discounts;
  final ValueChanged<String> onToggleFavourite;

  const ProfileScreen({
    super.key,
    required this.discounts,
    required this.onToggleFavourite,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Discount> get favouriteDiscounts =>
      widget.discounts.where((d) => d.isInFavourites).toList();

  List<Discount> get myDiscounts =>
      widget.discounts.where((d) => d.author.id == currentUser.id).toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой профиль'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Избранное'),
            Tab(text: 'Мои публикации'),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Аватарка и имя
          Row(
            children: [
              const SizedBox(width: 16),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(currentUser.avatarUrl),
              ),
              const SizedBox(width: 16),
              Text(
                currentUser.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          // Таблы
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDiscountList(favouriteDiscounts),
                _buildDiscountList(myDiscounts),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountList(List<Discount> discounts) {
    if (discounts.isEmpty) {
      return const Center(
        child: Text('Список пуст'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: discounts.length,
      itemBuilder: (context, index) {
        final discount = discounts[index];
        return DiscountItem(
          key: ValueKey(discount.id),
          discount: discount,
          onTap: (dsk) {

          },
          onDelete: (id) {},
          onToggleFavourite: widget.onToggleFavourite,
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
    );
  }
}