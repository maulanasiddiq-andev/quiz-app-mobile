import 'package:quiz_app/models/quiz_exam/question_exam_model.dart';

class QuizExamModel {
  final String quizExamId;
  final String quizId;
  final List<QuestionExamModel> questions;
  final int questionCount;
  int trueAnswers;
  int wrongAnswers;
  int score;

  QuizExamModel({
    required this.quizExamId,
    required this.quizId,
    required this.questions,
    required this.questionCount,
    required this.trueAnswers,
    required this.wrongAnswers,
    required this.score
  });
}