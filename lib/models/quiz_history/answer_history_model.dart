class AnswerHistoryModel {
  final String answerHistoryId;
  final String questionHistoryId;
  final int answerOrder;
  final String? text;
  final String? imageUrl;
  final bool isTrueAnswer;

  AnswerHistoryModel({
    required this.answerHistoryId,
    required this.questionHistoryId,
    required this.answerOrder,
    this.text,
    this.imageUrl,
    required this.isTrueAnswer
  });

  AnswerHistoryModel.fromJson(Map<String, dynamic> json) :
    answerHistoryId = json['answerHistoryId'],
    questionHistoryId = json['questionHistoryId'],
    answerOrder = json['answerOrder'],
    text = json['text'],
    imageUrl = json['imageUrl'],
    isTrueAnswer = json['isTrueAnswer'];
}