import 'package:quiz_app/models/quiz/category_model.dart';

class CategoryEditState {
  final bool isLoading;
  final CategoryModel? category;
  final bool isLoadingUpdate;

  const CategoryEditState({
    this.isLoading = false,
    this.category,
    this.isLoadingUpdate = false,
  });

  CategoryEditState copyWith({
    bool? isLoading,
    CategoryModel? category,
    bool? isLoadingUpdate,
  }) {
    return CategoryEditState(
      isLoading: isLoading ?? this.isLoading,
      category: category ?? this.category,
      isLoadingUpdate: isLoadingUpdate ?? this.isLoadingUpdate,
    );
  }
}