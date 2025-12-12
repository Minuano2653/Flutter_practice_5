import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../data/user_cubit.dart';
import '../models/user.dart';
import '../../../shared/widgets/avatar_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, User>(
      builder: (context, currentUser) {
        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Мой профиль'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.push('/profile/edit'),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => context.go('/login'),
              ),
            ],
          ),
          body: Column(
            children: [
              const SizedBox(height: 24),

              // Информация о пользователе
              Row(
                children: [
                  const SizedBox(width: 16),
                  AvatarImage(imageUrl: currentUser.avatarUrl, radius: 80),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      currentUser.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(height: 1),
              const SizedBox(height: 8),

              // Список пунктов меню
              Expanded(
                child: ListView(
                  children: [
                    _buildMenuItem(
                      context: context,
                      icon: Icons.favorite,
                      title: 'Избранные скидки',
                      onTap: () => context.push('/profile/favourites'),
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.local_offer,
                      title: 'Мои скидки',
                      onTap: () => context.push('/profile/my-discounts'),
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.forum_outlined,
                      title: 'Избранные обсуждения',
                      onTap: () => context.push('/profile/favourite-discussions'),
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.forum,
                      title: 'Мои обсуждения',
                      onTap: () => context.push('/profile/my-discussions'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}