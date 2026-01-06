import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/auth/token_model.dart';
import 'package:quiz_app/models/identity/user_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/states/auth/register_state.dart';

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier(): super(RegisterState());

  var storage = FlutterSecureStorage();

  Future<bool> register(String email, String name, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final BaseResponse<UserModel> result = await AuthService.register(email, name, password);
      state = state.copyWith(user: result.data);
      
      Fluttertoast.showToast(msg: result.messages[0]);
      state = state.copyWith(isLoading: false);

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

  Future<bool> changeEmail(String email) async {
    state = state.copyWith(isLoading: true);

    try {
      var user = state.user;

      // change email
      user = user?.copyWith(email: email);

      // submit the change to API
      var result = await AuthService.changeEmail(user!);

      // update the state
      state = state.copyWith(
        isLoading: false,
        user: result.data
      );

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

  Future<bool> resendOtp() async {
    try {
      var result = await AuthService.resendOtp(state.user!);

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
  
  Future<bool> checkOtp(String otpCode) async {
    state = state.copyWith(isLoading: true);

    try {
      final email = state.user!.email;
      final BaseResponse<TokenModel> result = await AuthService.checkOtp(email, otpCode);
      
      Fluttertoast.showToast(msg: result.messages[0]);
      state = state.copyWith(isLoading: false);

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

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>((ref) => RegisterNotifier());