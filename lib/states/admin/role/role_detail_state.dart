import 'package:quiz_app/models/identity/role_model.dart';

class RoleDetailState {
  final bool isLoading;
  final RoleModel? role;

  RoleDetailState({
    this.isLoading = false,
    this.role
  });

  RoleDetailState copyWith({
    bool? isLoading,
    RoleModel? role
  }) {
    return RoleDetailState(
      isLoading: isLoading ?? this.isLoading,
      role: role ?? this.role
    );
  }
}