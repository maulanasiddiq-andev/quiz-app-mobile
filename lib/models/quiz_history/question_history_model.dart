import 'package:quiz_app/models/quiz_history/answer_history_model.dart';

class QuestionHistoryModel {
  final String questionHistoryId;
  final String quizHistoryId;
  final String text;
  final int questionOrder;
  final String? imageUrl;
  final List<AnswerHistoryModel> answers;
  final int? selectedAnswerOrder;
  final bool isAnswerTrue;

  QuestionHistoryModel({
    required this.questionHistoryId,
    required this.quizHistoryId,
    required this.text,
    required this.questionOrder,
    this.imageUrl,
    required this.answers,
    required this.selectedAnswerOrder,
    required this.isAnswerTrue
  });

  QuestionHistoryModel.fromJson(Map<String, dynamic> json) :
    questionHistoryId = json['questionHistoryId'],
    quizHistoryId = json['quizHistoryId'],
    text = json['text'],
    questionOrder = json['questionOrder'],
    imageUrl = json['imageUrl'],
    answers = (json['answers'] as List)
      .map((answer) => AnswerHistoryModel.fromJson(answer))
      .toList(),
    selectedAnswerOrder = json['selectedAnswerOrder'],
    isAnswerTrue = json['isAnswerTrue'];
}