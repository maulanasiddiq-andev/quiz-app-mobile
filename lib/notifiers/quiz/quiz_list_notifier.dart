import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/quiz/category_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/responses/search_responses.dart';
import 'package:quiz_app/services/category_service.dart';
import 'package:quiz_app/services/quiz_service.dart';
import 'package:quiz_app/states/quiz/quiz_list_state.dart';

class QuizListNotifier extends StateNotifier<QuizListState> {
  QuizListNotifier() : super(QuizListState()) {
    getDatas();
  }

  Future<void> getDatas() async {
    await getCategories();
    await getQuizzes();
  }

  Future<void> getQuizzes() async {
    if (state.quizPageIndex == 0) {
      state = state.copyWith(isLoadingQuizzes: true);
    } else {
      state = state.copyWith(isLoadingMoreQuizzes: true);
    }

    try {
      final BaseResponse<SearchResponse<QuizModel>> result =
          await QuizService.getQuizzes(state.quizPageIndex, state.quizPageSize);

      if (result.data != null) {
        state = state.copyWith(
          isLoadingQuizzes: false,
          isLoadingMoreQuizzes: false,
          quizzes: [...state.quizzes, ...result.data!.items],
          quizHasNextPage: result.data!.hasNextPage,
        );
      } else {
        state = state.copyWith(
          isLoadingQuizzes: false,
          isLoadingMoreQuizzes: false,
        );
      }
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoadingQuizzes: false);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoadingQuizzes: false);
    }
  }

  Future<void> getCategories() async {
    if (state.quizPageIndex == 0) {
      state = state.copyWith(isLoadingCategories: true);
    } else {
      state = state.copyWith(isLoadingMoreCategories: true);
    }

    try {
      final BaseResponse<SearchResponse<CategoryModel>> result = await CategoryService.getCategories(state.quizPageIndex, state.quizPageSize);

      if (result.data != null) {
        state = state.copyWith(
          isLoadingCategories: false,
          isLoadingMoreCategories: false,
          categories: [...state.categories, ...result.data!.items],
          categoryHasNextPage: result.data!.hasNextPage,
        );
      } else {
        state = state.copyWith(
          isLoadingCategories: false,
          isLoadingMoreCategories: false,
        );
      }
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoadingCategories: false);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoadingCategories: false);
    }
  }

  Future<void> loadMoreQuizzes() async {
    if (state.quizHasNextPage) {
      if (state.isLoadingQuizzes || state.isLoadingMoreQuizzes) return;

      state = state.copyWith(quizPageIndex: state.quizPageIndex + 1);
      await getQuizzes();
    }
  }

  Future<void> refreshQuizzes() async {
    state = state.copyWith(quizPageIndex: 0, quizzes: []);
    await getQuizzes();
  }
}

final quizListProvider = StateNotifierProvider.autoDispose<QuizListNotifier, QuizListState>((ref) => QuizListNotifier());
