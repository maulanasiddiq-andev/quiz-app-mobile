import 'package:quiz_app/models/quiz_create/question_create_model.dart';

class QuizCreateState {
  final String title;
  final String description;
  final int time;
  final int questionIndex;
  final List<QuestionCreateModel> questions;

  QuizCreateState({
    this.title = "",
    this.description = "",
    this.time = 0,
    this.questionIndex = 0,
    this.questions = const []
  });

  QuizCreateState copyWith({
    String? title,
    String? description,
    int? time,
    int? questionIndex,
    List<QuestionCreateModel>? questions
  }) {
    return QuizCreateState(
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      questionIndex: questionIndex ?? this.questionIndex,
      questions: questions ?? this.questions
    );
  }
}