import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/states/quiz/quiz_detail_state.dart';

class QuizDetailNotifier extends StateNotifier<QuizDetailState> {
  QuizDetailNotifier() : super(QuizDetailState());

  Future<void> getQuizById(String id) async {
    state = state.copyWith(isLoading: true);
    try {
      final BaseResponse<QuizModel> result = await QuizService.getQuizById(id);

      state = state.copyWith(isLoading: false, quiz: result.data);
    }  on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith();
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith();
    }
  }
}

final quizDetailProvider = StateNotifierProvider<QuizDetailNotifier, QuizDetailState>((ref) => QuizDetailNotifier());