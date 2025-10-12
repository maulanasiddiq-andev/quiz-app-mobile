import 'package:quiz_app/models/quiz_exam/answer_exam_model.dart';

class QuestionExamModel {
  final String text;
  final int questionOrder;
  String? imageUrl;
  final List<AnswerExamModel> answers;
  int? selectedAnswerOrder;
  bool isAnswerTrue;

  QuestionExamModel({
    required this.questionOrder,
    required this.text,
    this.imageUrl,
    required this.answers,
    this.selectedAnswerOrder,
    this.isAnswerTrue = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionOrder': questionOrder,
      'selectedAnswerOrder': selectedAnswerOrder,
    };
  }
}
