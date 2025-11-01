import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/quiz_history/quiz_history_model.dart';

class QuizDetailState {
  final bool isLoading;
  final bool isLoadingHistories;
  final bool isLoadingMoreHistories;
  final int historyPageIndex;
  final int historyPageSize;
  final bool historyHasNextPage;
  final List<QuizHistoryModel> histories;
  final QuizModel? quiz;
  final bool isLoadingDelete;

  QuizDetailState({
    this.isLoading = false,
    this.isLoadingHistories = false,
    this.isLoadingMoreHistories = false,
    this.histories = const [],
    this.quiz,
    this.historyHasNextPage = false,
    this.historyPageIndex = 0,
    this.historyPageSize = 10,
    this.isLoadingDelete = false
  });

  QuizDetailState copyWith({
    bool? isLoading,
    bool? isLoadingHistories,
    bool? isLoadingMoreHistories,
    QuizModel? quiz,
    List<QuizHistoryModel>? histories,
    bool? historyHasNextPage,
    int? historyPageIndex,
    int? historyPageSize,
    bool? isLoadingDelete
  }) {
    return QuizDetailState(
      isLoading: isLoading ?? this.isLoading, 
      isLoadingHistories: isLoadingHistories ?? this.isLoadingHistories,
      isLoadingMoreHistories: isLoadingMoreHistories ?? this.isLoadingMoreHistories,
      quiz: quiz ?? this.quiz,
      histories: histories ?? this.histories,
      historyHasNextPage: historyHasNextPage ?? this.historyHasNextPage,
      historyPageIndex: historyPageIndex ?? this.historyPageIndex,
      historyPageSize: historyPageSize ?? this.historyPageSize,
      isLoadingDelete: isLoadingDelete ?? this.isLoadingDelete
    );
  }
}