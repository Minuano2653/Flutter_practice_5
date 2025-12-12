import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/comments_cubit.dart';
import '../models/comment.dart';
import '../../profile/data/user_cubit.dart';
import '../../../shared/widgets/avatar_image.dart';
import '../../../shared/extensions/format_date.dart';

class CommentsScreen extends StatefulWidget {
  final String entityId; // ID скидки или обсуждения
  final String entityTitle; // Название скидки или обсуждения
  final CommentType type; // Тип комментария

  const CommentsScreen({
    super.key,
    required this.entityId,
    required this.entityTitle,
    required this.type,
  });

  // Конструктор для скидок
  const CommentsScreen.forDiscount({
    super.key,
    required String discountId,
    required String discountTitle,
  })  : entityId = discountId,
        entityTitle = discountTitle,
        type = CommentType.discount;

  // Конструктор для обсуждений
  const CommentsScreen.forDiscussion({
    super.key,
    required String discussionId,
    required String discussionTitle,
  })  : entityId = discussionId,
        entityTitle = discussionTitle,
        type = CommentType.discussion;

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CommentsCubit>().loadComments(widget.entityId, widget.type);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendComment() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    final currentUser = context.read<UserCubit>().state;
    final comment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      entityId: widget.entityId,
      type: widget.type,
      author: currentUser,
      text: text,
      createdAt: DateTime.now(),
    );

    _textController.clear();
    context.read<CommentsCubit>().addComment(comment);

    // Прокручиваем вниз
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentUserId = context.read<UserCubit>().state.id;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Комментарии'),
            Text(
              widget.entityTitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[300],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Список комментариев
          Expanded(
            child: BlocBuilder<CommentsCubit, CommentsState>(
              builder: (context, state) {
                if (state is CommentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CommentsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          'Ошибка подключения',
                          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            state.message,
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<CommentsCubit>().loadComments(
                              widget.entityId,
                              widget.type,
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Повторить'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Убедитесь, что сервер запущен:\ndart run bin/comments_server.dart',
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                if (state is CommentsLoaded) {
                  if (state.comments.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.comment_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Пока нет комментариев',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Будьте первым!',
                            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.comments.length,
                    itemBuilder: (context, index) {
                      final comment = state.comments[index];
                      final isSelf = comment.author.id == currentUserId;

                      return _CommentItem(
                        comment: comment,
                        isSelf: isSelf,
                        onDelete: () {
                          context.read<CommentsCubit>().deleteComment(
                            comment.id,
                            widget.entityId,
                            widget.type
                          );
                        },
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),

          // Поле ввода
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Напишите комментарий...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendComment(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendComment,
                  icon: Icon(Icons.send, color: theme.colorScheme.primary),
                  style: IconButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  final Comment comment;
  final bool isSelf;
  final VoidCallback onDelete;

  const _CommentItem({
    required this.comment,
    required this.isSelf,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarImage(imageUrl: comment.author.avatarUrl, radius: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isSelf
                    ? theme.colorScheme.primary.withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          comment.author.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isSelf)
                        IconButton(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete, size: 18),
                          color: Colors.red,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(comment.text, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(
                    comment.createdAt.toFormattedDate(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}