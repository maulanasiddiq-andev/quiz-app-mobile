import 'package:quiz_app/models/identity/user_model.dart';

class UserDetailState {
  final bool isLoading;
  final UserModel? user;

  UserDetailState({this.isLoading = false, this.user});

  UserDetailState copyWith({bool? isLoading, UserModel? user}) {
    return UserDetailState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }
}
