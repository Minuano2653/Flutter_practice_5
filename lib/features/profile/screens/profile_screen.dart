import 'package:fl_prac_5/features/discounts/widgets/discounts_list.dart';
import 'package:fl_prac_5/shared/widgets/avatar_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/di_container.dart';
import '../../discounts/data/discounts_cubit.dart';
import '../../discounts/data/discounts_repository.dart';
import '../../discounts/data/user_cubit.dart';
import '../../discounts/models/discount.dart';
import '../data/user_repository.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, User>(
      builder: (context, currentUser) {
        return BlocBuilder<DiscountsCubit, List<Discount>>(
          builder: (context, discounts) {
            final favouriteDiscounts =
            discounts.where((d) => d.isInFavourites).toList();
            final myDiscounts = discounts
                .where((d) => d.author.id == currentUser.id)
                .toList();

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
                      context.go('/login');
                    },
                  )
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
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildDiscountList(favouriteDiscounts, currentUser.id),
                        _buildDiscountList(myDiscounts, currentUser.id),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDiscountList(List<Discount> discounts, String currentUserId) {
    if (discounts.isEmpty) {
      return const Center(child: Text('Список пуст'));
    }

    return DiscountsList(
      discounts: discounts,
      currentUserId: currentUserId,
      onDiscountTap: (discount) => context.push('/discounts/${discount.id}'),
      onToggleFavourite: (id) {
        context.read<DiscountsCubit>().toggleFavourite(id);
      },
      onDelete: (id) {
        context.read<DiscountsCubit>().deleteDiscount(id);
      },
    );
  }
}
