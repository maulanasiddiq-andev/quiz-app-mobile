import 'package:quiz_app/models/identity/simple_user_model.dart';

class UserDetailState {
  final bool isLoading;
  final SimpleUserModel? user;

  UserDetailState({this.isLoading = false, this.user});

  UserDetailState copyWith({bool? isLoading, SimpleUserModel? user}) {
    return UserDetailState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }
}
