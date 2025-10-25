import 'package:flutter_riverpod/legacy.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/services/user_service.dart';
import 'package:quiz_app/states/admin/user/user_detail_state.dart';

class UserDetailNotifier extends StateNotifier<UserDetailState> {
  UserDetailNotifier() : super(UserDetailState());

  Future<void> getUserById(String id) async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await UserService.getUserById(id);

      state = state.copyWith(
        isLoading: false,
        user: result.data
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

final userDetailProvider = StateNotifierProvider.autoDispose<UserDetailNotifier, UserDetailState>((ref) => UserDetailNotifier());