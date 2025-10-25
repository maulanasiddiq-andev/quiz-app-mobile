import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/identity/role_with_select_modules_model.dart';
import 'package:quiz_app/models/identity/select_module_model.dart';
import 'package:quiz_app/services/role_service.dart';
import 'package:quiz_app/states/admin/role/role_edit_state.dart';

class RoleEditNotifier extends StateNotifier<RoleEditState> {
  final String roleId;
  RoleEditNotifier(this.roleId) : super(RoleEditState()) {
    getRoleById(roleId);
  }

  Future<void> getRoleById(String roleId) async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await RoleService.getRoleByIdWithSelectableModules(roleId);

      state = state.copyWith(isLoading: false, role: result.data);
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false);
    }
  }

  void updateName(String value) {
    RoleWithSelectModulesModel? role = state.role?.copyWith(name: value);

    state = state.copyWith(role: role);
  }

  void updateDescription(String value) {
    RoleWithSelectModulesModel? role = state.role?.copyWith(description: value);

    state = state.copyWith(role: role);
  }

  void updateRoleModule(int index, bool value) {
    RoleWithSelectModulesModel? role = state.role;
    List<SelectModuleModel> modules = role?.roleModules ?? [];

    SelectModuleModel updatedModule = modules[index].copyWith(
      isSelected: value,
    );
    modules[index] = updatedModule;
    role = role?.copyWith(roleModules: [...modules]);

    state = state.copyWith(role: role);
  }

  Future<bool> updateRoleById() async {
    state = state.copyWith(isLoadingUpdate: false);

    try {
      final result = await RoleService.updateRoleById(
        roleId,
        state.role?.toJson(),
      );

      Fluttertoast.showToast(msg: result.messages[0]);
      return true;
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoadingUpdate: false);

      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoadingUpdate: false);

      return false;
    }
  }
}

final roleEditProvider = StateNotifierProvider.autoDispose
    .family<RoleEditNotifier, RoleEditState, String>(
      (ref, roleId) => RoleEditNotifier(roleId),
    );
