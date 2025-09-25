

import 'package:machine_test_round_2_noviindus/domain/entity/category_entity.dart';
import 'package:machine_test_round_2_noviindus/domain/repository/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

   Future<List<CategoryEntity>> call() async {
    return await repository.getCategories();
  }
}
