import 'package:quiz_app/models/quiz_history/quiz_history_model.dart';

class QuizHistoryDetailState {
  final bool isLoading;
  final String? quizHistoryId;
  final QuizHistoryModel? quizHistory;
  final int questionIndex;

  QuizHistoryDetailState({
    this.isLoading = false,
    this.quizHistoryId,
    this.questionIndex = 0,
    this.quizHistory
  });

  QuizHistoryDetailState copyWith({
    bool? isLoading,
    String? quizHistoryId,
    int? questionIndex,
    QuizHistoryModel? quizHistory
  }) {
    return QuizHistoryDetailState(
      isLoading: isLoading ?? this.isLoading,
      quizHistoryId: quizHistoryId ?? this.quizHistoryId,
      questionIndex: questionIndex ?? this.questionIndex,
      quizHistory: quizHistory ?? this.quizHistory
    );
  }
}