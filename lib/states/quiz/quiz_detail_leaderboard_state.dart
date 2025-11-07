import 'package:quiz_app/constants/sort_dir_constant.dart';
import 'package:quiz_app/models/quiz_history/quiz_history_model.dart';

class QuizDetailLeaderboardState {
  final String search;
  final String sortDir;
  final bool isLoading;
  final bool isLoadingMore;
  final int pageIndex;
  final int pageSize;
  final bool hasNextPage;
  final bool hasPreviousPage;
  final List<QuizHistoryModel> histories;

  QuizDetailLeaderboardState({
    this.search = "",
    this.sortDir = SortDirConstant.desc,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.pageIndex = 0,
    this.pageSize = 10,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
    this.histories = const [],
  });

  QuizDetailLeaderboardState copyWith({
    String? search,
    String? sortDir,
    bool? isLoading,
    bool? isLoadingMore,
    int? pageIndex,
    int? pageSize,
    bool? hasNextPage,
    bool? hasPreviousPage,
    List<QuizHistoryModel>? histories,
  }) {
    return QuizDetailLeaderboardState(
      search: search ?? this.search,
      sortDir: sortDir ?? this.sortDir,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pageIndex: pageIndex ?? this.pageIndex,
      pageSize: pageSize ?? this.pageSize,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      hasPreviousPage: hasPreviousPage ?? this.hasPreviousPage,
      histories: histories ?? this.histories,
    );
  }
}