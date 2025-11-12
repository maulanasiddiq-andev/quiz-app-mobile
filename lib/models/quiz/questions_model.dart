import 'dart:io';
import 'package:quiz_app/models/base_model.dart';
import 'package:quiz_app/models/quiz/answer_model.dart';
import 'package:quiz_app/services/file_service.dart';

class QuestionModel extends BaseModel {
  final String questionId;
  final String quizId;
  final int questionOrder;
  final String text;
  final String? imageUrl;
  final List<AnswerModel> answers;
  // for updating
  final int? trueAnswerIndex;
  final File? newImage;

  QuestionModel({
    required super.description,
    required super.recordStatus,
    required super.version,
    required super.createdBy,
    required super.createdTime,
    required super.modifiedBy,
    required super.modifiedTime,
    required this.questionId,
    required this.quizId,
    required this.questionOrder,
    required this.text,
    this.imageUrl,
    required this.answers,
    this.trueAnswerIndex,
    this.newImage
  });

  QuestionModel.fromJson(Map<String, dynamic> json) : 
    questionId = json['questionId'],
    quizId = json['quizId'],
    questionOrder = json['questionOrder'],
    text = json['text'],
    imageUrl = json['imageUrl'],
    answers = (json['answers'] as List).map((data) => AnswerModel.fromJson(data)).toList(),
    // for editing
    trueAnswerIndex = null,
    newImage = null,
    super.fromJson(json);

  QuestionModel copyWith({
    String? description,
    String? recordStatus,
    int? version,
    String? createdBy,
    DateTime? createdTime,
    String? modifiedBy,
    DateTime? modifiedTime,
    String? questionId,
    String? quizId,
    int? questionOrder,
    String? text,
    String? imageUrl,
    List<AnswerModel>? answers,
    int? trueAnswerIndex,
    File? newImage,
  }) {
    return QuestionModel(
      description: description ?? this.description,
      recordStatus: recordStatus ?? this.recordStatus,
      version: version ?? this.version,
      createdBy: createdBy ?? this.createdBy,
      createdTime: createdTime ?? this.createdTime,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedTime: modifiedTime ?? this.modifiedTime,
      questionId: questionId ?? this.questionId,
      quizId: quizId ?? this.quizId,
      questionOrder: questionOrder ?? this.questionOrder,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      answers: answers ?? this.answers,
      trueAnswerIndex: trueAnswerIndex ?? this.trueAnswerIndex,
      newImage: newImage ?? this.newImage,
    );
  }

  Future<Map<String, dynamic>> toJsonAsync() async {
    String? newImageUrl;

    // if there is new image, upload first
    if (newImage != null) {
      newImageUrl = await FileService.uploadImage("question", newImage!);
    }

    final map = <String, dynamic>{};
    map.addAll(super.toJson());
    map.addAll({
      'questionId': questionId,
      'quizId': quizId,
      'questionOrder': questionOrder,
      'text': text,
      'imageUrl': newImageUrl ?? imageUrl,
      'answers': answers.map((a) => a.toJson()).toList(),
      'trueAnswerIndex': trueAnswerIndex,
    });
    return map;
  }
}
