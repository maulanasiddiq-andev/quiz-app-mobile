class AnswerModel {
  final String answerId;
  final String questionId;
  final int answerOrder;
  String? text;
  String? imageUrl;

  AnswerModel({
    required this.answerId,
    required this.questionId,
    required this.answerOrder,
    this.text,
    this.imageUrl
  });

  AnswerModel.fromJson(Map<String, dynamic> json) :
    answerId = json['answerId'],
    questionId = json['questionId'],
    answerOrder = json['answerOrder'],
    text = json['text'],
    imageUrl = json['imageUrl'];
}