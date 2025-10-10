import 'dart:io';
import 'package:quiz_app/models/quiz_create/answer_create_model.dart';
import 'package:quiz_app/services/quiz_service.dart';

class QuestionCreateModel {
  final String text;
  final File? image;
  final int? trueAnswerIndex;
  final List<AnswerCreateModel> answers;

  QuestionCreateModel({
    this.text = "",
    this.trueAnswerIndex,
    this.answers = const [],
    this.image
  });

  QuestionCreateModel copyWith({
    String? text,
    int? trueAnswerIndex,
    File? image,
    List<AnswerCreateModel>? answers
  }) {
    return QuestionCreateModel(
      text: text ?? this.text,
      trueAnswerIndex: trueAnswerIndex ?? this.trueAnswerIndex,
      answers: answers ?? this.answers,
      image: image ?? this.image
    );
  }

  Future<Map<String, dynamic>> toJson() async {
    return {
      "text": text,
      "imageUrl": image != null ? await QuizService.uploadQuizImage("question", image!) : null,
      "answers": answers.map((answer) => answer.toJson()).toList()
    };
  }
}