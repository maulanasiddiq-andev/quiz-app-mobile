import 'package:quiz_app/models/identity/user_model.dart';

class RegisterState {
  final UserModel? user;
  final bool isLoading;

  RegisterState({
    this.user,
    this.isLoading = false
  });

  RegisterState copyWith({
    UserModel? user,
    bool? isLoading
  }) {
    return RegisterState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading
    );
  }
}