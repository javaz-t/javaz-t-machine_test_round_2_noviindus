
import 'package:machine_test_round_2_noviindus/domain/entity/feed_entity.dart';

class UserModel extends UserEntity {
  UserModel({required super.id, required super.name, super.image});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String?,
    );
  }
}

class FeedModel extends FeedEntity {
  FeedModel({
    required int id,
    required String description,
    required String imageUrl,
    required String videoUrl,
    required List<int> likes,
    required DateTime createdAt,
    required UserModel user,
  }) : super(
    id: id,
    description: description,
    imageUrl: imageUrl,
    videoUrl: videoUrl,
    likes: likes,
    createdAt: createdAt,
    user: user,
  );

  factory FeedModel.fromJson(Map<String, dynamic> json) {
    return FeedModel(
      id: json['id'] as int,
      description: json['description'] as String,
      imageUrl: json['image'] as String,
      videoUrl: json['video'] as String,
      likes: List<int>.from(json['likes']),
      createdAt: DateTime.parse(json['created_at']),
      user: UserModel.fromJson(json['user']),
    );
  }
}
