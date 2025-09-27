import 'package:flutter_riverpod/legacy.dart';
import 'package:quiz_app/models/quiz/questions_model.dart';
import 'package:quiz_app/states/quiz/quiz_exam_state.dart';

class QuizExamNotifier extends StateNotifier<QuizExamState> {
  QuizExamNotifier() : super(QuizExamState());

  void assignQuestions(List<QuestionModel> questions) {
    state = state.copyWith(
      questionIndex: 0,
      questions: [...questions],
      currentQuestion: questions[0],
    );
  }

  void toNextQuestion() {
    if (state.questionIndex < state.questions.length - 1) {
      var index = state.questionIndex + 1;

      state = state.copyWith(
        questionIndex: index,
        currentQuestion: state.questions[index],
      );
    }
  }

  void toPreviousQuestion() {
    if (state.questionIndex > 0) {
      var index = state.questionIndex - 1;

      state = state.copyWith(
        questionIndex: index,
        currentQuestion: state.questions[index],
      );
    }
  }
}

final quizExamProvider = StateNotifierProvider<QuizExamNotifier, QuizExamState>(
  (ref) => QuizExamNotifier(),
);
