import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/identity/user_model.dart';
import 'package:quiz_app/services/user_service.dart';
import 'package:quiz_app/states/admin/user/user_edit_state.dart';

class UserEditNotifier extends StateNotifier<UserEditState> {
  final String userId;
  UserEditNotifier(this.userId): super(UserEditState()) {
    getUserById(userId);
  }

  Future<void> getUserById(String userId) async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await UserService.getUserById(userId);

      state = state.copyWith(isLoading: false, user: result.data);
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoading: false);
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoading: false);
    }
  }

  void updateName(String value) {
    UserModel? user = state.user?.copyWith(name: value);

    state = state.copyWith(user: user);
  }

  void updateDescription(String value) {
    UserModel? user = state.user?.copyWith(description: value);

    state = state.copyWith(user: user);
  }

  Future<bool> updateUserById() async {
    state = state.copyWith(isLoadingUpdate: true);

    try {
      final result = await UserService.updateUserById(userId, state.user?.toJson());
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

final userEditProvider = StateNotifierProvider.autoDispose.family<UserEditNotifier, UserEditState, String>((ref, userId) => UserEditNotifier(userId));