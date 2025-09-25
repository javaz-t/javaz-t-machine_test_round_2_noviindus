class UserEntity {
  final int id;
  final String name;
  final String? image;

  UserEntity({required this.id, required this.name, this.image});
}

class FeedEntity {
  final int id;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final List<int> likes;
  final DateTime createdAt;
  final UserEntity user;

  FeedEntity({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.videoUrl,
    required this.likes,
    required this.createdAt,
    required this.user,
  });
}
