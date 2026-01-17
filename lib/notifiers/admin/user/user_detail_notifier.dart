import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/services/user_service.dart';
import 'package:quiz_app/states/admin/user/user_detail_state.dart';

class UserDetailNotifier extends StateNotifier<UserDetailState> {
  final String userId;
  UserDetailNotifier(this.userId) : super(UserDetailState()) {
    getUserById(userId);
  }

  Future<void> getUserById(String id) async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await UserService.getUserById(id);

      state = state.copyWith(user: result.data);
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> deleteUser() async {
    state = state.copyWith(isLoadingDelete: true);

    try {
      final result = await UserService.deleteUser(userId);

      state = state.copyWith(isLoadingDelete: false, user: result.data);
      Fluttertoast.showToast(msg: result.messages[0]);

      return true;
    } on ApiException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      state = state.copyWith(isLoadingDelete: false);

      return false;
    } catch (e) {
      Fluttertoast.showToast(msg: "Sedang terjadi masalah");
      state = state.copyWith(isLoadingDelete: false);

      return false;
    }
  }
}

final userDetailProvider = StateNotifierProvider.family.autoDispose<UserDetailNotifier, UserDetailState, String>((ref, userId) => UserDetailNotifier(userId));