import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz_history/quiz_history_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/states/quiz/quiz_detail_leaderboard_state.dart';

class QuizDetailLeaderboardNotifier extends StateNotifier<QuizDetailLeaderboardState> {
  final String quizId;
  QuizDetailLeaderboardNotifier(this.quizId): super(QuizDetailLeaderboardState()) {
    getHistoriesByQuizId();
  }

  Future<void> getHistoriesByQuizId() async {
    if (state.pageIndex == 0) {
      state = state.copyWith(isLoading: true);
    } else {
      state = state.copyWith(isLoadingMore: true);
    }

    try {
      final BaseResponse<SearchResponse<QuizHistoryModel>> result = await QuizService.getHistoriesByQuizId(
        quizId, 
        state.pageIndex, 
        state.pageSize
      );

      state = state.copyWith(
        isLoading: false, 
        isLoadingMore: false,
        histories: [...state.histories, ...result.data!.items],
        hasNextPage: result.data!.hasNextPage
      );
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false, isLoadingMore: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false, isLoadingMore: false);
    }
  }

  Future<void> loadMoreDatas() async {
    if (state.hasNextPage) {
      if (state.isLoading || state.isLoadingMore) return;

      state = state.copyWith(pageIndex: state.pageIndex + 1);
      await getHistoriesByQuizId();
    }
  }

  Future<void> refreshCategories() async {
    state = state.copyWith(pageIndex: 0, histories: []);

    await getHistoriesByQuizId();
  }

  Future<void> changeSortDir(String value) async {
    state = state.copyWith(sortDir: value);
    await refreshCategories();
  }
}

final quizDetailLeaderBoardProvider = StateNotifierProvider.autoDispose
  .family<QuizDetailLeaderboardNotifier, QuizDetailLeaderboardState, String>((ref, quizId) => QuizDetailLeaderboardNotifier(quizId));