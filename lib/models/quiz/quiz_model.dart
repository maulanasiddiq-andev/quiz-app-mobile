import 'dart:io';
import 'package:quiz_app/models/base_model.dart';
import 'package:quiz_app/models/identity/simple_user_model.dart';
import 'package:quiz_app/models/quiz/category_model.dart';
import 'package:quiz_app/models/quiz/questions_model.dart';
import 'package:quiz_app/services/file_service.dart';

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
  // for updating the image
  final File? newImage;

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
    required this.isTakenByUser,
    this.newImage
  });

  QuizModel copyWith({
    String? description,
    String? recordStatus,
    int? version,
    String? createdBy,
    DateTime? createdTime,
    String? modifiedBy,
    DateTime? modifiedTime,
    String? quizId,
    String? userId,
    SimpleUserModel? user,
    String? categoryId,
    CategoryModel? category,
    String? title,
    String? imageUrl,
    int? time,
    int? historiesCount,
    int? questionCount,
    List<QuestionModel>? questions,
    bool? isTakenByUser,
    File? newImage
  }) {
    return QuizModel(
      description: description ?? this.description,
      recordStatus: recordStatus ?? this.recordStatus,
      version: version ?? this.version,
      createdBy: createdBy ?? this.createdBy,
      createdTime: createdTime ?? this.createdTime,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedTime: modifiedTime ?? this.modifiedTime,
      quizId: quizId ?? this.quizId,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      time: time ?? this.time,
      historiesCount: historiesCount ?? this.historiesCount,
      questionCount: questionCount ?? this.questionCount,
      questions: questions ?? this.questions,
      isTakenByUser: isTakenByUser ?? this.isTakenByUser,
      newImage: newImage ?? this.newImage
    );
  }

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
    // just for updating
    newImage = null,
    super.fromJson(json);

  Future<Map<String, dynamic>> toJsonAsync() async {
    String? newImageUrl;

    // if there is new image, upload first
    if (newImage != null) {
      newImageUrl = await FileService.uploadImage("quiz", newImage!);
    }
    
    final data = <String, dynamic>{};
    data.addAll(super.toJson());
    data['quizId'] = quizId;
    data['userId'] = userId;
    data['categoryId'] = categoryId;
    data['title'] = title;
    data['imageUrl'] = newImageUrl ?? imageUrl;
    data['time'] = time;
    data['questions'] = await Future.wait(questions.map((q) => q.toJsonAsync()));
    data['historiesCount'] = historiesCount;
    data['questionCount'] = questionCount;
    data['isTakenByUser'] = isTakenByUser;
    return data;
  }
}
