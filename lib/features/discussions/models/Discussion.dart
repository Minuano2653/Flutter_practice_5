import 'package:fl_prac_5/features/profile/models/user.dart';

class Discussion {
  final String id;
  final String title;
  final String description;
  final List<String> imageUrls;
  final User author;
  final DateTime createdAt;
  final bool isInFavourites;

  Discussion({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.author,
    required this.createdAt,
    this.isInFavourites = false,
  });

  Discussion copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? imageUrls,
    User? author,
    DateTime? createdAt,
    bool? isInFavourites,
  }) {
    return Discussion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrls: imageUrls ?? this.imageUrls,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      isInFavourites: isInFavourites ?? this.isInFavourites,
    );
  }
}