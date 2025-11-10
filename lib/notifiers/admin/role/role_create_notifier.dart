import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/services/role_service.dart';
import 'package:quiz_app/states/admin/role/role_create_state.dart';

class RoleCreateNotifier extends StateNotifier<RoleCreateState> {
  RoleCreateNotifier(): super(RoleCreateState());

  Future<bool> createCategory(String name, String description, bool isMain) async {
    state = state.copyWith(isLoading: true);

    try {
      Map<String, dynamic> data = {
        "name": name,
        "description": description,
        "isMain": isMain
      };

      final result = await RoleService.createRole(data);
      Fluttertoast.showToast(msg: result.messages[0]);

      return true;
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);

      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false);

      return false;
    }
  }
}

final roleCreateProvider = StateNotifierProvider.autoDispose<RoleCreateNotifier, RoleCreateState>((ref) => RoleCreateNotifier());