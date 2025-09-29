import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/quiz_history/quiz_history_model.dart';

class QuizDetailState {
  final bool isLoading;
  final bool isLoadingHistories;
  final List<QuizHistoryModel> histories;
  final QuizModel? quiz;

  QuizDetailState({
    this.isLoading = false,
    this.isLoadingHistories = false,
    this.histories = const [],
    this.quiz
  });

  QuizDetailState copyWith({
    bool? isLoading,
    bool? isLoadingHistories,
    QuizModel? quiz,
    List<QuizHistoryModel>? histories
  }) {
    return QuizDetailState(
      isLoading: isLoading ?? this.isLoading, 
      isLoadingHistories: isLoadingHistories ?? this.isLoadingHistories,
      quiz: quiz ?? this.quiz,
      histories: histories ?? this.histories
    );
  }
}