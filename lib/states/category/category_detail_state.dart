import 'package:quiz_app/models/quiz/category_model.dart';

class CategoryDetailState {
  final bool isLoading;
  final bool isLoadingDelete;
  final CategoryModel? category;

  CategoryDetailState({
    this.isLoadingDelete = false,
    this.isLoading = false,
    this.category
  });

  CategoryDetailState copyWith({
    bool? isLoading,
    CategoryModel? category,
    bool? isLoadingDelete
  }) {
    return CategoryDetailState(
      isLoading: isLoading ?? this.isLoading,
      category: category ?? this.category,
      isLoadingDelete: isLoadingDelete ?? this.isLoadingDelete
    );
  }
}