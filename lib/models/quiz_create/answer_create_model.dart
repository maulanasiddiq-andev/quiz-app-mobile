class AnswerCreateModel {
  String text;
  bool isTrueAnswer;

  AnswerCreateModel({
    this.text = "",
    this.isTrueAnswer = false
  });

  AnswerCreateModel copyWith({
    String? text,
    bool? isTrueAnswer
  }) {
    return AnswerCreateModel(
      text: text ?? this.text,
      isTrueAnswer: isTrueAnswer ?? this.isTrueAnswer
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "isTrueAnswer": isTrueAnswer
    };
  }
}