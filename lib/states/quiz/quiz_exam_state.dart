import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/quiz_exam/question_exam_model.dart';
import 'package:quiz_app/models/quiz_exam/quiz_exam_model.dart';

class QuizExamState {
  final bool isLoading;
  final QuizModel? quiz;
  final QuizExamModel? quizExam;
  final bool isDone;
  final bool isConfirmedToLeave;
  final int questionIndex;
  final List<QuestionExamModel> questions;

  QuizExamState({
    this.isLoading = false,
    this.quiz,
    this.quizExam,
    this.isDone = false,
    this.isConfirmedToLeave = false,
    this.questionIndex = 0,
    this.questions = const [],
  });

  QuizExamState copyWith({
    bool? isLoading,
    QuizModel? quiz,
    QuizExamModel? quizExam,
    bool? isDone,
    bool? isConfirmedToLeave,
    int? questionIndex,
    List<QuestionExamModel>? questions,
  }) {
    return QuizExamState(
      isLoading: isLoading ?? this.isLoading,
      quiz: quiz ?? this.quiz,
      quizExam: quizExam ?? this.quizExam,
      isDone: isDone ?? this.isDone,
      isConfirmedToLeave: isConfirmedToLeave ?? this.isConfirmedToLeave,
      questionIndex: questionIndex ?? this.questionIndex,
      questions: questions ?? this.questions,
    );
  }
}
