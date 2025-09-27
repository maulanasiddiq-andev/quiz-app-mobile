import 'package:quiz_app/models/quiz/quiz_model.dart';

class QuizState {
  final bool isLoading;
  final bool isLoadingMore;
  final bool isRefreshing;
  final int pageIndex;
  final int pageSize;
  final bool hasNextPage;
  final List<QuizModel> quizzes;

  QuizState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.pageIndex = 0,
    this.pageSize = 10,
    this.hasNextPage = false,
    this.quizzes = const []
  });

  QuizState copyWith({
    bool? isLoading = false,
    bool? isLoadingMore = false,
    bool? isRefreshing = false,
    int? pageIndex = 0,
    int? pageSize = 10,
    bool? hasNextPage = false,
    List<QuizModel>? quizzes
  }) {
    return QuizState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      quizzes: quizzes ?? this.quizzes
    );
  }
}