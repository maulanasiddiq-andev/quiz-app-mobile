import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/identity/user_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';
import 'package:quiz_app/services/user_service.dart';
import 'package:quiz_app/states/admin/user/user_list_state.dart';

class UserListNotifier extends StateNotifier<UserListState> {
  UserListNotifier() : super(UserListState()) {
    getUsers();
  }

  Future<void> getUsers() async {
    if (state.pageIndex == 0) {
      state = state.copyWith(isLoading: true);
    } else {
      state = state.copyWith(isLoadingMore: true);
    }

    try {
      final queryParameters = {
        "pageSize": state.pageSize.toString(),
        "currentPage": state.pageIndex.toString(),
        "search": state.search,
        "orderDir": state.sortDir
      };

      final BaseResponse<SearchResponse<UserModel>> result = await UserService.getUsers(queryParameters);

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

  Future<void> loadMoreDatas() async {
    if (state.hasNextPage) {
      if (state.isLoading || state.isLoadingMore) return;

      state = state.copyWith(pageIndex: state.pageIndex + 1);
      await getUsers();
    }
  }

  Future<void> refreshUsers() async {
    state = state.copyWith(pageIndex: 0, users: []);

    await getUsers();
  }

  Future<void> searchUsers(String value) async {
    state = state.copyWith(search: value);
    await refreshUsers();
  }

  Future<void> changeSortDir(String value) async {
    state = state.copyWith(sortDir: value);
    await refreshUsers();
  }

  Future<void> deleteUser(String id) async {
    state = state.copyWith(deletedUserId: id);

    try {
      final result = await UserService.deleteUser(id);

      final users = [...state.users];

      users.removeWhere((c) => c.userId == id);
      state = state.copyWith(users: [...users]);

      Fluttertoast.showToast(msg: result.messages[0]);
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
    }
  }
}

final userListProvider = StateNotifierProvider.autoDispose<UserListNotifier, UserListState>((ref) => UserListNotifier());
