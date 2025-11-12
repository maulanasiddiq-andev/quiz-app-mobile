import 'package:quiz_app/models/base_model.dart';

class AnswerModel extends BaseModel {
  final String answerId;
  final String questionId;
  final int answerOrder;
  final String? text;
  final String? imageUrl;
  final bool isTrueAnswer;

  AnswerModel({
    required super.description,
    required super.recordStatus,
    required super.version,
    required super.createdBy,
    required super.createdTime,
    required super.modifiedBy,
    required super.modifiedTime,
    required this.answerId,
    required this.questionId,
    required this.answerOrder,
    this.text,
    this.imageUrl,
    required this.isTrueAnswer,
  });

  AnswerModel.fromJson(Map<String, dynamic> json) :
    answerId = json['answerId'],
    questionId = json['questionId'],
    answerOrder = json['answerOrder'],
    text = json['text'],
    imageUrl = json['imageUrl'],
    isTrueAnswer = json['isTrueAnswer'],
    super.fromJson(json);

  AnswerModel copyWith({
    String? answerId,
    String? questionId,
    int? answerOrder,
    String? text,
    String? imageUrl,
    bool? isTrueAnswer,
    // parent properties
    String? description,
    String? recordStatus,
    int? version,
    String? createdBy,
    DateTime? createdTime,
    String? modifiedBy,
    DateTime? modifiedTime,
  }) {
    return AnswerModel(
      description: description ?? this.description,
      recordStatus: recordStatus ?? this.recordStatus,
      version: version ?? this.version,
      createdBy: createdBy ?? this.createdBy,
      createdTime: createdTime ?? this.createdTime,
      modifiedBy: modifiedBy ?? this.modifiedBy,
      modifiedTime: modifiedTime ?? this.modifiedTime,
      answerId: answerId ?? this.answerId,
      questionId: questionId ?? this.questionId,
      answerOrder: answerOrder ?? this.answerOrder,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      isTrueAnswer: isTrueAnswer ?? this.isTrueAnswer
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map.addAll(super.toJson());
    map.addAll({
      'answerId': answerId,
      'questionId': questionId,
      'answerOrder': answerOrder,
      'text': text,
      'imageUrl': imageUrl,
      'isTrueAnswer': isTrueAnswer,
    });
    return map;
  }
}