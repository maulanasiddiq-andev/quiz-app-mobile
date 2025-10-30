import 'package:quiz_app/models/take_quiz/take_answer_model.dart';

class TakeQuestionModel {
  final String text;
  final int questionOrder;
  String? imageUrl;
  final List<TakeAnswerModel> answers;
  int? selectedAnswerOrder;
  bool isAnswerTrue;

  TakeQuestionModel({
    required this.questionOrder,
    required this.text,
    this.imageUrl,
    required this.answers,
    this.selectedAnswerOrder,
    this.isAnswerTrue = true,
  });

  factory TakeQuestionModel.fromJson(Map<String, dynamic> json) =>
      TakeQuestionModel(
        questionOrder: json['questionOrder'],
        text: json['text'],
        answers: (json['answers'] as List)
            .map((answer) => TakeAnswerModel.fromJson(answer))
            .toList(),
        imageUrl: json['imageUrl'],
      );

  Map<String, dynamic> toJson() {
    return {
      'questionOrder': questionOrder,
      'selectedAnswerOrder': selectedAnswerOrder,
    };
  }
}
