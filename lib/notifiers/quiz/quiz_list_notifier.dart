import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/responses/search_responses.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/states/quiz/quiz_list_state.dart';

class QuizListNotifier extends StateNotifier<QuizListState> {
  QuizListNotifier() : super(QuizListState()) {
    getDatas();
  }

  Future<void> getDatas() async {
    if (state.pageIndex == 0) {
      state = state.copyWith(isLoading: true);
    } else {
      state = state.copyWith(isLoadingMore: true);
    }

    try {
      final BaseResponse<SearchResponse<QuizModel>> result = await QuizService.getQuizzes(state.pageIndex, state.pageSize);

      if (result.data != null) {
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          quizzes: [...state.quizzes, ...result.data!.items],
          hasNextPage: result.data!.hasNextPage,
        );
      } else {
        state = state.copyWith(isLoading: false, isLoadingMore: false);
      }
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith();
    }
  }

  Future<void> loadMoreDatas() async {
    if (state.hasNextPage) {
      if (state.isLoading || state.isLoadingMore) return;

      state = state.copyWith(pageIndex: state.pageIndex + 1);
      await getDatas();
    }
  }

  Future<void> refreshDatas() async {
    state = state.copyWith(pageIndex: 0, quizzes: []);
    await getDatas();
  }
}

final quizListProvider = StateNotifierProvider.autoDispose<QuizListNotifier, QuizListState>((ref) => QuizListNotifier());
