import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/quiz_exam/answer_exam_model.dart';
import 'package:quiz_app/models/quiz_exam/question_exam_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/states/quiz/take_quiz_state.dart';

class TakeQuizNotifier extends StateNotifier<TakeQuizState> {
  TakeQuizNotifier() : super(TakeQuizState());

  Future<bool> assignQuestions(QuizModel quiz) async {
    state = state.copyWith(isLoading: true);
    List<QuestionExamModel> questionExams = [];

    try {
      BaseResponse<QuizModel> result =
          await QuizService.getQuizByIdWithQuestions(quiz.quizId);

      for (var question in result.data!.questions) {
        final questionExam = QuestionExamModel(
          questionOrder: question.questionOrder,
          text: question.text,
          imageUrl: question.imageUrl,
          answers: [],
        );

        for (var answer in question.answers) {
          final answerExam = AnswerExamModel(
            answerOrder: answer.answerOrder,
            text: answer.text,
            imageUrl: answer.imageUrl,
          );

          questionExam.answers.add(answerExam);
        }

        questionExams.add(questionExam);
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
      Fluttertoast.showToast(msg: e.toString());
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
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  confirmToLeave() {
    state = state.copyWith(isConfirmedToLeave: true);
  }
}

final quizExamProvider =
    StateNotifierProvider.autoDispose<TakeQuizNotifier, TakeQuizState>(
      (ref) => TakeQuizNotifier(),
    );
