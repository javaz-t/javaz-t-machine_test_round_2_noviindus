
import 'package:machine_test_round_2_noviindus/data/model/category_model.dart';
import 'package:machine_test_round_2_noviindus/data/services/category_service.dart';
import 'package:machine_test_round_2_noviindus/domain/entity/category_entity.dart';
import 'package:machine_test_round_2_noviindus/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryApiService apiService;

  CategoryRepositoryImpl(this.apiService);

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final List<CategoryModel> categoryModels = await apiService.fetchCategories();
     return categoryModels;
  }
}
