import 'package:quiz_app/models/base_model.dart';
import 'package:quiz_app/models/identity/user_model.dart';
import 'package:quiz_app/models/quiz_history/question_history_model.dart';

class QuizHistoryModel extends BaseModel {
  final String quizHistoryId;
  final String quizId;
  final int quizVersion;
  final String userId;
  final UserModel user;
  final List<QuestionHistoryModel> questions;
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
    required this.score
  }); 

  QuizHistoryModel.fromJson(Map<String, dynamic> json) :
    quizHistoryId = json['quizHistoryId'],
    quizId = json['quizId'],
    quizVersion = json['quizVersion'],
    userId = json['userId'],
    user = UserModel.fromJson(json['user']),
    questions = (json['questions'] as List)
      .map((question) => QuestionHistoryModel.fromJson(question))
      .toList(),
    questionCount = json['questionCount'],
    duration = json['duration'],
    trueAnswers = json['trueAnswers'],
    wrongAnswers = json['wrongAnswers'],
    score = json['score'],
    super.fromJson(json);
}