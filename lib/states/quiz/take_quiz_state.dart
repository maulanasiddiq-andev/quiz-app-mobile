import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/quiz_exam/question_exam_model.dart';
import 'package:quiz_app/models/quiz_history/quiz_history_model.dart';

class TakeQuizState {
  final bool isLoading;
  final QuizModel? quiz;
  final bool isDone;
  final bool isConfirmedToLeave;
  final int questionIndex;
  final List<QuestionExamModel> questions;
  final QuizHistoryModel? quizHistory;

  TakeQuizState({
    this.isLoading = false,
    this.quiz,
    this.isDone = false,
    this.isConfirmedToLeave = false,
    this.questionIndex = 0,
    this.questions = const [],
    this.quizHistory,
  });

  TakeQuizState copyWith({
    bool? isLoading,
    QuizModel? quiz,
    bool? isDone,
    bool? isConfirmedToLeave,
    int? questionIndex,
    List<QuestionExamModel>? questions,
    QuizHistoryModel? quizHistory,
  }) {
    return TakeQuizState(
      isLoading: isLoading ?? this.isLoading,
      quiz: quiz ?? this.quiz,
      isDone: isDone ?? this.isDone,
      isConfirmedToLeave: isConfirmedToLeave ?? this.isConfirmedToLeave,
      questionIndex: questionIndex ?? this.questionIndex,
      questions: questions ?? this.questions,
      quizHistory: quizHistory ?? this.quizHistory,
    );
  }
}
