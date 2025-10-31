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
  final String quizId;
  QuizDetailNotifier(this.quizId) : super(QuizDetailState()) {
    getQuizById();
    getHistoriesByQuizId();
  }

  Future<void> getQuizById() async {
    state = state.copyWith(isLoading: true);
    try {
      final BaseResponse<QuizModel> result = await QuizService.getQuizById(quizId);
      print(result.data?.isTakenByUser);

      state = state.copyWith(isLoading: false, quiz: result.data);
    }  on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> getHistoriesByQuizId() async {
    if (state.historyPageIndex == 0) {
      state = state.copyWith(isLoadingHistories: true);
    } else {
      state = state.copyWith(isLoadingMoreHistories: true);
    }

    try {
      final BaseResponse<SearchResponse<QuizHistoryModel>> result = await QuizService.getHistoriesByQuizId(
        quizId, 
        state.historyPageIndex, 
        state.historyPageSize
      );

      state = state.copyWith(
        isLoadingHistories: false, 
        isLoadingMoreHistories: false,
        histories: [...state.histories, ...result.data!.items],
        historyHasNextPage: result.data!.hasNextPage
      );
    }  on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoadingHistories: false, isLoadingMoreHistories: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoadingHistories: false, isLoadingMoreHistories: false);
    }
  }

  Future<void> loadMoreHistories() async {
    if (state.historyHasNextPage) {
      if (state.isLoadingHistories || state.isLoadingMoreHistories) return;

      state = state.copyWith(historyPageIndex: state.historyPageIndex + 1);
      await getHistoriesByQuizId();
    }
  }
}

final quizDetailProvider = StateNotifierProvider.autoDispose.family<QuizDetailNotifier, QuizDetailState, String>((ref, quizId) => QuizDetailNotifier(quizId));