import 'package:flutter_riverpod/legacy.dart';
import 'package:quiz_app/models/quiz_create/answer_create_model.dart';
import 'package:quiz_app/models/quiz_create/question_create_model.dart';
import 'package:quiz_app/states/quiz/quiz_create_state.dart';

class QuizCreateNotifier extends StateNotifier<QuizCreateState> {
  QuizCreateNotifier() : super(QuizCreateState()) {
    var question = QuestionCreateModel();
    question = question.copyWith(
      answers: [...question.answers, AnswerCreateModel()]
    );

    state = state.copyWith(
      questions: [...state.questions, question],
    );
  }

  void createDescription(String title, String description, int time) {
    state = state.copyWith(
      title: title,
      description: description,
      time: time
    );
  }

  void addAnswer() {
    var answer = AnswerCreateModel();

    var currentQuestion = state.questions[state.questionIndex];
    var questions = [...state.questions];

    currentQuestion = currentQuestion.copyWith(
      answers: [...currentQuestion.answers, answer]
    );

    questions[state.questionIndex] = currentQuestion;
    state = state.copyWith(
      questions: questions
    );
  }

  void updateAnswer(int answerIndex, String text) {
    int index = state.questionIndex;
    var questions = [...state.questions];
    var currentQuestion = questions[index];

    var answers = [...currentQuestion.answers];
    answers[answerIndex] = answers[answerIndex].copyWith(text: text);

    questions[index] = currentQuestion.copyWith(answers: answers);
    state = state.copyWith(questions: questions);
  }

  void addQuestion() {
    var question = QuestionCreateModel();
    question = question.copyWith(answers: [AnswerCreateModel()]);

    state = state.copyWith(
      questions: [...state.questions, question],
      questionIndex: state.questionIndex + 1
    );
  }

  void updateQuestion(String text) {
    int index = state.questionIndex;
    var questions = [...state.questions];
    var currentQuestion = questions[index];

    questions[index] = currentQuestion.copyWith(text: text);

    state = state.copyWith(questions: questions);
  }

  void toNextQuestion() {
    if (state.questionIndex < state.questions.length - 1) {
      var index = state.questionIndex + 1;

      state = state.copyWith(
        questionIndex: index,
      );
    } else {
      addQuestion();
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
}

final quizCreateProvider = StateNotifierProvider.autoDispose((ref) => QuizCreateNotifier());