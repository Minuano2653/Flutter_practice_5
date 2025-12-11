import 'package:fl_prac_5/features/profile/data/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../discussions/data/discussions_cubit.dart';
import '../../discussions/models/discussion.dart';
import '../../discussions/widgets/discussion_item.dart';

enum DiscussionFilterType {
  myDiscussions,
  favourites,
}

class FilteredDiscussionsScreen extends StatelessWidget {
  final DiscussionFilterType filterType;

  const FilteredDiscussionsScreen({
    super.key,
    required this.filterType,
  });

  String get _title {
    switch (filterType) {
      case DiscussionFilterType.myDiscussions:
        return 'Мои обсуждения';
      case DiscussionFilterType.favourites:
        return 'Избранные обсуждения';
    }
  }

  String get _emptyMessage {
    switch (filterType) {
      case DiscussionFilterType.myDiscussions:
        return 'Вы еще не создали ни одного обсуждения';
      case DiscussionFilterType.favourites:
        return 'Список избранных обсуждений пуст';
    }
  }

  List<Discussion> _filterDiscussions(List<Discussion> discussions, String currentUserId) {
    switch (filterType) {
      case DiscussionFilterType.myDiscussions:
        return discussions.where((d) => d.author.id == currentUserId).toList();
      case DiscussionFilterType.favourites:
        return discussions.where((d) => d.isInFavourites).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: BlocBuilder<DiscussionsCubit, List<Discussion>>(
        builder: (context, discussions) {
          final currentUserId = context.read<UserCubit>().state.id;
          final filteredDiscussions = _filterDiscussions(discussions, currentUserId);

          if (filteredDiscussions.isEmpty) {
            return Center(
              child: Text(
                _emptyMessage,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: filteredDiscussions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final discussion = filteredDiscussions[index];
              return DiscussionItem(
                discussion: discussion,
                onTap: () => context.push('/discussions/${discussion.id}'),
                onToggleFavourite: () {
                  context.read<DiscussionsCubit>().toggleFavourite(discussion.id);
                },
              );
            },
          );
        },
      ),
    );
  }
}