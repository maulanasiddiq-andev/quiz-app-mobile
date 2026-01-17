import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz/answer_model.dart';
import 'package:quiz_app/models/quiz/questions_model.dart';
import 'package:quiz_app/models/select_data_model.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/states/quiz_edit/quiz_edit_state.dart';
import 'package:quiz_app/utils/pick_image.dart';

class QuizEditNotifier extends StateNotifier<QuizEditState> {
  final String quizId;
  QuizEditNotifier(this.quizId): super(QuizEditState()) {
    getQuizWithQuestionsById();
  }

  Future<void> getQuizWithQuestionsById() async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await QuizService.getQuizWithQuestionsById(quizId);
      var quiz = result.data;

      SelectDataModel? selectedCategory;
      if (quiz!.category != null) {
        selectedCategory = SelectDataModel(
          id: quiz.category!.categoryId, 
          name: quiz.category!.name
        );
      }

      // assign true answer index for each question
      List<QuestionModel> questions = [];
      for (var question in quiz.questions) {
        final trueAnswer = question.answers.where((answer) => answer.isTrueAnswer == true).first;

        question = question.copyWith(trueAnswerIndex: trueAnswer.answerOrder);
        questions = [...questions, question];
      }
      quiz = quiz.copyWith(questions: questions);

      state = state.copyWith(
        quiz: quiz,
        selectedCategory: selectedCategory
      );
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void selectCategory(SelectDataModel category) {
    var quiz = state.quiz;
    state = state.copyWith(selectedCategory: category);

    state = state.copyWith(quiz: quiz);
  }

  void updateDescription(String value) {
    var quiz = state.quiz;
    quiz = quiz?.copyWith(description: value);

    state = state.copyWith(quiz: quiz);
  }
  
  void updateTitle(String value) {
    var quiz = state.quiz;
    quiz = quiz?.copyWith(title: value);

    state = state.copyWith(quiz: quiz);
  }

  void updateTime(int value) {
    var quiz = state.quiz;
    quiz = quiz?.copyWith(time: value);

    state = state.copyWith(quiz: quiz);
  }

  Future<void> pickDescriptionImage(
    Color toolbarColor,
    Color toolbarWidgetColor,
  ) async {
    final image = await pickImage(toolbarColor, toolbarWidgetColor);

    var quiz = state.quiz;
    quiz = quiz?.copyWith(newImage: image);

    state = state.copyWith(quiz: quiz);
  }

  void addAnswer() {
    var answer = AnswerModel(
      answerId: '',
      answerOrder: state.quiz!.questions[state.questionIndex].answers.length,
      questionId: state.quiz!.questions[state.questionIndex].questionId,
      createdBy: '',
      createdTime: DateTime.now(),
      description: '',
      modifiedBy: '',
      modifiedTime: DateTime.now(),
      recordStatus: '',
      version: 0,
      isTrueAnswer: false
    );

    var quiz = state.quiz;

    var currentQuestion = quiz!.questions[state.questionIndex];
    var questions = [...quiz.questions];

    currentQuestion = currentQuestion.copyWith(
      answers: [...currentQuestion.answers, answer],
    );

    questions[state.questionIndex] = currentQuestion;
    quiz = quiz.copyWith(questions: questions);

    state = state.copyWith(quiz: quiz);
  }

  void deleteAnswer(int answerIndex) {
    var quiz = state.quiz;
    var currentQuestion = quiz!.questions[state.questionIndex];
    var questions = [...quiz.questions];

    var answers = [...currentQuestion.answers];
    answers.removeAt(answerIndex);

    currentQuestion = currentQuestion.copyWith(answers: answers);

    if (currentQuestion.trueAnswerIndex == answerIndex) {
      currentQuestion = currentQuestion.copyWith(trueAnswerIndex: null);
    }

    questions[state.questionIndex] = currentQuestion;
    quiz = quiz.copyWith(questions: questions);

    state = state.copyWith(quiz: quiz);
  }

  void updateAnswer(int answerIndex, String text) {
    int index = state.questionIndex;
    var quiz = state.quiz;

    var questions = [...quiz!.questions];
    var currentQuestion = questions[index];

    var answers = [...currentQuestion.answers];
    answers[answerIndex] = answers[answerIndex].copyWith(text: text);

    questions[index] = currentQuestion.copyWith(answers: answers);
    quiz = quiz.copyWith(questions: questions);

    state = state.copyWith(quiz: quiz);
  }

  void determineTrueAnswer(int? answerIndex) {
    int index = state.questionIndex;
    var quiz = state.quiz;

    var questions = [...quiz!.questions];
    var currentQuestion = questions[index];

    var answers = [...currentQuestion.answers];

    for (var i = 0; i < answers.length; i++) {
      answers[i] = answers[i].copyWith(isTrueAnswer: false);
    }

    if (answerIndex != null) {
      answers[answerIndex] = answers[answerIndex].copyWith(isTrueAnswer: true);
    }

    questions[index] = currentQuestion.copyWith(
      answers: answers,
      trueAnswerIndex: answerIndex,
    );
    quiz = quiz.copyWith(questions: questions);

    state = state.copyWith(quiz: quiz);
  }

  void addQuestion() {
    var quiz = state.quiz;
    var question = QuestionModel(
      answers: [],
      createdBy: '',
      createdTime: DateTime.now(),
      description: '',
      modifiedBy: '',
      modifiedTime: DateTime.now(),
      questionId: '',
      questionOrder: quiz!.questions.length,
      quizId: quiz.quizId,
      recordStatus: '',
      text: '',
      version: 0,
    );

    var answer = AnswerModel(
      answerId: '',
      answerOrder: quiz.questions[state.questionIndex].answers.length,
      questionId: '',
      createdBy: '',
      createdTime: DateTime.now(),
      description: '',
      modifiedBy: '',
      modifiedTime: DateTime.now(),
      recordStatus: '',
      version: 0,
      isTrueAnswer: false
    );

    question = question.copyWith(answers: [answer]);
    quiz = quiz.copyWith(questions: [...quiz.questions, question]);

    state = state.copyWith(quiz: quiz);
  }

  Future<void> pickQuestionImage(
    Color toolbarColor,
    Color toolbarWidgetColor,
  ) async {
    final image = await pickImage(toolbarColor, toolbarWidgetColor);

    if (image != null) {
      var quiz = state.quiz;
      var questions = [...quiz!.questions];
      var currentQuestion = questions[state.questionIndex];

      currentQuestion = currentQuestion.copyWith(newImage: image);
      questions[state.questionIndex] = currentQuestion;
      quiz = quiz.copyWith(questions: questions);

      state = state.copyWith(quiz: quiz);
    }
  }

  void deleteQuestion() {
    var quiz = state.quiz;
    var questions = [...quiz!.questions];

    int removedIndex = state.questionIndex;
    // if the current question index is the last question and the last question is removed
    if (state.questionIndex == questions.length - 1) {
      state = state.copyWith(questionIndex: state.questionIndex - 1);
    }

    questions.removeAt(removedIndex);
    quiz = quiz.copyWith(questions: questions);

    state = state.copyWith(quiz: quiz);
  }

  void updateQuestion(String text) {
    int index = state.questionIndex;
    var quiz = state.quiz;
    var questions = [...quiz!.questions];
    var currentQuestion = questions[index];

    questions[index] = currentQuestion.copyWith(text: text);
    quiz = quiz.copyWith(questions: questions);

    state = state.copyWith(quiz: quiz);
  }

  void changeQuestionIndex(int questionIndex) {
    state = state.copyWith(questionIndex: questionIndex);
  }

  Future<bool> updateQuiz() async {
    state = state.copyWith(isLoadingUpdate: true);

    try {
      // assign question order and answer order
      var quiz = state.quiz;

      for (var i = 0; i < quiz!.questions.length; i++) {
        // question order
        quiz.questions[i] = quiz.questions[i].copyWith(questionOrder: i);

        // answer order
        for (var j = 0; j < quiz.questions[i].answers.length; j++) {
          quiz.questions[i].answers[j] = quiz.questions[i].answers[j].copyWith(answerOrder: j);
        }
      }

      Map<String, dynamic> data = await quiz.toJsonAsync();

      // assign new category
      data['categoryId'] = state.selectedCategory?.id;

      var result = await QuizService.updateQuiz(state.quiz!.quizId, data);

      Fluttertoast.showToast(msg: result.messages[0]);

      return true;
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());

      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");

      return false;
    } finally {
      state = state.copyWith(isLoadingUpdate: false);
    }
  }
}

final quizEditProvider = StateNotifierProvider.autoDispose.family<QuizEditNotifier, QuizEditState, String>((ref, quizId) => QuizEditNotifier(quizId));