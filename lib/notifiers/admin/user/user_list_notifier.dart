import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/identity/simple_user_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';
import 'package:quiz_app/services/user_service.dart';
import 'package:quiz_app/states/admin/user/user_list_state.dart';

class UserListNotifier extends StateNotifier<UserListState> {
  UserListNotifier() : super(UserListState()) {
    getUsers();
  }

  Future<void> getUsers() async {
    state = state.copyWith(isLoading: true);

    try {
      final BaseResponse<SearchResponse<SimpleUserModel>> result =
          await UserService.getUsers(state.pageIndex, state.pageSize);

      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        users: [...state.users, ...result.data!.items],
        hasNextPage: result.data!.hasNextPage,
        hasPreviousPage: result.data!.hasPreviousPage,
      );
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false, isLoadingMore: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false, isLoadingMore: false);
    }
  }

  Future<void> refreshUsers() async {
    state = state.copyWith(pageIndex: 0, users: []);

    await getUsers();
  }
}

final userListProvider =
    StateNotifierProvider.autoDispose<UserListNotifier, UserListState>(
      (ref) => UserListNotifier(),
    );
