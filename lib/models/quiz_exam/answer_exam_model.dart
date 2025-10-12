class AnswerExamModel {
  final int answerOrder;
  String? text;
  String? imageUrl;

  AnswerExamModel({
    required this.answerOrder,
    this.text,
    this.imageUrl
  });

  Map<String, dynamic> toJson() {
    return {
      'answerOrder': answerOrder,
      'text': text,
      'imageUrl': imageUrl,
    };
  }
}