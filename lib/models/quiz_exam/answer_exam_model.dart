class AnswerExamModel {
  final int answerOrder;
  String? text;
  String? imageUrl;

  AnswerExamModel({
    required this.answerOrder,
    this.text,
    this.imageUrl
  });

  factory AnswerExamModel.fromJson(Map<String, dynamic> json) => AnswerExamModel(
    answerOrder: json['answerOrder'],
    text: json['text'],
    imageUrl: json['imageUrl'],
  );

  Map<String, dynamic> toJson() {
    return {
      'answerOrder': answerOrder,
      'text': text,
      'imageUrl': imageUrl,
    };
  }
}