import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/select_data_model.dart';

class QuizEditState {
  final bool isLoading;
  final bool isLoadingUpdate;
  final QuizModel? quiz;
  final SelectDataModel? selectedCategory;
  final int questionIndex;

  const QuizEditState({
    this.isLoading = false,
    this.isLoadingUpdate = false,
    this.quiz,
    this.selectedCategory,
    this.questionIndex = 0
  });

  QuizEditState copyWith({
    bool? isLoading,
    bool? isLoadingUpdate,
    QuizModel? quiz,
    SelectDataModel? selectedCategory,
    int? questionIndex
  }) {
    return QuizEditState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingUpdate: isLoadingUpdate ?? this.isLoadingUpdate,
      quiz: quiz ?? this.quiz,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      questionIndex: questionIndex ?? this.questionIndex
    );
  }
}