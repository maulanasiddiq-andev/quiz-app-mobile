import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiz_app/exceptions/api_exception.dart';
import 'package:quiz_app/models/auth/token_model.dart';
import 'package:quiz_app/models/responses/base_response.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:quiz_app/states/auth/register_state.dart';

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier(): super(RegisterState());

  var storage = FlutterSecureStorage();

  Future<bool> register(String email, String name, String username, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final BaseResponse<TokenModel> result = await AuthService.register(email, name, username, password);
      state = state.copyWith(email: email);
      
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
  
  Future<bool> checkOtp(String otpCode) async {
    state = state.copyWith(isLoading: true);

    try {
      final email = state.email!;
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