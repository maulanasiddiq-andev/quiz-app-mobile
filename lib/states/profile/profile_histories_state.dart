import 'package:quiz_app/models/quiz_history/quiz_history_model.dart';

class ProfileHistoriesState {
  final bool isLoading;
  final bool isLoadingMore;
  final int pageIndex;
  final int pageSize;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<QuizHistoryModel> histories;

  ProfileHistoriesState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.pageIndex = 0,
    this.pageSize = 10,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.histories = const []
  });

  ProfileHistoriesState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    int? pageIndex,
    int? pageSize,
    bool? hasNextPage,
    bool? hasPreviousPage,
    List<QuizHistoryModel>? histories
  }) {
    return ProfileHistoriesState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      histories: histories ?? this.histories
    );
  }
}