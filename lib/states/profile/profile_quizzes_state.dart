import 'package:quiz_app/models/quiz/quiz_model.dart';

class ProfileQuizzesState {
  final bool isLoading;
  final bool isLoadingMore;
  final int pageIndex;
  final int pageSize;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<QuizModel> quizzes;

  ProfileQuizzesState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.pageIndex = 0,
    this.pageSize = 10,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.quizzes = const []
  });

  ProfileQuizzesState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    int? pageIndex,
    int? pageSize,
    bool? hasNextPage,
    bool? hasPreviousPage,
    List<QuizModel>? quizzes
  }) {
    return ProfileQuizzesState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      quizzes: quizzes ?? this.quizzes
    );
  }
}