import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/quiz_exam/question_exam_model.dart';
import 'package:quiz_app/models/quiz_exam/quiz_exam_model.dart';

class QuizExamState {
  final QuizModel? quiz;
  final QuizExamModel? quizExam;
  final bool isDone;
  final int questionIndex;
  final List<QuestionExamModel> questions;
  final QuestionExamModel? currentQuestion;

  QuizExamState({
    this.quiz,
    this.quizExam,
    this.isDone = false,
    this.questionIndex = 0,
    this.questions = const [],
    this.currentQuestion,
  });

  QuizExamState copyWith({
    QuizModel? quiz,
    QuizExamModel? quizExam,
    bool? isDone,
    int? questionIndex,
    List<QuestionExamModel>? questions,
    QuestionExamModel? currentQuestion,
  }) {
    return QuizExamState(
      quiz: quiz ?? this.quiz,
      quizExam: quizExam ?? this.quizExam,
      isDone: isDone ?? this.isDone,
      questionIndex: questionIndex ?? this.questionIndex,
      questions: questions ?? this.questions,
      currentQuestion: currentQuestion ?? this.currentQuestion,
    );
  }
}
