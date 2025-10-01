import 'package:quiz_app/models/quiz_create/answer_create_model.dart';

class QuestionCreateModel {
  String text;
  List<AnswerCreateModel> answers;

  QuestionCreateModel({
    this.text = "",
    this.answers = const []
  });

  QuestionCreateModel copyWith({
    String? text,
    List<AnswerCreateModel>? answers
  }) {
    return QuestionCreateModel(
      text: text ?? this.text,
      answers: answers ?? this.answers
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "answers": answers.map((answer) => answer.toJson()).toList()
    };
  }
}