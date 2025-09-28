import 'package:flutter_riverpod/legacy.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/quiz_exam/answer_exam_model.dart';
import 'package:quiz_app/models/quiz_exam/question_exam_model.dart';
import 'package:quiz_app/models/quiz_exam/quiz_exam_model.dart';
import 'package:quiz_app/states/quiz/quiz_exam_state.dart';

class QuizExamNotifier extends StateNotifier<QuizExamState> {
  QuizExamNotifier() : super(QuizExamState());

  void assignQuestions(QuizModel quiz) {
    List<QuestionExamModel> questionExams = [];

    for (var question in quiz.questions) {
      final questionExam = QuestionExamModel(
        questionId: question.questionId, 
        questionOrder: question.questionOrder,
        text: question.text, 
        answers: []
      );

      for (var answer in question.answers) {
        final answerExam = AnswerExamModel(
          answerId: answer.answerId, 
          questionId: answer.questionId, 
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
      currentQuestion: questionExams[0],
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

  void finishQuiz(int duration) {
    var quizExam = QuizExamModel(
      quizExamId: '', 
      quizId: state.quiz!.quizId, 
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

    state = state.copyWith(
      quizExam: quizExam,
      isDone: true, 
      questionIndex: 0
    );
  }
}

final quizExamProvider = StateNotifierProvider.autoDispose<QuizExamNotifier, QuizExamState>((ref) => QuizExamNotifier());
