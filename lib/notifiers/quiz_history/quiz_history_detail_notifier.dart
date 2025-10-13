import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz_history/quiz_history_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/services/quiz_history_service.dart';
import 'package:quiz_app/states/quiz_history/quiz_history_detail_state.dart';

class QuizHistoryDetailNotifier extends StateNotifier<QuizHistoryDetailState> {
  QuizHistoryDetailNotifier() : super(QuizHistoryDetailState());

  Future<void> getQuizHistoryById(String id) async {
    state = state.copyWith(isLoading: true, quizHistoryId: id);
    try {
      BaseResponse<QuizHistoryModel> result = await QuizHistoryService.getQuizHistoryById(id);

      if (result.data != null) {
        state = state.copyWith(
          questions: [...state.questions, ...result.data!.questions],
        );
      }

      state = state.copyWith(isLoading: false);
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
    }
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

  void goToQuestion(int index) {
    state = state.copyWith(questionIndex: index);
  }
}

final quizHistoryDetailProvider = StateNotifierProvider.autoDispose<QuizHistoryDetailNotifier, QuizHistoryDetailState>((ref) => QuizHistoryDetailNotifier());