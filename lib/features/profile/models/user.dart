class User {
  final String id;
  final String name;
  final String avatarUrl;

  User({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  User copyWith({
    String? id,
    String? name,
    String? avatarUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
