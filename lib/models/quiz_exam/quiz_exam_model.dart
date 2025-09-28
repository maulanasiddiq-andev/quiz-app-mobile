import 'package:quiz_app/models/quiz_exam/question_exam_model.dart';

class QuizExamModel {
  final int quizVersion;
  final List<QuestionExamModel> questions;
  final int questionCount;
  final int duration;
  int trueAnswers;
  int wrongAnswers;
  int score;

  QuizExamModel({
    required this.quizVersion,
    required this.questions,
    required this.questionCount,
    required this.duration,
    required this.trueAnswers,
    required this.wrongAnswers,
    required this.score
  });
}