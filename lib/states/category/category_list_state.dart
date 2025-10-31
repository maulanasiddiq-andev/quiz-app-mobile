import 'package:quiz_app/constants/sort_dir_constant.dart';
import 'package:quiz_app/models/quiz/category_model.dart';

class CategoryListState {
  final String search;
  final String sortDir;
  final bool isLoading;
  final bool isLoadingMore;
  final int pageIndex;
  final int pageSize;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<CategoryModel> categories;
  final String? deletedCategoryId;

  CategoryListState({
    this.search = "",
    this.sortDir = SortDirConstant.desc,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.pageIndex = 0,
    this.pageSize = 10,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.categories = const [],
    this.deletedCategoryId
  });

  CategoryListState copyWith({
    String? search,
    String? sortDir,
    bool? isLoading,
    bool? isLoadingMore,
    int? pageIndex,
    int? pageSize,
    bool? hasNextPage,
    bool? hasPreviousPage,
    List<CategoryModel>? categories,
    String? deletedCategoryId
  }) {
    return CategoryListState(
      search: search ?? this.search,
      sortDir: sortDir ?? this.sortDir,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      categories: categories ?? this.categories,
      deletedCategoryId: deletedCategoryId ?? this.deletedCategoryId
    );
  }
}