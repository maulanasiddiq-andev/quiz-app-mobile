import 'package:quiz_app/models/quiz/questions_model.dart';

class QuizExamState {
  final int questionIndex;
  final List<QuestionModel> questions;
  final QuestionModel? currentQuestion;

  QuizExamState({
    this.questionIndex = 0,
    this.questions = const [],
    this.currentQuestion,
  });

  QuizExamState copyWith({
    int? questionIndex,
    List<QuestionModel>? questions,
    QuestionModel? currentQuestion,
  }) {
    return QuizExamState(
      questionIndex: questionIndex ?? this.questionIndex,
      questions: questions ?? this.questions,
      currentQuestion: currentQuestion ?? this.currentQuestion,
    );
  }
}
