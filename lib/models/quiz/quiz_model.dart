import 'package:quiz_app/models/base_model.dart';
import 'package:quiz_app/models/identity/simple_user_model.dart';
import 'package:quiz_app/models/quiz/category_model.dart';
import 'package:quiz_app/models/quiz/questions_model.dart';

class QuizModel extends BaseModel {
  final String quizId;
  final String? userId;
  // the user is nullable
  // in quiz list page, the user is not shown
  final SimpleUserModel? user;
  final String? categoryId;
  final CategoryModel? category;
  final String title;
  final String? imageUrl;
  final int time;
  final int? historiesCount;
  final int questionCount;
  final List<QuestionModel> questions;
  final bool isTakenByUser;

  QuizModel({
    required super.description,
    required super.recordStatus,
    required super.version,
    required super.createdBy,
    required super.createdTime,
    required super.modifiedBy,
    required super.modifiedTime,
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
    required this.isTakenByUser
  });

  QuizModel.fromJson(Map<String, dynamic> json) : 
    quizId = json['quizId'],
    userId = json['userId'],
    user = json['user'] != null
        ? SimpleUserModel.fromJson(json['user'])
        : null,
    categoryId = json['categoryId'],
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null,
    title = json['title'],
    imageUrl = json['imageUrl'],
    time = json['time'],
    questions = (json['questions'] as List)
        .map((data) => QuestionModel.fromJson(data))
        .toList(),
    historiesCount = json['historiesCount'],
    questionCount = json['questionCount'],
    isTakenByUser = json['isTakenByUser'],
    super.fromJson(json);
}
