import '../../profile/models/user.dart';

class Discount {
  final String id;
  final String title;
  final String newPrice;
  final String oldPrice;
  final String imageUrl;
  final String storeName;
  final User author;
  final String description;
  final bool isInFavourites;
  final DateTime createdAt;

  Discount({
    required this.id,
    required this.title,
    required this.newPrice,
    required this.oldPrice,
    required this.imageUrl,
    required this.storeName,
    required this.author,
    required this.description,
    required this.isInFavourites,
    required this.createdAt,
  });

  Discount copyWith({
    String? id,
    String? title,
    String? newPrice,
    String? oldPrice,
    String? imageUrl,
    String? storeName,
    User? author,
    String? description,
    bool? isInFavourites,
    DateTime? createdAt,
  }) {
    return Discount(
      id: id ?? this.id,
      title: title ?? this.title,
      newPrice: newPrice ?? this.newPrice,
      oldPrice: oldPrice ?? this.oldPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      storeName: storeName ?? this.storeName,
      author: author ?? this.author,
      description: description ?? this.description,
      isInFavourites: isInFavourites ?? this.isInFavourites,
      createdAt: createdAt ?? this.createdAt,
    );
  }

}
