import '../../profile/models/user.dart';

enum CommentType {
  discount,
  discussion,
}

class Comment {
  final String id;
  final String entityId;
  final CommentType type;
  final User author;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.entityId,
    required this.type,
    required this.author,
    required this.text,
    required this.createdAt,
  });

  Comment.forDiscount({
    required String id,
    required String discountId,
    required User author,
    required String text,
    required DateTime createdAt,
  }) : this(
    id: id,
    entityId: discountId,
    type: CommentType.discount,
    author: author,
    text: text,
    createdAt: createdAt,
  );

  Comment.forDiscussion({
    required String id,
    required String discussionId,
    required User author,
    required String text,
    required DateTime createdAt,
  }) : this(
    id: id,
    entityId: discussionId,
    type: CommentType.discussion,
    author: author,
    text: text,
    createdAt: createdAt,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entityId': entityId,
      'type': type.name,
      'author': {
        'id': author.id,
        'name': author.name,
        'avatarUrl': author.avatarUrl,
      },
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as String,
      entityId: json['entityId'] as String,
      type: CommentType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => CommentType.discount,
      ),
      author: User(
        id: json['author']['id'] as String,
        name: json['author']['name'] as String,
        avatarUrl: json['author']['avatarUrl'] as String,
      ),
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}