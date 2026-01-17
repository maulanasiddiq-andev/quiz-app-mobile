import 'package:flutter_riverpod/legacy.dart';
import 'package:quiz_app/services/user_service.dart';
import 'package:quiz_app/states/profile/profile_state.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState()) {
    getQuizCount();
    getHistoryCount();
  }

  Future<void> getQuizCount() async {
    state = state.copyWith(isLoadingQuizCount: true);
    try {
      var result = await UserService.getSelfQuizCount();

      state = state.copyWith(quizCount: result.data ?? 0);
    } catch (e) {
      // ignore error
    } finally {
      state = state.copyWith(isLoadingQuizCount: false);
    }
  }

  Future<void> getHistoryCount() async {
    state = state.copyWith(isLoadingHistoryCount: true);
    try {
      var result = await UserService.getSelfHistoryCount();

      state = state.copyWith(historyCount: result.data ?? 0);
    } catch (e) {
      // ignore error
    } finally {
      state = state.copyWith(isLoadingHistoryCount: false);
    }
  }
}

var profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) => ProfileNotifier());