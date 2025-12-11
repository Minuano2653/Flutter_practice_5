import 'package:fl_prac_5/shared/widgets/universal_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../data/discussions_cubit.dart';
import '../models/discussion.dart';
import '../../profile/data/user_cubit.dart';
import '../../../shared/extensions/format_date.dart';
import '../../../shared/widgets/avatar_image.dart';

class DiscussionDetailsScreen extends StatefulWidget {
  final String discussionId;

  const DiscussionDetailsScreen({
    super.key,
    required this.discussionId,
  });

  @override
  State<DiscussionDetailsScreen> createState() =>
      _DiscussionDetailsScreenState();
}

class _DiscussionDetailsScreenState extends State<DiscussionDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить обсуждение?'),
        content: const Text(
          'Это действие нельзя отменить. Вы уверены, что хотите удалить это обсуждение?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<DiscussionsCubit>().deleteDiscussion(widget.discussionId);
              Navigator.pop(dialogContext);
              context.go('/discussions');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscussionsCubit, List<Discussion>>(
      builder: (context, discussions) {
        final discussion = context.read<DiscussionsCubit>().getDiscussionById(
          widget.discussionId,
        );

        if (discussion == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Обсуждение не найдено')),
            body: const Center(child: Text('Обсуждение не найдено')),
          );
        }

        final currentUserId = context.read<UserCubit>().state.id;
        final isSelf = discussion.author.id == currentUserId;
        final theme = Theme.of(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Обсуждение'),
            actions: [
              IconButton(
                onPressed: () {
                  context.read<DiscussionsCubit>().toggleFavourite(discussion.id);
                },
                icon: Icon(
                  discussion.isInFavourites
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: discussion.isInFavourites ? Colors.orange : null,
                ),
              ),
              if (isSelf) ...[
                IconButton(
                  onPressed: () =>
                      context.push('/discussions/edit/${widget.discussionId}'),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => _showDeleteDialog(context),
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
                // Автор и дата
                Row(
                  children: [
                    AvatarImage(
                      imageUrl: discussion.author.avatarUrl,
                      radius: 48,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            discussion.author.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Опубликовано: ${discussion.createdAt.toFormattedDate()}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Заголовок
                Text(
                  discussion.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Изображения + индикаторы
                if (discussion.imageUrls.isNotEmpty) ...[
                  SizedBox(
                    height: 500,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: discussion.imageUrls.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: UniversalImage(
                              source: discussion.imageUrls[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (discussion.imageUrls.length > 1) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        discussion.imageUrls.length,
                            (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 12 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? theme.colorScheme.primary
                                : Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],

                // Описание
                Text(
                  discussion.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
