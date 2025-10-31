import 'package:fl_prac_5/features/discounts/widgets/discounts_list.dart';
import 'package:fl_prac_5/shared/widgets/avatar_image.dart';
import 'package:flutter/material.dart';

import '../../../app.dart';
import '../../discounts/models/discount.dart';
import 'edit_profile_screen.dart';

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

  void _showEditProfileScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(user: currentUser, onBack: _onBack)
      ),
    );
    setState(() {});
  }

  void _onBack() {
    Navigator.pop(context);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _showEditProfileScreen
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Аватарка и имя
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
      return const Center(child: Text('Список пуст'));
    }

    return DiscountsList(
      discounts: discounts,
      onDiscountTap: (dsk) {},
      onToggleFavourite: widget.onToggleFavourite,
      onDelete: (id) {},
    );
  }
}
