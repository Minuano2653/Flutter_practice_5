import 'dart:io';
import 'dart:convert';

void main() async {
  // Хранилище комментариев в памяти (раздельно для скидок и обсуждений)
  final Map<String, List<Map<String, dynamic>>> discountComments = {};
  final Map<String, List<Map<String, dynamic>>> discussionComments = {};

  // Список подключенных клиентов
  final List<WebSocket> clients = [];

  // HTTP сервер для WebSocket upgrade
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print('🚀 Сервер комментариев запущен на ws://localhost:8080');
  print('📡 Ожидание подключений...\n');

  await for (HttpRequest request in server) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      final socket = await WebSocketTransformer.upgrade(request);
      clients.add(socket);
      print('✅ Новое подключение. Всего клиентов: ${clients.length}');

      socket.listen(
            (message) {
          try {
            final data = jsonDecode(message as String);
            final action = data['action'] as String;
            final type = data['type'] as String; // 'discount' или 'discussion'

            // Выбираем нужное хранилище
            final storage = type == 'discount' ? discountComments : discussionComments;

            switch (action) {
              case 'load':
              // Загрузить комментарии
                final entityId = data['entityId'] as String;
                final comments = storage[entityId] ?? [];
                socket.add(jsonEncode({
                  'action': 'comments',
                  'type': type,
                  'entityId': entityId,
                  'comments': comments,
                }));
                print('📥 Загружены комментарии для $type $entityId');
                break;

              case 'add':
              // Добавить новый комментарий
                final entityId = data['entityId'] as String;
                final comment = data['comment'] as Map<String, dynamic>;

                storage.putIfAbsent(entityId, () => []);
                storage[entityId]!.add(comment);

                // Отправить всем клиентам
                final broadcast = jsonEncode({
                  'action': 'new_comment',
                  'type': type,
                  'entityId': entityId,
                  'comment': comment,
                });

                for (final client in clients) {
                  try {
                    client.add(broadcast);
                  } catch (e) {
                    print('⚠️  Ошибка отправки клиенту: $e');
                  }
                }
                print('📤 Новый комментарий добавлен для $type $entityId');
                break;

              case 'delete':
              // Удалить комментарий
                final entityId = data['entityId'] as String;
                final commentId = data['commentId'] as String;

                if (storage.containsKey(entityId)) {
                  storage[entityId]!.removeWhere(
                        (c) => c['id'] == commentId,
                  );

                  // Уведомить всех клиентов
                  final broadcast = jsonEncode({
                    'action': 'delete_comment',
                    'type': type,
                    'entityId': entityId,
                    'commentId': commentId,
                  });

                  for (final client in clients) {
                    try {
                      client.add(broadcast);
                    } catch (e) {
                      print('⚠️  Ошибка отправки клиенту: $e');
                    }
                  }
                  print('🗑️  Комментарий удален: $commentId');
                }
                break;
            }
          } catch (e) {
            print('❌ Ошибка обработки сообщения: $e');
          }
        },
        onDone: () {
          clients.remove(socket);
          print('👋 Клиент отключился. Осталось клиентов: ${clients.length}');
        },
        onError: (error) {
          print('❌ Ошибка WebSocket: $error');
          clients.remove(socket);
        },
      );
    }
  }
}