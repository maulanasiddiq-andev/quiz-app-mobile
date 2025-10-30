class TakeAnswerModel {
  final int answerOrder;
  String? text;
  String? imageUrl;

  TakeAnswerModel({required this.answerOrder, this.text, this.imageUrl});

  factory TakeAnswerModel.fromJson(Map<String, dynamic> json) =>
      TakeAnswerModel(
        answerOrder: json['answerOrder'],
        text: json['text'],
        imageUrl: json['imageUrl'],
      );
}
