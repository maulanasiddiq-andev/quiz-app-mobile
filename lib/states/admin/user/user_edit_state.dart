import 'package:quiz_app/models/identity/user_model.dart';

class UserEditState {
  final bool isLoading;
  final UserModel? user;
  final bool isLoadingUpdate;

  UserEditState({
    this.isLoading = false,
    this.user,
    this.isLoadingUpdate = false
  });

  UserEditState copyWith({
    bool? isLoading,
    UserModel? user,
    bool? isLoadingUpdate,
  }) {
    return UserEditState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      isLoadingUpdate: isLoadingUpdate ?? this.isLoadingUpdate
    );
  }
}