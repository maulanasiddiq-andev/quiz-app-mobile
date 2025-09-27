import 'package:quiz_app/models/quiz/quiz_model.dart';

class QuizDetailState {
  final bool isLoading;
  final QuizModel? quiz;

  QuizDetailState({
    this.isLoading = false,
    this.quiz
  });

  QuizDetailState copyWith({
    bool? isLoading = false,
    QuizModel? quiz
  }) {
    return QuizDetailState(
      isLoading: isLoading ?? this.isLoading, 
      quiz: quiz ?? this.quiz
    );
  }
}