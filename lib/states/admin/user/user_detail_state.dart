import 'package:quiz_app/models/identity/user_model.dart';

class UserDetailState {
  final bool isLoading;
  final bool isLoadingDelete;
  final UserModel? user;

  UserDetailState({this.isLoading = false, this.user, this.isLoadingDelete = false});

  UserDetailState copyWith({bool? isLoading, UserModel? user, bool? isLoadingDelete}) {
    return UserDetailState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      isLoadingDelete: isLoadingDelete ?? this.isLoadingDelete
    );
  }
}
