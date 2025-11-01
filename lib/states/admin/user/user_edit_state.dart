import 'package:quiz_app/models/identity/user_model.dart';
import 'package:quiz_app/models/select_data_model.dart';

class UserEditState {
  final bool isLoading;
  final UserModel? user;
  final bool isLoadingUpdate;
  final SelectDataModel? role;

  UserEditState({
    this.isLoading = false,
    this.user,
    this.isLoadingUpdate = false,
    this.role
  });

  UserEditState copyWith({
    bool? isLoading,
    UserModel? user,
    bool? isLoadingUpdate,
    SelectDataModel? role,
  }) {
    return UserEditState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      isLoadingUpdate: isLoadingUpdate ?? this.isLoadingUpdate,
      role: role ?? this.role
    );
  }
}