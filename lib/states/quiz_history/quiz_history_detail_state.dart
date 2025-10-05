import 'package:quiz_app/models/quiz_history/question_history_model.dart';

class QuizHistoryDetailState {
  final bool isLoading;
  final String? quizHistoryId;
  final List<QuestionHistoryModel> questions;
  final int questionIndex;

  QuizHistoryDetailState({
    this.isLoading = false,
    this.quizHistoryId,
    this.questions = const [],
    this.questionIndex = 0
  });

  QuizHistoryDetailState copyWith({
    bool? isLoading,
    String? quizHistoryId,
    List<QuestionHistoryModel>? questions,
    int? questionIndex,
  }) {
    return QuizHistoryDetailState(
      isLoading: isLoading ?? this.isLoading,
      quizHistoryId: quizHistoryId ?? this.quizHistoryId,
      questions: questions ?? this.questions,
      questionIndex: questionIndex ?? this.questionIndex
    );
  }
}