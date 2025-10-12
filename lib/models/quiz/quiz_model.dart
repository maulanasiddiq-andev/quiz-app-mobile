import 'package:quiz_app/models/base_model.dart';
import 'package:quiz_app/models/identity/user_model.dart';
import 'package:quiz_app/models/quiz/category_model.dart';
import 'package:quiz_app/models/quiz/questions_model.dart';

class QuizModel extends BaseModel {
  final String quizId;
  final String userId;
  final UserModel user;
  final String categoryId;
  final CategoryModel category;
  final String title;
  String? imageUrl;
  final int time;
  final int historiesCount;
  final int questionCount;
  final List<QuestionModel> questions;

  QuizModel({
    required super.version,
    required super.description,
    required super.recordStatus,
    required super.createdTime,
    required super.createdBy,
    required super.modifiedTime,
    required super.modifiedBy,
    required this.quizId,
    required this.userId,
    required this.user,
    required this.categoryId,
    required this.category,
    required this.title,
    this.imageUrl,
    required this.time,
    required this.historiesCount,
    required this.questionCount,
    this.questions = const [],
  });

  QuizModel.fromJson(Map<String, dynamic> json)
    : quizId = json['quizId'],
      userId = json['userId'],
      user = UserModel.fromJson(json['user']),
      categoryId = json['categoryId'],
      category = CategoryModel.fromJson(json['category']),
      title = json['title'],
      imageUrl = json['imageUrl'],
      time = json['time'],
      questions = (json['questions'] as List)
          .map((data) => QuestionModel.fromJson(data))
          .toList(),
      historiesCount = json['historiesCount'],
      questionCount = json['questionCount'],
      super.fromJson(json);
}
