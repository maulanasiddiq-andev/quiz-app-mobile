import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/identity/simple_user_model.dart';
import 'package:quiz_app/models/quiz/quiz_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';
import 'package:quiz_app/services/user_service.dart';
import 'package:quiz_app/states/quiz/quiz_detail_user_state.dart';

class QuizDetailUserNotifier extends StateNotifier<QuizDetailUserState> {
  final String userId;
  QuizDetailUserNotifier(this.userId) : super(QuizDetailUserState()) {
    getUser(userId);
    getQuizzesByUserId(userId);
  }

  Future getUser(String userId) async {
    state = state.copyWith(isLoadingUser: true);
    
    try {
      final BaseResponse<SimpleUserModel> result = await UserService.getSimpleUser(userId);
      
      state = state.copyWith(
        isLoadingUser: false,
        user: result.data,
      );
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoadingUser: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoadingUser: false);
    }
  }

  Future getQuizzesByUserId(String userId) async {
    state = state.copyWith(isLoading: true);

    try {
      final queryParameters = {
        "pageSize": state.pageSize.toString(),
        "currentPage": state.pageIndex.toString(),
        "orderDir": state.sortDir
      };

      final BaseResponse<SearchResponse<QuizModel>> result = await UserService.getQuizzesByUserId(userId, queryParameters);

      state = state.copyWith(
        isLoading: false,
        quizzes: result.data?.items,
      );
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadMoreQuizzes() async {
    if (state.hasNextPage) {
      if (state.isLoading || state.isLoadingMore) return;

      state = state.copyWith(pageIndex: state.pageIndex + 1);
      await getQuizzesByUserId(userId);
    }
  }

  Future<void> refreshQuizzes() async {
    state = state.copyWith(pageIndex: 0, quizzes: []);
    await getQuizzesByUserId(userId);
  }
}

final quizDetailUserProvider = StateNotifierProvider.family.autoDispose<QuizDetailUserNotifier, QuizDetailUserState, String>((ref, userId) => QuizDetailUserNotifier(userId));