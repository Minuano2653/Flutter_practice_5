import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/comment.dart';
import '../services/comments_service.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final CommentsService _service = CommentsService();
  StreamSubscription? _subscription;

  CommentsCubit() : super(CommentsInitial());

  // Подключиться к серверу и загрузить комментарии
  Future<void> loadComments(String entityId, CommentType type) async {
    try {
      emit(CommentsLoading());

      // Подключаемся к серверу, если еще не подключены
      if (!_service.isConnected) {
        await _service.connect();
      }

      // Подписываемся на поток комментариев
      _subscription?.cancel();
      _subscription = _service.commentsStream.listen((comments) {
        emit(CommentsLoaded(comments));
      });

      // Запрашиваем комментарии
      _service.loadComments(entityId, type);
    } catch (e) {
      emit(CommentsError('Не удалось подключиться к серверу: $e'));
    }
  }

  // Добавить комментарий
  void addComment(Comment comment) {
    try {
      _service.addComment(comment);
    } catch (e) {
      emit(CommentsError('Ошибка добавления комментария: $e'));
    }
  }

  // Удалить комментарий
  void deleteComment(String commentId, String entityId, CommentType type) {
    try {
      _service.deleteComment(commentId, entityId, type);
    } catch (e) {
      emit(CommentsError('Ошибка удаления комментария: $e'));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _service.dispose();
    return super.close();
  }
}

// Состояния
abstract class CommentsState {}

class CommentsInitial extends CommentsState {}

class CommentsLoading extends CommentsState {}

class CommentsLoaded extends CommentsState {
  final List<Comment> comments;
  CommentsLoaded(this.comments);
}

class CommentsError extends CommentsState {
  final String message;
  CommentsError(this.message);
}