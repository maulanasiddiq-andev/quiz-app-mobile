import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/identity/role_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/models/responses/search_responses.dart';
import 'package:quiz_app/services/role_service.dart';
import 'package:quiz_app/states/admin/role/role_list_state.dart';

class RoleListNotifier extends StateNotifier<RoleListState> {
  RoleListNotifier(): super(RoleListState()) {
    getRoles();
  }

  Future<void> getRoles() async {
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

      final BaseResponse<SearchResponse<RoleModel>> result = await RoleService.getRoles(queryParameters);

      state = state.copyWith(
        roles: [...state.roles, ...result.data!.items],
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

  Future<void> refreshRoles() async {
    state = state.copyWith(pageIndex: 0, roles: []);

    await getRoles();
  }

  Future<void> loadMoreDatas() async {
    if (state.hasNextPage) {
      if (state.isLoading || state.isLoadingMore) return;

      state = state.copyWith(pageIndex: state.pageIndex + 1);
      await getRoles();
    }
  }

  Future<void> searchRoles(String value) async {
    state = state.copyWith(search: value);
    await refreshRoles();
  }

  Future<void> changeSortDir(String value) async {
    state = state.copyWith(sortDir: value);
    await refreshRoles();
  }

  Future<void> deleteRole(String id) async {
    state = state.copyWith(deletedRoleId: id);

    try {
      final result = await RoleService.deleteRole(id);

      final roles = [...state.roles];

      roles.removeWhere((c) => c.roleId == id);
      state = state.copyWith(roles: [...roles]);

      Fluttertoast.showToast(msg: result.messages[0]);
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
    }
  }
}

final roleListProvider = StateNotifierProvider.autoDispose<RoleListNotifier, RoleListState>((ref) => RoleListNotifier());