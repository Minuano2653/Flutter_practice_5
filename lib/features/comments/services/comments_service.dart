import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/comment.dart';

class CommentsService {
  WebSocketChannel? _channel;
  final _commentsController = StreamController<List<Comment>>.broadcast();
  final Map<String, List<Comment>> _cache = {};
  bool _isConnected = false;

  Stream<List<Comment>> get commentsStream => _commentsController.stream;
  bool get isConnected => _isConnected;

  // Подключиться к серверу
  Future<void> connect() async {
    if (_isConnected) return;

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://localhost:8080'),
      );

      _isConnected = true;
      print('✅ Подключено к серверу комментариев');

      // Слушаем сообщения от сервера
      _channel!.stream.listen(
            (message) {
          _handleMessage(message as String);
        },
        onDone: () {
          print('👋 Отключено от сервера');
          _isConnected = false;
        },
        onError: (error) {
          print('❌ Ошибка WebSocket: $error');
          _isConnected = false;
        },
      );
    } catch (e) {
      print('❌ Не удалось подключиться к серверу: $e');
      _isConnected = false;
      rethrow;
    }
  }

  // Обработка сообщений от сервера
  void _handleMessage(String message) {
    try {
      final data = jsonDecode(message);
      final action = data['action'] as String;

      switch (action) {
        case 'comments':
        // Полный список комментариев
          final entityId = data['entityId'] as String;
          final commentsJson = data['comments'] as List;
          final comments = commentsJson
              .map((json) => Comment.fromJson(json as Map<String, dynamic>))
              .toList();

          _cache[entityId] = comments;
          _commentsController.add(comments);
          break;

        case 'new_comment':
        // Новый комментарий
          final entityId = data['entityId'] as String;
          final comment = Comment.fromJson(
            data['comment'] as Map<String, dynamic>,
          );

          _cache.putIfAbsent(entityId, () => []);
          _cache[entityId]!.add(comment);
          _commentsController.add(_cache[entityId]!);
          break;

        case 'delete_comment':
        // Удален комментарий
          final entityId = data['entityId'] as String;
          final commentId = data['commentId'] as String;

          if (_cache.containsKey(entityId)) {
            _cache[entityId]!.removeWhere((c) => c.id == commentId);
            _commentsController.add(_cache[entityId]!);
          }
          break;
      }
    } catch (e) {
      print('❌ Ошибка обработки сообщения: $e');
    }
  }

  // Загрузить комментарии
  void loadComments(String entityId, CommentType type) {
    if (!_isConnected) return;

    _channel!.sink.add(jsonEncode({
      'action': 'load',
      'type': type.name,
      'entityId': entityId,
    }));
  }

  // Добавить комментарий
  void addComment(Comment comment) {
    if (!_isConnected) return;

    _channel!.sink.add(jsonEncode({
      'action': 'add',
      'type': comment.type.name,
      'entityId': comment.entityId,
      'comment': comment.toJson(),
    }));
  }

  // Удалить комментарий
  void deleteComment(String commentId, String entityId, CommentType type) {
    if (!_isConnected) return;

    _channel!.sink.add(jsonEncode({
      'action': 'delete',
      'type': type.name,
      'entityId': entityId,
      'commentId': commentId,
    }));
  }

  // Отключиться от сервера
  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
  }

  void dispose() {
    disconnect();
    _commentsController.close();
  }
}