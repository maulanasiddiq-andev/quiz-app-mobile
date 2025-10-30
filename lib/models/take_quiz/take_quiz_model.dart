import 'package:quiz_app/models/take_quiz/take_question_model.dart';

class TakeQuizModel {
  final String quizId;
  final String title;
  final String? imageUrl;
  final int time;
  final int questionCount;
  final int version;
  final List<TakeQuestionModel> questions;

  TakeQuizModel({
    required this.quizId,
    required this.title,
    this.imageUrl,
    required this.time,
    required this.questionCount,
    required this.version,
    required this.questions,
  });

  factory TakeQuizModel.fromJson(Map<String, dynamic> json) => TakeQuizModel(
    quizId: json['quizId'],
    title: json['title'],
    time: json['time'],
    questionCount: json['questionCount'],
    version: json['version'],
    imageUrl: json['imageUrl'],
    questions: (json['questions'] as List)
        .map((data) => TakeQuestionModel.fromJson(data))
        .toList(),
  );
}
