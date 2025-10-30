import 'package:quiz_app/models/quiz_exam/question_exam_model.dart';

class QuizExamModel {
  final String quizId;
  final String title;
  final String? imageUrl;
  final int time;
  final int questionCount;
  final int version;
  final List<QuestionExamModel> questions;

  QuizExamModel({
    required this.quizId,
    required this.title,
    this.imageUrl,
    required this.time,
    required this.questionCount,
    required this.version,
    required this.questions
  });

  factory QuizExamModel.fromJson(Map<String, dynamic> json) => QuizExamModel(
    quizId: json['quizId'], 
    title: json['title'], 
    time: json['time'], 
    questionCount: json['questionCount'], 
    version: json['version'],
    imageUrl: json['imageUrl'],
    questions: (json['questions'] as List).map((data) => QuestionExamModel.fromJson(data)).toList()
  );
}