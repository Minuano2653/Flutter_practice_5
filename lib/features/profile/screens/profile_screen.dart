import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fl_prac_5/features/discounts/widgets/discounts_list.dart';
import 'package:fl_prac_5/shared/widgets/avatar_image.dart';
import '../../discounts/controllers/discounts_list_controller.dart';
import '../../discounts/models/discount.dart';
import '../../login/controllers/auth_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(authControllerProvider).value;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('Ошибка: пользователь не авторизован')),
      );
    }

    final allDiscounts = ref.watch(discountsListControllerProvider);

    final favouriteDiscounts =
    allDiscounts.where((d) => d.isInFavourites).toList();

    final myDiscounts =
    allDiscounts.where((d) => d.author.id == currentUser.id).toList();

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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await context.push('/profile/edit');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 16),
              AvatarImage(imageUrl: currentUser.avatarUrl, radius: 80),
              const SizedBox(width: 16),
              Text(
                currentUser.name,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDiscountList(favouriteDiscounts, ref),
                _buildDiscountList(myDiscounts, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountList(List<Discount> discounts, WidgetRef ref) {
    if (discounts.isEmpty) {
      return const Center(child: Text('Список пуст'));
    }

    return DiscountsList(
      discounts: discounts,
      onDiscountTap: (discount) {},
      onToggleFavourite: (id) {
        ref.read(discountsListControllerProvider.notifier).toggleFavourite(id);
      },
      onDelete: (id) {
        ref.read(discountsListControllerProvider.notifier).deleteDiscount(id);
      },
    );
  }
}
