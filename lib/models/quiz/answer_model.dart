import 'package:quiz_app/models/base_model.dart';

class AnswerModel extends BaseModel {
  final String answerId;
  final String questionId;
  String? text;
  String? imageUrl;
  final bool isTrueAnswer;

  AnswerModel({
    required super.version,
    required super.recordStatus,
    required super.description,
    required super.createdBy,
    required super.createdTime,
    required super.modifiedBy,
    required super.modifiedTime,
    required this.answerId,
    required this.questionId,
    required this.isTrueAnswer,
    this.text,
    this.imageUrl
  });

  AnswerModel.fromJson(Map<String, dynamic> json) :
    answerId = json['answerId'],
    questionId = json['questionId'],
    text = json['text'],
    imageUrl = json['imageUrl'],
    isTrueAnswer = json['isTrueAnswer'],
    super.fromJson(json);
}