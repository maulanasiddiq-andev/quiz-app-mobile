import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/services/role_service.dart';
import 'package:quiz_app/states/admin/role/role_detail_state.dart';

class RoleDetailNotifier extends StateNotifier<RoleDetailState> {
  RoleDetailNotifier(): super(RoleDetailState());

  Future<void> getRoleById(String id) async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await RoleService.getRoleById(id);

      state = state.copyWith(
        isLoading: false,
        role: result.data
      );
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false);
    }
  }
}

final roleDetailProvider = StateNotifierProvider.autoDispose<RoleDetailNotifier, RoleDetailState>((ref) => RoleDetailNotifier());