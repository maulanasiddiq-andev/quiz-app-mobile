import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/services/user_service.dart';
import 'package:quiz_app/states/profile/profile_histories_state.dart';

class ProfileHistoriesNotifier extends StateNotifier<ProfileHistoriesState> {
  ProfileHistoriesNotifier() : super(ProfileHistoriesState()) {
    getHistories();
  }

  Future<void> getHistories() async {
    state = state.copyWith(isLoading: true);
    try {
      var queryParameters = {
        "pageSize": state.pageSize.toString(),
        "currentPage": state.pageIndex.toString(),
      };

      var result = await UserService.getSelfHistory(queryParameters);

      state = state.copyWith(
        histories: result.data!.items,
        hasNextPage: result.data!.hasNextPage,
        hasPreviousPage: result.data!.hasPreviousPage,
      );
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
    } finally {
      state = state.copyWith(isLoading: false, isLoadingMore: false);
    }
  }

  Future<void> loadMoreDatas() async {
    if (state.hasNextPage) {
      if (state.isLoading || state.isLoadingMore) return;

      state = state.copyWith(pageIndex: state.pageIndex + 1);
      await getHistories();
    }
  }

  Future<void> refreshHistories() async {
    state = state.copyWith(pageIndex: 0, histories: []);

    await getHistories();
  }
}

var profileHistoriesProvider = StateNotifierProvider<ProfileHistoriesNotifier, ProfileHistoriesState>((ref) => ProfileHistoriesNotifier());