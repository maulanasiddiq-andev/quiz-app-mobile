import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/take_quiz/take_question_model.dart';
import 'package:quiz_app/models/take_quiz/take_quiz_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/states/quiz/take_quiz_state.dart';

class TakeQuizNotifier extends StateNotifier<TakeQuizState> {
  TakeQuizNotifier() : super(TakeQuizState());

  Future<bool> getQuizWithQuestions(QuizModel quiz) async {
    state = state.copyWith(isLoading: true);
    List<TakeQuestionModel> questionExams = [];

    try {
      BaseResponse<TakeQuizModel> result =
          await QuizService.getQuizByIdWithQuestions(quiz.quizId);

      for (var question in result.data!.questions) {
        questionExams.add(question);
      }

      state = state.copyWith(
        quiz: quiz,
        questionIndex: 0,
        questions: [...questionExams],
      );

      state = state.copyWith(isLoading: false);
      return true;
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  void toNextQuestion() {
    if (state.questionIndex < state.questions.length - 1) {
      var index = state.questionIndex + 1;

      state = state.copyWith(questionIndex: index);
    }
  }

  void toPreviousQuestion() {
    if (state.questionIndex > 0) {
      var index = state.questionIndex - 1;

      state = state.copyWith(questionIndex: index);
    }
  }

  void goToQuestion(int index) {
    state = state.copyWith(questionIndex: index);
  }

  int countUnansweredQuestions() {
    final questions = [...state.questions];
    int unansweredQuestionCount = 0;

    for (var question in questions) {
      if (question.selectedAnswerOrder == null) {
        unansweredQuestionCount += 1;
      }
    }

    return unansweredQuestionCount;
  }

  Future<bool> finishQuiz(int duration) async {
    state = state.copyWith(isLoading: true);

    try {
      var quiz = {
        "quizVersion": state.quiz!.version,
        "questionCount": state.questions.length,
        "duration": duration,
        "questions": state.questions
            .map((question) => question.toJson())
            .toList(),
      };

      var result = await QuizService.checkQuiz(state.quiz!.quizId, quiz);

      state = state.copyWith(quizHistory: result.data);
      Fluttertoast.showToast(msg: result.messages[0]);

      state = state.copyWith(isLoading: false);
      return true;
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  confirmToLeave() {
    state = state.copyWith(isConfirmedToLeave: true);
  }
}

final takeQuizProvider =
    StateNotifierProvider.autoDispose<TakeQuizNotifier, TakeQuizState>(
      (ref) => TakeQuizNotifier(),
    );
