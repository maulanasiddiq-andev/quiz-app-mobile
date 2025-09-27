import 'package:quiz_app/models/quiz/questions_model.dart';

class QuizExamState {
  final int questionIndex;
  final List<QuestionsModel> questions;
  final QuestionsModel? currentQuestion;

  QuizExamState({
    this.questionIndex = 0,
    this.questions = const [],
    this.currentQuestion
  });

  QuizExamState copyWith({
    int? questionIndex,
    List<QuestionsModel>? questions,
    QuestionsModel? currentQuestion
  }) {
    return QuizExamState(
      questionIndex: questionIndex ?? this.questionIndex,
      questions: questions ?? this.questions,
      currentQuestion: currentQuestion ?? this.currentQuestion
    );
  }
}