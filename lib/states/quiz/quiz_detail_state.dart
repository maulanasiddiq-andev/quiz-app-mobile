import 'package:quiz_app/models/quiz/quiz_model.dart';

class QuizDetailState {
  final bool isLoading;
  final QuizModel? quiz;
  final bool isLoadingDelete;

  QuizDetailState({
    this.isLoading = false,
    this.quiz,
    this.isLoadingDelete = false
  });

  QuizDetailState copyWith({
    bool? isLoading,
    QuizModel? quiz,
    bool? isLoadingDelete
  }) {
    return QuizDetailState(
      isLoading: isLoading ?? this.isLoading, 
      quiz: quiz ?? this.quiz,
      isLoadingDelete: isLoadingDelete ?? this.isLoadingDelete
    );
  }
}