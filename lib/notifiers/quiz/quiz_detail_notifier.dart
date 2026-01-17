import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/states/quiz/quiz_detail_state.dart';

class QuizDetailNotifier extends StateNotifier<QuizDetailState> {
  final String quizId;
  QuizDetailNotifier(this.quizId) : super(QuizDetailState()) {
    getQuizById();
  }

  Future<void> getQuizById() async {
    state = state.copyWith(isLoading: true);
    try {
      final BaseResponse<QuizModel> result = await QuizService.getQuizById(quizId);

      state = state.copyWith(quiz: result.data);
    }  on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> deleteQuiz(String quizId) async {
    state = state.copyWith(isLoadingDelete: true);

    try {
      await QuizService.deleteQuiz(quizId);

      return true;
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());

      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");

      return false;
    } finally {
      state = state.copyWith(isLoadingDelete: false);
    }
  }
}

final quizDetailProvider = StateNotifierProvider.autoDispose.family<QuizDetailNotifier, QuizDetailState, String>((ref, quizId) => QuizDetailNotifier(quizId));