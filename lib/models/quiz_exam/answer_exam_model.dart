class AnswerExamModel {
  final String answerId;
  final String questionId;
  final int answerOrder;
  String? text;
  String? imageUrl;
  final bool isTrueAnswer;

  AnswerExamModel({
    required this.answerId,
    required this.questionId,
    required this.answerOrder,
    required this.isTrueAnswer,
    this.text,
    this.imageUrl
  });
}