import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/quiz_history/quiz_history_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';
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
      state = state.copyWith(isLoading: false);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getHistoriesByQuizId(String id) async {
    state = state.copyWith(isLoadingHistories: true);
    try {
      final BaseResponse<SearchResponse<QuizHistoryModel>> result = await QuizService.getHistoriesByQuizId(id, 0, 10);

      state = state.copyWith(isLoadingHistories: false, histories: [...state.histories, ...result.data!.items]);
    }  on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoadingHistories: false);
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoadingHistories: false);
    }
  }
}

final quizDetailProvider = StateNotifierProvider.autoDispose<QuizDetailNotifier, QuizDetailState>((ref) => QuizDetailNotifier());