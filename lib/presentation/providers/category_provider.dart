import 'package:flutter/cupertino.dart';
import 'package:machine_test_round_2_noviindus/domain/entity/category_entity.dart';
import 'package:machine_test_round_2_noviindus/domain/use_case/get_category_use_case.dart';

class CategoryProvider with ChangeNotifier {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoryProvider(this.getCategoriesUseCase);
String selectedCategory='';
  List<CategoryEntity> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  int selectedIndex = 0;
  List<CategoryEntity> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await getCategoriesUseCase.call();
      _categories = result;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error fetching categories: ${e.toString()}';
      _categories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onCategoryChange(int index,String category) {
    selectedIndex = index;
    selectedCategory=category;
    notifyListeners();
  }
}
