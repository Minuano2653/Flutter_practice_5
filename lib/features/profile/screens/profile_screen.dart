import 'package:fl_prac_5/features/discounts/widgets/discounts_list.dart';
import 'package:fl_prac_5/shared/widgets/avatar_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/di/di_container.dart';
import '../../discounts/data/discounts_repository.dart';
import '../../discounts/models/discount.dart';
import '../data/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final DiscountsRepository _discountsRepository;
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _discountsRepository = getIt<DiscountsRepository>();
    _userRepository = getIt<UserRepository>();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Discount> get favouriteDiscounts =>
      _discountsRepository.demoDiscounts.where((d) => d.isInFavourites).toList();

  List<Discount> get myDiscounts => _discountsRepository.demoDiscounts
      .where((d) => d.author.id == _userRepository.currentUser.id)
      .toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUser = _userRepository.currentUser;

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
              setState(() {});
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
      return const Center(child: Text('Список пуст'));
    }

    return DiscountsList(
      discounts: discounts,
      onDiscountTap: (dsk) {},
      onToggleFavourite: (id) {
        setState(() {
          _discountsRepository.toggleFavourite(id);
        });
      },
      onDelete: (id) {},
    );
  }
}
