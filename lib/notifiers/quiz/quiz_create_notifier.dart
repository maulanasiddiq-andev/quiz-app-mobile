import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz_create/answer_create_model.dart';
import 'package:quiz_app/models/quiz_create/question_create_model.dart';
import 'package:quiz_app/services/category_service.dart';
import 'package:quiz_app/services/quiz_service.dart';
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

    getCategories();
  }

  Future<void> getCategories() async {
    state = state.copyWith(isLoadingCategories: true);

    try {
      var result = await CategoryService.getQuizzes(0, 10);

      if (result.data != null) {
        state = state.copyWith(isLoadingCategories: false, categories: result.data!.items);
      }

      state = state.copyWith(isLoadingCategories: false);
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoadingCategories: false);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoadingCategories: false);
    }
  }

  void createDescription(String categoryId, String title, String description, int time) {
    state = state.copyWith(
      categoryId: categoryId,
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

  void deleteAnswer(int answerIndex) {
    var currentQuestion = state.questions[state.questionIndex];
    var questions = [...state.questions];

    var answers = [...currentQuestion.answers];
    answers.removeAt(answerIndex);

    currentQuestion = currentQuestion.copyWith(answers: answers);

    if (currentQuestion.trueAnswerIndex == answerIndex) {
      currentQuestion = currentQuestion.copyWith(trueAnswerIndex: null);
    }

    questions[state.questionIndex] = currentQuestion;
    state = state.copyWith(questions: questions);
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

  void determineTrueAnswer(int? answerIndex) {
    int index = state.questionIndex;
    var questions = [...state.questions];
    var currentQuestion = questions[index];

    var answers = [...currentQuestion.answers];

    for (var i = 0; i < answers.length; i++) {
      answers[i] = answers[i].copyWith(isTrueAnswer: false);
    }

    if (answerIndex != null) {
      answers[answerIndex] = answers[answerIndex].copyWith(isTrueAnswer: true);
    }

    questions[index] = currentQuestion.copyWith(answers: answers, trueAnswerIndex: answerIndex);
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

  void deleteQuestion() {
    var questions = [...state.questions];

    int removedIndex = state.questionIndex;
    // if the current question index is the last question and the last question is removed
    if (state.questionIndex == questions.length - 1) {
      state = state.copyWith(questionIndex: state.questionIndex - 1);
    }

    questions.removeAt(removedIndex);
    state = state.copyWith(
      questions: questions
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

  Future<bool> createQuiz() async {
    state = state.copyWith(isLoadingCreate: true);

    try {
      Map<String, dynamic> quiz = {
        "categoryId": state.categoryId,
        "title": state.title,
        "description": state.description,
        "time": state.time,
        "questions": state.questions.map((question) => question.toJson()).toList()
      };

      var result = await QuizService.createQuiz(quiz);

      state = state.copyWith(isLoadingCreate: false);
      Fluttertoast.showToast(msg: result.messages[0]);

      return true;
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoadingCreate: false);

      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoadingCreate: false);

      return false;
    }
  }
}

final quizCreateProvider = StateNotifierProvider.autoDispose((ref) => QuizCreateNotifier());