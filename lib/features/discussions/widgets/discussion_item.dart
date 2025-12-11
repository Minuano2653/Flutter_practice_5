import 'package:flutter/material.dart';
import '../../../features/discussions/models/discussion.dart';
import '../../../shared/extensions/format_date.dart';
import '../../../shared/widgets/avatar_image.dart';

class DiscussionItem extends StatelessWidget {
  final Discussion discussion;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFavourite;

  const DiscussionItem({
    super.key,
    required this.discussion,
    this.onTap,
    this.onToggleFavourite,
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
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AvatarImage(
                  imageUrl: discussion.author.avatarUrl,
                  radius: 40,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        discussion.author.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        discussion.createdAt.toFormattedDate(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                if (onToggleFavourite != null)
                  IconButton(
                    onPressed: onToggleFavourite,
                    icon: Icon(
                      discussion.isInFavourites
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: discussion.isInFavourites
                          ? Colors.orange
                          : Colors.grey,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              discussion.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              discussion.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
