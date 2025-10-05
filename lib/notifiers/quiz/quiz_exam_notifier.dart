import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/quiz_exam/answer_exam_model.dart';
import 'package:quiz_app/models/quiz_exam/question_exam_model.dart';
import 'package:quiz_app/models/quiz_exam/quiz_exam_model.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/states/quiz/quiz_exam_state.dart';

class QuizExamNotifier extends StateNotifier<QuizExamState> {
  QuizExamNotifier() : super(QuizExamState());

  void assignQuestions(QuizModel quiz) {
    List<QuestionExamModel> questionExams = [];

    for (var question in quiz.questions) {
      final questionExam = QuestionExamModel(
        questionOrder: question.questionOrder,
        text: question.text, 
        answers: []
      );

      for (var answer in question.answers) {
        final answerExam = AnswerExamModel(
          answerOrder: answer.answerOrder,
          text: answer.text,
          imageUrl: answer.imageUrl,
          isTrueAnswer: answer.isTrueAnswer
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
  }

  void toNextQuestion() {
    if (state.questionIndex < state.questions.length - 1) {
      var index = state.questionIndex + 1;

      state = state.copyWith(
        questionIndex: index,
      );
    }
  }

  void toPreviousQuestion() {
    if (state.questionIndex > 0) {
      var index = state.questionIndex - 1;

      state = state.copyWith(
        questionIndex: index,
      );
    }
  }

  Future<void> finishQuiz(int duration) async {
    state = state.copyWith(isLoading: true);

    try {
      var quizExam = QuizExamModel(
        quizVersion: state.quiz!.version,
        questions: [], 
        questionCount: state.questions.length, 
        duration: duration,
        trueAnswers: 0, 
        wrongAnswers: 0, 
        score: 0
      );

      for (var question in state.questions) {
        var trueAnswer = question.answers.firstWhere((answer) => answer.isTrueAnswer == true);

        if (question.selectedAnswerOrder == trueAnswer.answerOrder) {
          question.isAnswerTrue = true;
          quizExam.trueAnswers += 1;
        } else {
          question.isAnswerTrue = false;
          quizExam.wrongAnswers += 1;
        }

        quizExam.questions.add(question);
      }

      quizExam.score = (quizExam.trueAnswers / quizExam.questionCount * 100).round();

      await QuizService.takeQuiz(state.quiz!.quizId, quizExam);

      state = state.copyWith(
        isLoading: false,
        quizExam: quizExam,
        isDone: true, 
        questionIndex: 0
      );
    }  on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
    }
  }

  confirmToLeave() {
    state = state.copyWith(isConfirmedToLeave: true);
  }
}

final quizExamProvider = StateNotifierProvider.autoDispose<QuizExamNotifier, QuizExamState>((ref) => QuizExamNotifier());
