import 'package:quiz_app/models/base_model.dart';

class AnswerModel extends BaseModel {
  final String answerId;
  final String questionId;
  final int answerOrder;
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
    required this.answerOrder,
    required this.isTrueAnswer,
    this.text,
    this.imageUrl
  });

  AnswerModel.fromJson(Map<String, dynamic> json) :
    answerId = json['answerId'],
    questionId = json['questionId'],
    answerOrder = json['answerOrder'],
    text = json['text'],
    imageUrl = json['imageUrl'],
    isTrueAnswer = json['isTrueAnswer'],
    super.fromJson(json);
}