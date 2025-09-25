import 'package:machine_test_round_2_noviindus/domain/entity/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories();
}
