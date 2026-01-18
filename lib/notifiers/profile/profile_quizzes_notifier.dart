import 'package:flutter_riverpod/legacy.dart';
import 'package:quiz_app/services/user_service.dart';
import 'package:quiz_app/states/profile/profile_quizzes_state.dart';

class ProfileQuizzesNotifier extends StateNotifier<ProfileQuizzesState> {
  ProfileQuizzesNotifier() : super(ProfileQuizzesState()) {
    getQuizzes();
  }

  Future<void> getQuizzes() async {
    state = state.copyWith(isLoading: true);
    try {
      var queryParameters = {
        "pageSize": state.pageSize.toString(),
        "currentPage": state.pageIndex.toString(),
      };

      var result = await UserService.getSelfQuiz(queryParameters);

      state = state.copyWith(
        quizzes: result.data!.items,
        hasNextPage: result.data!.hasNextPage,
        hasPreviousPage: result.data!.hasPreviousPage,
      );
    } catch (e) {
      // ignore error
    } finally {
      state = state.copyWith(isLoading: false, isLoadingMore: false);
    }
  }

  Future<void> loadMoreDatas() async {
    if (state.hasNextPage) {
      if (state.isLoading || state.isLoadingMore) return;

      state = state.copyWith(pageIndex: state.pageIndex + 1);
      await getQuizzes();
    }
  }

  Future<void> refreshQuizzes() async {
    state = state.copyWith(pageIndex: 0, quizzes: []);

    await getQuizzes();
  }
}

var profileQuizzesProvider = StateNotifierProvider<ProfileQuizzesNotifier, ProfileQuizzesState>((ref) => ProfileQuizzesNotifier());