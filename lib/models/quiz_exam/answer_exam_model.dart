class AnswerExamModel {
  final int answerOrder;
  String? text;
  String? imageUrl;
  final bool isTrueAnswer;

  AnswerExamModel({
    required this.answerOrder,
    required this.isTrueAnswer,
    this.text,
    this.imageUrl
  });

  Map<String, dynamic> toJson() {
    return {
      'answerOrder': answerOrder,
      'text': text,
      'imageUrl': imageUrl,
      'isTrueAnswer': isTrueAnswer
    };
  }
}