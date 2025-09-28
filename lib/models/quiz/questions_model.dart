import 'package:quiz_app/models/base_model.dart';
import 'package:quiz_app/models/quiz/answer_model.dart';

class QuestionModel extends BaseModel {
  final String questionId;
  final String quizId;
  final int questionOrder;
  final String text;
  String? imageUrl;
  final List<AnswerModel> answers;

  QuestionModel({
    required super.version,
    required super.recordStatus,
    required super.description,
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
  });

  QuestionModel.fromJson(Map<String, dynamic> json) : 
    questionId = json['questionId'],
    quizId = json['quizId'],
    questionOrder = json['questionOrder'],
    text = json['text'],
    imageUrl = json['imageUrl'],
    answers = (json['answers'] as List).map((data) => AnswerModel.fromJson(data)).toList(),
    super.fromJson(json);
}
