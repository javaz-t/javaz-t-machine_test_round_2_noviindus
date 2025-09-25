
import 'package:machine_test_round_2_noviindus/domain/entity/category_entity.dart';

class CategoryModel extends CategoryEntity{
  CategoryModel({
    required int id,
    required String title,
    required String imageUrl,
  }) : super(
    id: id,
    title: title,
    imageUrl: imageUrl,
  );

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      title: json['title'] as String,
      imageUrl: json['image'] as String,
    );
  }
}
