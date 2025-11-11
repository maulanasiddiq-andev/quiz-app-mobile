import 'package:quiz_app/models/identity/role_model.dart';

class RoleDetailState {
  final bool isLoading;
  final RoleModel? role;
  final bool isLoadingDelete;

  RoleDetailState({
    this.isLoading = false,
    this.role,
    this.isLoadingDelete = false
  });

  RoleDetailState copyWith({
    bool? isLoading,
    RoleModel? role,
    bool? isLoadingDelete
  }) {
    return RoleDetailState(
      isLoading: isLoading ?? this.isLoading,
      role: role ?? this.role,
      isLoadingDelete: isLoadingDelete ?? this.isLoadingDelete
    );
  }
}