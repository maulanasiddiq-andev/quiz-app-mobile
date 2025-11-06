import 'package:quiz_app/models/base_model.dart';
import 'package:quiz_app/models/identity/simple_user_model.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/quiz_history/question_history_model.dart';

class QuizHistoryModel extends BaseModel {
  final String quizHistoryId;
  final String quizId;
  final int quizVersion;
  final String userId;
  final SimpleUserModel? user;
  final List<QuestionHistoryModel> questions;
  final QuizModel? quiz;
  final int questionCount;
  final int duration;
  final int trueAnswers;
  final int wrongAnswers;
  final int score;

  QuizHistoryModel({
    required super.createdBy,
    required super.createdTime,
    required super.modifiedBy,
    required super.modifiedTime,
    required super.description,
    required super.recordStatus,
    required super.version,
    required this.quizHistoryId,
    required this.quizId,
    required this.quizVersion,
    required this.userId,
    required this.user,
    required this.questions,
    required this.questionCount,
    required this.duration,
    required this.trueAnswers,
    required this.wrongAnswers,
    required this.score,
    this.quiz
  });

  QuizHistoryModel.fromJson(Map<String, dynamic> json)
    : quizHistoryId = json['quizHistoryId'],
      quizId = json['quizId'],
      quizVersion = json['quizVersion'],
      userId = json['userId'],
      user = json['user'] != null
          ? SimpleUserModel.fromJson(json['user'])
          : null,
      questions = (json['questions'] as List)
          .map((question) => QuestionHistoryModel.fromJson(question))
          .toList(),
      questionCount = json['questionCount'],
      duration = json['duration'],
      trueAnswers = json['trueAnswers'],
      wrongAnswers = json['wrongAnswers'],
      score = json['score'],
      quiz = json['quiz'] != null ? QuizModel.fromJson(json['quiz']) : null,
      super.fromJson(json);
}
