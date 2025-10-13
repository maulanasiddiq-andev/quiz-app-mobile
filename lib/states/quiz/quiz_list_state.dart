import 'package:quiz_app/models/quiz/category_model.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';

class QuizListState {
  final bool isLoadingQuizzes;
  final bool isLoadingMoreQuizzes;
  final bool isRefreshingQuizzes;
  final int quizPageIndex;
  final int quizPageSize;
  final bool quizHasNextPage;
  final List<QuizModel> quizzes;

  final bool isLoadingCategories;
  final bool isLoadingMoreCategories;
  final bool isRefreshingCategories;
  final int categoryPageIndex;
  final int categoryPageSize;
  final bool categoryHasNextPage;
  final List<CategoryModel> categories;

  QuizListState({
    this.isLoadingQuizzes = false,
    this.isLoadingMoreQuizzes = false,
    this.isRefreshingQuizzes = false,
    this.quizPageIndex = 0,
    this.quizPageSize = 10,
    this.quizHasNextPage = false,
    this.quizzes = const [],
    this.isLoadingCategories = false,
    this.isLoadingMoreCategories = false,
    this.isRefreshingCategories = false,
    this.categoryPageIndex = 0,
    this.categoryPageSize = 10,
    this.categoryHasNextPage = false,
    this.categories = const [],
  });

  QuizListState copyWith({
    bool? isLoadingQuizzes,
    bool? isLoadingMoreQuizzes,
    bool? isRefreshingQuizzes,
    int? quizPageIndex,
    int? quizPageSize = 10,
    bool? quizHasNextPage,
    List<QuizModel>? quizzes,
    bool? isLoadingCategories,
    bool? isLoadingMoreCategories,
    bool? isRefreshingCategories,
    int? categoryPageIndex,
    int? categoryPageSize = 10,
    bool? categoryHasNextPage,
    List<CategoryModel>? categories,
  }) {
    return QuizListState(
      isLoadingQuizzes: isLoadingQuizzes ?? this.isLoadingQuizzes,
      isLoadingMoreQuizzes: isLoadingMoreQuizzes ?? this.isLoadingMoreQuizzes,
      isRefreshingQuizzes: isRefreshingQuizzes ?? this.isRefreshingQuizzes,
      quizPageIndex: quizPageIndex ?? this.quizPageIndex,
      quizPageSize: quizPageSize ?? this.quizPageSize,
      quizHasNextPage: quizHasNextPage ?? this.quizHasNextPage,
      quizzes: quizzes ?? this.quizzes,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      isLoadingMoreCategories: isLoadingMoreCategories ?? this.isLoadingMoreCategories,
      isRefreshingCategories: isRefreshingCategories ?? this.isRefreshingCategories,
      categoryPageIndex: categoryPageIndex ?? this.categoryPageIndex,
      categoryPageSize: categoryPageSize ?? this.categoryPageSize,
      categoryHasNextPage: categoryHasNextPage ?? this.categoryHasNextPage,
      categories: categories ?? this.categories,
    );
  }
}
