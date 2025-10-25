import 'package:quiz_app/models/quiz/category_model.dart';

class CategoryDetailState {
  final bool isLoading;
  final CategoryModel? category;

  CategoryDetailState({
    this.isLoading = false,
    this.category
  });

  CategoryDetailState copyWith({
    bool? isLoading,
    CategoryModel? category
  }) {
    return CategoryDetailState(
      isLoading: isLoading ?? this.isLoading,
      category: category ?? this.category
    );
  }
}